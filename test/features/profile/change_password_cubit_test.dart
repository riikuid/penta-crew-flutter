import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/usecases/change_password.dart';
import 'package:penta_crew/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:penta_crew/features/profile/presentation/cubit/change_password_state.dart';

class _MockChangePassword extends Mock implements ChangePassword {}

const _filled = ChangePasswordState(
  currentPassword: 'password1',
  password: 'newpass99',
  confirmation: 'newpass99',
);

void main() {
  late _MockChangePassword changePassword;

  setUpAll(
    () => registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', password: ''),
    ),
  );

  setUp(() => changePassword = _MockChangePassword());

  ChangePasswordCubit build() => ChangePasswordCubit(changePassword);

  group('live rules', () {
    test('all rules fail on the empty state', () {
      const state = ChangePasswordState();
      expect(state.hasMinLength, isFalse);
      expect(state.hasNumber, isFalse);
      expect(state.matches, isFalse);
      expect(state.canSubmit, isFalse);
    });

    test('rules tick off independently', () {
      const short = ChangePasswordState(password: 'abc1', confirmation: 'abc1');
      expect(short.hasMinLength, isFalse);
      expect(short.hasNumber, isTrue);
      expect(short.matches, isTrue);

      const noDigit = ChangePasswordState(
        password: 'abcdefgh',
        confirmation: 'abcdefgh',
      );
      expect(noDigit.hasMinLength, isTrue);
      expect(noDigit.hasNumber, isFalse);

      const mismatch = ChangePasswordState(
        password: 'abcdefg1',
        confirmation: 'abcdefg2',
      );
      expect(mismatch.hasMinLength, isTrue);
      expect(mismatch.hasNumber, isTrue);
      expect(mismatch.matches, isFalse);
    });

    test('canSubmit also needs the current password', () {
      expect(_filled.canSubmit, isTrue);
      expect(_filled.copyWith(currentPassword: '').canSubmit, isFalse);
    });

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'typing updates the state as you go',
      build: build,
      act: (cubit) => cubit
        ..currentPasswordChanged('password1')
        ..passwordChanged('newpass99')
        ..confirmationChanged('newpass99'),
      expect: () => const [
        ChangePasswordState(currentPassword: 'password1'),
        ChangePasswordState(
          currentPassword: 'password1',
          password: 'newpass99',
        ),
        _filled,
      ],
      verify: (cubit) => expect(cubit.state.canSubmit, isTrue),
    );
  });

  group('submit', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'ignored until the rules pass',
      build: build,
      seed: () => const ChangePasswordState(password: 'short'),
      act: (cubit) => cubit.submit(),
      expect: () => const <ChangePasswordState>[],
      verify: (_) => verifyNever(() => changePassword(any())),
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'success → submitting then success, sends current + new',
      setUp: () =>
          when(() => changePassword(any()))
              .thenAnswer((_) async => const Result.success(null)),
      build: build,
      seed: () => _filled,
      act: (cubit) => cubit.submit(),
      expect: () => const [
        ChangePasswordState(
          currentPassword: 'password1',
          password: 'newpass99',
          confirmation: 'newpass99',
          status: ChangePasswordStatus.submitting,
        ),
        ChangePasswordState(
          currentPassword: 'password1',
          password: 'newpass99',
          confirmation: 'newpass99',
          status: ChangePasswordStatus.success,
        ),
      ],
      verify: (_) {
        final params =
            verify(() => changePassword(captureAny())).captured.single
                as ChangePasswordParams;
        expect(params.currentPassword, 'password1');
        expect(params.password, 'newpass99');
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'wrong current password → failure with errors.current_password',
      setUp: () => when(() => changePassword(any())).thenAnswer(
        (_) async => const Result.failed(
          'The given data was invalid.',
          statusCode: 422,
          fieldErrors: {
            'current_password': ['The current password is incorrect.'],
          },
        ),
      ),
      build: build,
      seed: () => _filled,
      act: (cubit) => cubit.submit(),
      expect: () => const [
        ChangePasswordState(
          currentPassword: 'password1',
          password: 'newpass99',
          confirmation: 'newpass99',
          status: ChangePasswordStatus.submitting,
        ),
        ChangePasswordState(
          currentPassword: 'password1',
          password: 'newpass99',
          confirmation: 'newpass99',
          status: ChangePasswordStatus.failure,
          message: 'The given data was invalid.',
          fieldErrors: {
            'current_password': ['The current password is incorrect.'],
          },
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'typing in the current password clears the inline error',
      build: build,
      seed: () => _filled.copyWith(
        status: ChangePasswordStatus.failure,
        fieldErrors: const {
          'current_password': ['The current password is incorrect.'],
        },
      ),
      act: (cubit) => cubit.currentPasswordChanged('password2'),
      expect: () => const [
        ChangePasswordState(
          currentPassword: 'password2',
          password: 'newpass99',
          confirmation: 'newpass99',
        ),
      ],
    );
  });
}
