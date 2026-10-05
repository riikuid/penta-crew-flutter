import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/models/auth_response.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/login_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/login_state.dart';
import 'package:penta_crew/features/auth/usecases/login.dart';

class _MockLogin extends Mock implements Login {}

class _MockAuthCubit extends Mock implements AuthCubit {}

class _FakeLoginParams extends Fake implements LoginParams {}

const _user = User(id: 1, name: 'Nadia Putri', email: 'nadia@example.com');

void main() {
  late _MockLogin login;
  late _MockAuthCubit auth;

  setUpAll(() {
    registerFallbackValue(_FakeLoginParams());
    registerFallbackValue(_user);
  });

  setUp(() {
    login = _MockLogin();
    auth = _MockAuthCubit();
  });

  LoginCubit build() => LoginCubit(login, auth);

  Future<void> submit(LoginCubit cubit) =>
      cubit.submit(email: 'nadia@example.com', password: 'password1');

  blocTest<LoginCubit, LoginState>(
    'success → hands the user to AuthCubit and emits success',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async =>
          const Result.success(AuthResponse(token: 't0k3n', user: _user)),
    ),
    build: build,
    act: submit,
    expect: () => const [LoginState.submitting(), LoginState.success()],
    verify: (_) {
      final params = verify(() => login(captureAny())).captured.single;
      expect((params as LoginParams).email, 'nadia@example.com');
      expect(params.password, 'password1');
      verify(() => auth.setAuthenticated(_user)).called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    '401 invalid_credentials → invalidCredentials (A3), nothing on AuthCubit',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async => const Result.failed(
        'Email or password is incorrect',
        statusCode: 401,
        code: LoginCubit.invalidCredentialsCode,
      ),
    ),
    build: build,
    act: submit,
    expect: () => const [
      LoginState.submitting(),
      LoginState.invalidCredentials(),
    ],
    verify: (_) => verifyNever(() => auth.setAuthenticated(any())),
  );

  blocTest<LoginCubit, LoginState>(
    'generic failure → failure with the server message',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async => const Result.failed('Server unavailable', statusCode: 503),
    ),
    build: build,
    act: submit,
    expect: () => const [
      LoginState.submitting(),
      LoginState.failure(message: 'Server unavailable'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    '422 → failure carries fieldErrors for the screen',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async => const Result.failed(
        'The given data was invalid.',
        statusCode: 422,
        fieldErrors: {
          'email': ['The email field is required.'],
        },
      ),
    ),
    build: build,
    act: submit,
    expect: () => const [
      LoginState.submitting(),
      LoginState.failure(
        message: 'The given data was invalid.',
        fieldErrors: {
          'email': ['The email field is required.'],
        },
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'ignores a second submit while one is in flight',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async =>
          const Result.success(AuthResponse(token: 't0k3n', user: _user)),
    ),
    build: build,
    act: (cubit) async {
      final first = submit(cubit);
      await submit(cubit);
      await first;
    },
    expect: () => const [LoginState.submitting(), LoginState.success()],
    verify: (_) => verify(() => login(any())).called(1),
  );
}
