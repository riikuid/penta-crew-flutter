import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/features/notifications/models/app_notification.dart';
import 'package:penta_crew/features/notifications/notification_routing.dart';
import 'package:penta_crew/features/verification/verification_routes.dart';

class _MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('routeForNotification (D-06 table)', () {
    const data = <String, dynamic>{'event_id': 41, 'application_id': 301};

    test('verification.approved → Home', () {
      expect(
        routeForNotification(NotificationType.verificationApproved, data),
        AppRoutes.home,
      );
    });

    test('verification.rejected → Verification', () {
      expect(
        routeForNotification(NotificationType.verificationRejected, data),
        VerificationRoutes.root,
      );
    });

    test('event.published and application.* → event detail', () {
      for (final type in [
        NotificationType.eventPublished,
        NotificationType.applicationSubmitted,
        NotificationType.applicationSelected,
        NotificationType.applicationNotSelected,
      ]) {
        expect(
          routeForNotification(type, data),
          EventsRoutes.detail(41),
          reason: type.name,
        );
      }
    });

    test('unknown → stay', () {
      expect(routeForNotification(NotificationType.unknown, data), isNull);
    });

    test('event detail without event_id → stay', () {
      expect(
        routeForNotification(NotificationType.applicationSelected, const {}),
        isNull,
      );
      expect(
        routeForNotification(NotificationType.eventPublished, const {
          'event_id': 'abc',
        }),
        isNull,
      );
    });

    test('string event_id (FCM payload) is parsed', () {
      expect(
        routeForNotification(NotificationType.applicationSelected, const {
          'event_id': '42',
        }),
        '/events/42',
      );
    });
  });

  group('notificationTypeFromWire', () {
    test('maps the six contract names', () {
      expect(
        notificationTypeFromWire('verification.approved'),
        NotificationType.verificationApproved,
      );
      expect(
        notificationTypeFromWire('verification.rejected'),
        NotificationType.verificationRejected,
      );
      expect(
        notificationTypeFromWire('event.published'),
        NotificationType.eventPublished,
      );
      expect(
        notificationTypeFromWire('application.submitted'),
        NotificationType.applicationSubmitted,
      );
      expect(
        notificationTypeFromWire('application.selected'),
        NotificationType.applicationSelected,
      );
      expect(
        notificationTypeFromWire('application.not_selected'),
        NotificationType.applicationNotSelected,
      );
    });

    test('garbage and null → unknown', () {
      expect(
        notificationTypeFromWire('event.cancelled'),
        NotificationType.unknown,
      );
      expect(notificationTypeFromWire(''), NotificationType.unknown);
      expect(notificationTypeFromWire(null), NotificationType.unknown);
    });
  });

  group('openNotificationRoute', () {
    late _MockGoRouter router;

    setUp(() {
      router = _MockGoRouter();
      when(() => router.go(any())).thenReturn(null);
      when(() => router.push<Object?>(any())).thenAnswer((_) async => null);
    });

    test('Home (tab root) is a go, never a push', () {
      openNotificationRoute(router, AppRoutes.home);

      verify(() => router.go(AppRoutes.home)).called(1);
      verifyNever(() => router.push<Object?>(any()));
    });

    test('root-level pages are pushed', () {
      openNotificationRoute(router, EventsRoutes.detail(41));
      openNotificationRoute(router, VerificationRoutes.root);

      verify(() => router.push<Object?>(EventsRoutes.detail(41))).called(1);
      verify(() => router.push<Object?>(VerificationRoutes.root)).called(1);
      verifyNever(() => router.go(any()));
    });
  });
}
