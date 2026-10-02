import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/push/push_service.dart';
import 'package:penta_crew/core/session/session_storage.dart';
import 'package:penta_crew/features/auth/models/auth_response.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/repositories/auth_repository.dart';
import 'package:penta_crew/features/auth/usecases/login.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockPushService extends Mock implements PushService {}

const _response = AuthResponse(
  token: 'sanctum-token',
  user: User(id: 1, name: 'Fahmi'),
);
const _params = LoginParams(email: 'a@b.c', password: 'secret');

void main() {
  late _MockAuthRepository repo;
  late _MockPushService push;
  late InMemorySessionStorage storage;
  late Login login;

  setUp(() {
    repo = _MockAuthRepository();
    push = _MockPushService();
    storage = InMemorySessionStorage();
    login = Login(repo, storage, push);
    when(() => push.getToken()).thenAnswer((_) async => 'fcm-device-token');
  });

  Future<Result<AuthResponse>> Function() stubLogin(Result<AuthResponse> r) {
    when(
      () => repo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
        deviceToken: any(named: 'deviceToken'),
      ),
    ).thenAnswer((_) async => r);
    return () => login(_params);
  }

  test('success → token persisted, result passed through', () async {
    final call = stubLogin(const Result.success(_response, statusCode: 200));

    final result = await call();

    expect(result.valueOrNull, _response);
    expect(await storage.readToken(), 'sanctum-token');
  });

  test('passes the push device token to the repository', () async {
    final call = stubLogin(const Result.success(_response));

    await call();

    verify(
      () => repo.login(
        email: 'a@b.c',
        password: 'secret',
        deviceToken: 'fcm-device-token',
      ),
    ).called(1);
  });

  test('no push provider (null token) still logs in', () async {
    when(() => push.getToken()).thenAnswer((_) async => null);
    final call = stubLogin(const Result.success(_response));

    await call();

    verify(
      () => repo.login(email: 'a@b.c', password: 'secret', deviceToken: null),
    ).called(1);
  });

  test('failure → nothing persisted, failure returned as-is', () async {
    final call = stubLogin(
      const Result.failed(
        'Invalid credentials',
        statusCode: 422,
        fieldErrors: {'email': ['Email tidak terdaftar.']},
      ),
    );

    final result = await call();

    expect(result, isA<Failed<AuthResponse>>());
    expect((result as Failed<AuthResponse>).fieldError('email'), 'Email tidak terdaftar.');
    expect(await storage.readToken(), isNull);
  });
}
