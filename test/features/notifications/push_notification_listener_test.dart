import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/push/push_service.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/session/session_info.dart';
import 'package:penta_crew/features/auth/usecases/update_device_token.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/features/notifications/push_notification_listener.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _MockGoRouter extends Mock implements GoRouter {}

class _MockUpdateDeviceToken extends Mock implements UpdateDeviceToken {}

class _FakeSession implements SessionInfo {
  @override
  bool isResolving = false;
  @override
  bool isAuthenticated = true;
  @override
  bool isVerified = true;
  @override
  Set<String> permissions = const {};
}

/// Hand-rolled [PushService]: the listener only touches the three streams.
class _FakePushService implements PushService {
  final opened = StreamController<PushMessage>.broadcast(sync: true);
  final tokens = StreamController<String>.broadcast(sync: true);

  @override
  Stream<PushMessage> get onMessageOpened => opened.stream;

  @override
  Stream<String> get onTokenRefresh => tokens.stream;

  @override
  Stream<PushMessage> get onMessage => const Stream.empty();

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> deleteToken() async {}

  Future<void> close() async {
    await opened.close();
    await tokens.close();
  }
}

void main() {
  late _FakePushService pushService;
  late _FakeSession session;
  late StreamController<Object?> sessionChanges;
  late _MockGoRouter router;
  late _MockUpdateDeviceToken updateDeviceToken;
  late Talker talker;
  late PushNotificationListener listener;

  setUpAll(() {
    registerFallbackValue(const UpdateDeviceTokenParams(deviceToken: ''));
  });

  setUp(() {
    pushService = _FakePushService();
    session = _FakeSession();
    sessionChanges = StreamController<Object?>.broadcast(sync: true);
    router = _MockGoRouter();
    updateDeviceToken = _MockUpdateDeviceToken();
    talker = Talker(settings: TalkerSettings(enabled: false));
    when(() => router.go(any())).thenReturn(null);
    when(() => router.push<Object?>(any())).thenAnswer((_) async => null);
    when(() => updateDeviceToken(any()))
        .thenAnswer((_) async => const Result.success(null));
    listener = PushNotificationListener(
      pushService: pushService,
      session: session,
      sessionChanges: sessionChanges.stream,
      router: router,
      updateDeviceToken: updateDeviceToken,
      talker: talker,
    );
  });

  tearDown(() async {
    await listener.dispose();
    await pushService.close();
    await sessionChanges.close();
  });

  void tap(Map<String, dynamic> data) =>
      pushService.opened.add(PushMessage(data: data));

  group('message opened while the session is resolved', () {
    test('application.selected with a string event_id pushes event detail', () {
      listener.start();

      tap(const {'type': 'application.selected', 'event_id': '41'});

      verify(() => router.push<Object?>(EventsRoutes.detail(41))).called(1);
      verifyNever(() => router.go(any()));
    });

    test('verification.approved goes to Home', () {
      listener.start();

      tap(const {'type': 'verification.approved'});

      verify(() => router.go(AppRoutes.home)).called(1);
      verifyNever(() => router.push<Object?>(any()));
    });

    test('unknown or missing type does not navigate', () {
      listener.start();

      tap(const {'type': 'event.cancelled', 'event_id': '41'});
      tap(const {'event_id': '41'});

      verifyNever(() => router.go(any()));
      verifyNever(() => router.push<Object?>(any()));
    });

    test('event.published without event_id does not navigate', () {
      listener.start();

      tap(const {'type': 'event.published'});

      verifyNever(() => router.go(any()));
      verifyNever(() => router.push<Object?>(any()));
    });
  });

  group('message opened while the session is resolving', () {
    test('is deferred until a session change reports resolved, once', () {
      session.isResolving = true;
      listener.start();

      tap(const {'type': 'application.selected', 'event_id': '41'});
      verifyNever(() => router.push<Object?>(any()));

      // Still resolving: nothing happens yet.
      sessionChanges.add(null);
      verifyNever(() => router.push<Object?>(any()));

      session.isResolving = false;
      sessionChanges.add(null);
      verify(() => router.push<Object?>(EventsRoutes.detail(41))).called(1);

      // A later session change does not re-open it.
      sessionChanges.add(null);
      verifyNever(() => router.push<Object?>(any()));
    });

    test('only the latest of several deferred taps is opened', () {
      session.isResolving = true;
      listener.start();

      tap(const {'type': 'application.selected', 'event_id': '41'});
      tap(const {'type': 'event.published', 'event_id': '42'});

      session.isResolving = false;
      sessionChanges.add(null);

      verify(() => router.push<Object?>(EventsRoutes.detail(42))).called(1);
      verifyNever(() => router.push<Object?>(EventsRoutes.detail(41)));
    });
  });

  group('token refresh', () {
    test(
      'while authenticated forwards the token to UpdateDeviceToken',
      () async {
        listener.start();

        pushService.tokens.add('token-1');
        await pumpEventQueue();

        final params =
            verify(() => updateDeviceToken(captureAny())).captured.single
                as UpdateDeviceTokenParams;
        expect(params.deviceToken, 'token-1');
      },
    );

    test('while signed out is ignored', () async {
      session.isAuthenticated = false;
      listener.start();

      pushService.tokens.add('token-1');
      await pumpEventQueue();

      verifyNever(() => updateDeviceToken(any()));
    });

    test('a Failed result is swallowed and the stream keeps working', () async {
      when(
        () => updateDeviceToken(any()),
      ).thenAnswer((_) async => const Result.failed('nope', statusCode: 500));
      listener.start();

      pushService.tokens.add('token-1');
      await pumpEventQueue();
      pushService.tokens.add('token-2');
      await pumpEventQueue();

      verify(() => updateDeviceToken(any())).called(2);
    });

    test('a thrown error is logged and the stream keeps working', () async {
      when(() => updateDeviceToken(any())).thenThrow(StateError('boom'));
      listener.start();

      pushService.tokens.add('token-1');
      await pumpEventQueue();
      pushService.tokens.add('token-2');
      await pumpEventQueue();

      verify(() => updateDeviceToken(any())).called(2);
    });
  });

  group('lifecycle', () {
    test('dispose cancels every subscription', () async {
      session.isResolving = true;
      listener.start();
      tap(const {'type': 'application.selected', 'event_id': '41'});

      await listener.dispose();

      session.isResolving = false;
      sessionChanges.add(null);
      tap(const {'type': 'verification.approved'});
      pushService.tokens.add('token-1');
      await pumpEventQueue();

      verifyNever(() => router.go(any()));
      verifyNever(() => router.push<Object?>(any()));
      verifyNever(() => updateDeviceToken(any()));
    });

    test('start twice still navigates once per message', () {
      listener.start();
      listener.start();

      tap(const {'type': 'application.selected', 'event_id': '41'});

      verify(() => router.push<Object?>(EventsRoutes.detail(41))).called(1);
    });
  });
}
