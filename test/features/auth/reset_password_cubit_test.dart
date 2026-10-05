import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/reset_password_state.dart';
import 'package:penta_crew/features/auth/usecases/reset_password.dart';

class _MockResetPassword extends Mock implements ResetPassword {}

class _FakeParams extends Fake implements ResetPasswordParams {}

void main() {
  late _MockResetPassword resetPassword;

  setUpAll(() => registerFallbackValue(_FakeParams()));

  setUp(() => resetPassword = _MockResetPassword());

  ResetPasswordCubit build({String token = 'mock-token'}) =>
      ResetPasswordCubit(resetPassword, token: token, email: 'a@b.c');

  test('starts idle with a token, expired without one', () {
    expect(build().state, const ResetPasswordState.idle());
    expect(build(token: '').state, const ResetPasswordState.expired());
  });

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'success → success, params carry token + email + password',
    setUp: () => when(
      () => resetPassword(any()),
    ).thenAnswer((_) async => const Result.success(null)),
    build: build,
    act: (cubit) => cubit.submit('newpass1'),
    expect: () => const [
      ResetPasswordState.submitting(),
      ResetPasswordState.success(),
    ],
    verify: (_) {
      final params =
          verify(() => resetPassword(captureAny())).captured.single
              as ResetPasswordParams;
      expect(params.token, 'mock-token');
      expect(params.email, 'a@b.c');
      expect(params.password, 'newpass1');
    },
  );

  for (final code in ResetPasswordCubit.expiredCodes) {
    blocTest<ResetPasswordCubit, ResetPasswordState>(
      '422 $code → expired',
      setUp: () => when(() => resetPassword(any())).thenAnswer(
        (_) async => Result.failed(
          'This reset link has expired.',
          statusCode: 422,
          code: code,
        ),
      ),
      build: build,
      act: (cubit) => cubit.submit('newpass1'),
      expect: () => const [
        ResetPasswordState.submitting(),
        ResetPasswordState.expired(),
      ],
    );
  }

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'generic failure → failure(message)',
    setUp: () => when(
      () => resetPassword(any()),
    ).thenAnswer((_) async => const Result.failed('Server unavailable')),
    build: build,
    act: (cubit) => cubit.submit('newpass1'),
    expect: () => const [
      ResetPasswordState.submitting(),
      ResetPasswordState.failure('Server unavailable'),
    ],
  );

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'submit is ignored once expired',
    build: () => build(token: ''),
    act: (cubit) => cubit.submit('newpass1'),
    expect: () => const <ResetPasswordState>[],
    verify: (_) => verifyNever(() => resetPassword(any())),
  );
}
