import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:penta_crew/features/auth/usecases/forgot_password.dart';

class _MockForgotPassword extends Mock implements ForgotPassword {}

class _FakeParams extends Fake implements ForgotPasswordParams {}

void main() {
  late _MockForgotPassword forgotPassword;

  setUpAll(() => registerFallbackValue(_FakeParams()));

  setUp(() => forgotPassword = _MockForgotPassword());

  ForgotPasswordCubit build() => ForgotPasswordCubit(forgotPassword);

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'success → sent(email) with the trimmed email',
    setUp: () =>
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Result.success(null)),
    build: build,
    act: (cubit) => cubit.submit('  nadia@example.com '),
    expect: () => const [
      ForgotPasswordState.submitting(),
      ForgotPasswordState.sent('nadia@example.com'),
    ],
    verify: (_) {
      final params =
          verify(() => forgotPassword(captureAny())).captured.single
              as ForgotPasswordParams;
      expect(params.email, 'nadia@example.com');
    },
  );

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'failure → failure(message), stays on the form',
    setUp: () =>
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Result.failed('Too many attempts.')),
    build: build,
    act: (cubit) => cubit.submit('nadia@example.com'),
    expect: () => const [
      ForgotPasswordState.submitting(),
      ForgotPasswordState.failure('Too many attempts.'),
    ],
  );

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'ignores a second submit while one is in flight',
    setUp: () =>
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Result.success(null)),
    build: build,
    act: (cubit) async {
      final first = cubit.submit('nadia@example.com');
      await cubit.submit('nadia@example.com');
      await first;
    },
    expect: () => const [
      ForgotPasswordState.submitting(),
      ForgotPasswordState.sent('nadia@example.com'),
    ],
    verify: (_) => verify(() => forgotPassword(any())).called(1),
  );
}
