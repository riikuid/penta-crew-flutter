import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/session/session_events.dart';
import 'package:penta_crew/core/session/session_storage.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/auth/usecases/get_me.dart';
import 'package:penta_crew/features/auth/usecases/logout.dart';

class _MockGetMe extends Mock implements GetMe {}

class _MockLogout extends Mock implements Logout {}

const _user = User(id: 1, name: 'Fahmi', permissions: {'order.read'});

void main() {
  late _MockGetMe getMe;
  late _MockLogout logout;
  late InMemorySessionStorage storage;
  late SessionEvents events;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    getMe = _MockGetMe();
    logout = _MockLogout();
    storage = InMemorySessionStorage();
    events = SessionEvents();
    when(() => logout(any())).thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() => events.dispose());

  AuthCubit build() =>
      AuthCubit(getMe: getMe, logout: logout, storage: storage, events: events);

  group('checkSession', () {
    blocTest<AuthCubit, AuthState>(
      'no stored token → unauthenticated without calling GetMe',
      build: build,
      act: (c) => c.checkSession(),
      expect: () => const [AuthState.unauthenticated()],
      verify: (_) => verifyNever(() => getMe(any())),
    );

    blocTest<AuthCubit, AuthState>(
      'token + GetMe success → authenticated',
      setUp: () async {
        await storage.saveToken('t0k3n');
        when(() => getMe(any())).thenAnswer((_) async => const Result.success(_user));
      },
      build: build,
      act: (c) => c.checkSession(),
      expect: () => const [AuthState.authenticated(_user)],
      verify: (c) {
        expect(c.isAuthenticated, isTrue);
        expect(c.isResolving, isFalse);
        expect(c.permissions, {'order.read'});
        expect(c.user, _user);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'token + GetMe 401 → unauthenticated(sessionExpired) and token cleared',
      setUp: () async {
        await storage.saveToken('expired');
        when(() => getMe(any())).thenAnswer(
          (_) async => const Result.failed('Unauthenticated.', statusCode: 401),
        );
      },
      build: build,
      act: (c) => c.checkSession(),
      expect: () => const [AuthState.unauthenticated(sessionExpired: true)],
      verify: (_) async => expect(await storage.readToken(), isNull),
    );

    blocTest<AuthCubit, AuthState>(
      'token + GetMe network failure → unavailable, token kept',
      setUp: () async {
        await storage.saveToken('t0k3n');
        when(() => getMe(any())).thenAnswer(
          (_) async => const Result.failed('Tidak dapat terhubung ke server.'),
        );
      },
      build: build,
      act: (c) => c.checkSession(),
      expect: () => const [AuthState.unavailable('Tidak dapat terhubung ke server.')],
      verify: (_) async => expect(await storage.readToken(), 't0k3n'),
    );

    blocTest<AuthCubit, AuthState>(
      'retry from a resolved state goes through unknown again',
      setUp: () async {
        await storage.saveToken('t0k3n');
        when(() => getMe(any())).thenAnswer((_) async => const Result.success(_user));
      },
      build: build,
      seed: () => const AuthState.unavailable('offline'),
      act: (c) => c.checkSession(),
      expect: () => const [AuthState.unknown(), AuthState.authenticated(_user)],
    );
  });

  group('SessionEvents.unauthorized', () {
    blocTest<AuthCubit, AuthState>(
      'while authenticated → single logout even for a burst of 401s',
      setUp: () async => storage.saveToken('t0k3n'),
      build: build,
      seed: () => const AuthState.authenticated(_user),
      act: (c) async {
        events
          ..emit(SessionEvent.unauthorized)
          ..emit(SessionEvent.unauthorized)
          ..emit(SessionEvent.unauthorized);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [AuthState.unauthenticated(sessionExpired: true)],
      verify: (_) async => expect(await storage.readToken(), isNull),
    );

    blocTest<AuthCubit, AuthState>(
      'while not authenticated → ignored',
      build: build,
      seed: () => const AuthState.unauthenticated(),
      act: (c) async {
        events.emit(SessionEvent.unauthorized);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const <AuthState>[],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'calls Logout usecase then emits unauthenticated',
      build: build,
      seed: () => const AuthState.authenticated(_user),
      act: (c) => c.logout(),
      expect: () => const [AuthState.unauthenticated()],
      verify: (_) => verify(() => logout(any())).called(1),
    );
  });

  group('setAuthenticated / updateUser', () {
    blocTest<AuthCubit, AuthState>(
      'setAuthenticated after login',
      build: build,
      seed: () => const AuthState.unauthenticated(),
      act: (c) => c.setAuthenticated(_user),
      expect: () => const [AuthState.authenticated(_user)],
    );

    blocTest<AuthCubit, AuthState>(
      'updateUser is ignored when signed out',
      build: build,
      seed: () => const AuthState.unauthenticated(),
      act: (c) => c.updateUser(_user),
      expect: () => const <AuthState>[],
    );
  });
}
