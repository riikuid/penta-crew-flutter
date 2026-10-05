import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/features/auth/models/auth_response.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/register_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/register_state.dart';
import 'package:penta_crew/features/auth/usecases/get_branches.dart';
import 'package:penta_crew/features/auth/usecases/register.dart';

class _MockRegister extends Mock implements Register {}

class _MockGetBranches extends Mock implements GetBranches {}

class _MockAuthCubit extends Mock implements AuthCubit {}

class _FakeRegisterParams extends Fake implements RegisterParams {}

const _jakarta = Branch(id: 1, name: 'Jakarta');
const _bandung = Branch(id: 2, name: 'Bandung');
final _dateOfBirth = DateTime(1999, 4, 12);
const _user = User(
  id: 42,
  name: 'Rina Maharani',
  email: 'rina@example.com',
  verificationStatus: VerificationStatus.pending,
);

/// Step 01 values that pass validation.
const _accountStep = RegisterState(
  step: RegisterStep.profile,
  name: 'Rina Maharani',
  email: 'rina@example.com',
  phone: '081234567890',
  password: 'password1',
);

/// Both steps filled in, ready for `submit`.
final _profileStep = _accountStep.copyWith(
  dateOfBirth: _dateOfBirth,
  gender: Gender.female,
  branch: _jakarta,
);

void main() {
  late _MockRegister register;
  late _MockGetBranches getBranches;
  late _MockAuthCubit auth;

  setUpAll(() {
    registerFallbackValue(_FakeRegisterParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(_user);
  });

  setUp(() {
    register = _MockRegister();
    getBranches = _MockGetBranches();
    auth = _MockAuthCubit();
  });

  RegisterCubit build() => RegisterCubit(register, getBranches, auth);

  void submitValidAccountStep(RegisterCubit cubit) => cubit.submitAccountStep(
    name: ' Rina Maharani ',
    email: 'rina@example.com ',
    phone: '081234567890',
    password: 'password1',
    confirmPassword: 'password1',
  );

  group('step 01', () {
    blocTest<RegisterCubit, RegisterState>(
      'valid values → trimmed, stored, moves to step 02',
      build: build,
      act: submitValidAccountStep,
      expect: () => const [_accountStep],
    );

    blocTest<RegisterCubit, RegisterState>(
      'empty form → one copy-table message per field, stays on step 01',
      build: build,
      act: (cubit) => cubit.submitAccountStep(
        name: '',
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
      ),
      expect: () => const [
        RegisterState(
          errors: {
            RegisterField.name: 'Enter your full name.',
            RegisterField.email: 'Enter a valid email address.',
            RegisterField.phone: 'Enter your phone number.',
            RegisterField.password: 'Use at least 8 characters with a number.',
          },
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'weak password / mismatch / bad email are each caught',
      build: build,
      act: (cubit) => cubit.submitAccountStep(
        name: 'Rina',
        email: 'not-an-email',
        phone: '0812',
        password: 'abcdefgh',
        confirmPassword: 'abcdefgi',
      ),
      expect: () => [
        isA<RegisterState>()
            .having((s) => s.step, 'step', RegisterStep.account)
            .having((s) => s.errors, 'errors', const {
              RegisterField.email: 'Enter a valid email address.',
              RegisterField.password:
                  'Use at least 8 characters with a number.',
              RegisterField.passwordConfirmation: "Passwords don't match.",
            }),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'clearError drops only that field; backToAccountStep keeps values',
      build: build,
      seed: () => _accountStep.copyWith(
        errors: const {
          RegisterField.email: 'Taken.',
          RegisterField.phone: 'Bad.',
        },
      ),
      act: (cubit) => cubit
        ..clearError(RegisterField.email)
        ..backToAccountStep(),
      expect: () => [
        _accountStep.copyWith(errors: const {RegisterField.phone: 'Bad.'}),
        _accountStep.copyWith(
          step: RegisterStep.account,
          errors: const {RegisterField.phone: 'Bad.'},
        ),
      ],
    );
  });

  group('branches', () {
    blocTest<RegisterCubit, RegisterState>(
      'loadBranches → loading, then the list',
      setUp: () => when(() => getBranches(any()))
          .thenAnswer((_) async => const Result.success([_jakarta, _bandung])),
      build: build,
      act: (cubit) => cubit.loadBranches(),
      expect: () => const [
        RegisterState(branchesLoading: true),
        RegisterState(branches: [_jakarta, _bandung]),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'loadBranches failure → branchesError, retry clears it',
      setUp: () {
        var calls = 0;
        when(() => getBranches(any())).thenAnswer((_) async {
          calls += 1;
          return calls == 1
              ? const Result.failed('Network error')
              : const Result.success([_jakarta]);
        });
      },
      build: build,
      act: (cubit) async {
        await cubit.loadBranches();
        await cubit.loadBranches();
      },
      expect: () => const [
        RegisterState(branchesLoading: true),
        RegisterState(branchesError: 'Network error'),
        RegisterState(branchesLoading: true),
        RegisterState(branches: [_jakarta]),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'setBranch / setGender / setDateOfBirth clear their own errors',
      build: build,
      seed: () => _accountStep.copyWith(
        errors: const {
          RegisterField.branchId: 'Select your branch.',
          RegisterField.gender: 'Select your gender.',
          RegisterField.dateOfBirth: 'Enter your date of birth.',
        },
      ),
      act: (cubit) => cubit
        ..setBranch(_jakarta)
        ..setGender(Gender.female)
        ..setDateOfBirth(_dateOfBirth),
      verify: (cubit) {
        expect(cubit.state.errors, isEmpty);
        expect(cubit.state.branch, _jakarta);
        expect(cubit.state.gender, Gender.female);
        expect(cubit.state.dateOfBirth, _dateOfBirth);
      },
    );
  });

  group('step 02 submit', () {
    blocTest<RegisterCubit, RegisterState>(
      'missing profile fields → copy-table messages, no request',
      build: build,
      seed: () => _accountStep,
      act: (cubit) => cubit.submit(address: '  '),
      expect: () => [
        _accountStep.copyWith(
          errors: const {
            RegisterField.dateOfBirth: 'Enter your date of birth.',
            RegisterField.gender: 'Select your gender.',
            RegisterField.branchId: 'Select your branch.',
            RegisterField.address: 'Enter your home address.',
          },
        ),
      ],
      verify: (_) => verifyNever(() => register(any())),
    );

    blocTest<RegisterCubit, RegisterState>(
      'success → AuthCubit.setAuthenticated(user) and status success',
      setUp: () => when(() => register(any())).thenAnswer(
        (_) async =>
            const Result.success(AuthResponse(token: 't0k3n', user: _user)),
      ),
      build: build,
      seed: () => _profileStep,
      act: (cubit) => cubit.submit(address: 'Jl. Kemang Raya 10'),
      expect: () => [
        _profileStep.copyWith(
          address: 'Jl. Kemang Raya 10',
          status: RegisterStatus.submitting,
        ),
        _profileStep.copyWith(
          address: 'Jl. Kemang Raya 10',
          status: RegisterStatus.success,
        ),
      ],
      verify: (_) {
        final params =
            verify(() => register(captureAny())).captured.single
                as RegisterParams;
        expect(params.email, 'rina@example.com');
        expect(params.password, 'password1');
        expect(params.profile.toJson(), {
          'name': 'Rina Maharani',
          'phone': '081234567890',
          'date_of_birth': '1999-04-12',
          'gender': 'female',
          'branch_id': 1,
          'address': 'Jl. Kemang Raya 10',
        });
        verify(() => auth.setAuthenticated(_user)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      '422 on a step-01 field → first message per field, back to step 01',
      setUp: () => when(() => register(any())).thenAnswer(
        (_) async => const Result.failed(
          'The given data was invalid.',
          statusCode: 422,
          fieldErrors: {
            'email': ['The email has already been taken.', 'Second.'],
            'address': ['The address field is required.'],
          },
        ),
      ),
      build: build,
      seed: () => _profileStep,
      act: (cubit) => cubit.submit(address: 'Jl. Kemang Raya 10'),
      expect: () => [
        _profileStep.copyWith(
          address: 'Jl. Kemang Raya 10',
          status: RegisterStatus.submitting,
        ),
        _profileStep.copyWith(
          address: 'Jl. Kemang Raya 10',
          step: RegisterStep.account,
          errors: const {
            'email': 'The email has already been taken.',
            'address': 'The address field is required.',
          },
        ),
      ],
      verify: (_) => verifyNever(() => auth.setAuthenticated(any())),
    );

    blocTest<RegisterCubit, RegisterState>(
      '422 on a step-02 field only → stays on step 02',
      setUp: () => when(() => register(any())).thenAnswer(
        (_) async => const Result.failed(
          'The given data was invalid.',
          statusCode: 422,
          fieldErrors: {
            'branch_id': ['The selected branch is invalid.'],
          },
        ),
      ),
      build: build,
      seed: () => _profileStep,
      act: (cubit) => cubit.submit(address: 'Jl. Kemang Raya 10'),
      verify: (cubit) {
        expect(cubit.state.step, RegisterStep.profile);
        expect(cubit.state.status, RegisterStatus.editing);
        expect(cubit.state.errors, {
          'branch_id': 'The selected branch is invalid.',
        });
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'generic failure → status failure with the server message',
      setUp: () => when(() => register(any())).thenAnswer(
        (_) async => const Result.failed('Server unavailable', statusCode: 503),
      ),
      build: build,
      seed: () => _profileStep,
      act: (cubit) => cubit.submit(address: 'Jl. Kemang Raya 10'),
      verify: (cubit) {
        expect(cubit.state.status, RegisterStatus.failure);
        expect(cubit.state.failureMessage, 'Server unavailable');
        expect(cubit.state.step, RegisterStep.profile);
      },
    );
  });
}
