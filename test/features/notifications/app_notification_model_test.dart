import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/notifications/models/app_notification.dart';

const _json = {
  'id': 9001,
  'type': 'application.selected',
  'title': "You're selected",
  'body': 'Arunika annual gathering · 5 Oct · Crew',
  'data': {'event_id': 41, 'application_id': 301},
  'read_at': null,
  'created_at': '2026-09-29T08:00:00+07:00',
};

void main() {
  group('AppNotification', () {
    test('parses the contract sample', () {
      final n = AppNotification.fromJson(_json);
      expect(n.type, NotificationType.applicationSelected);
      expect(n.isRead, isFalse);
      expect(n.eventId, 41);
      expect(n.applicationId, 301);
    });

    test('string ids (FCM data) are tolerated', () {
      final n = AppNotification.fromJson({
        ..._json,
        'data': {'event_id': '41'},
      });
      expect(n.eventId, 41);
      expect(n.applicationId, isNull);
    });

    test('every v1 type maps; unknown falls back', () {
      NotificationType typeOf(String t) =>
          AppNotification.fromJson({..._json, 'type': t}).type;
      expect(typeOf('verification.approved'), NotificationType.verificationApproved);
      expect(typeOf('verification.rejected'), NotificationType.verificationRejected);
      expect(typeOf('event.published'), NotificationType.eventPublished);
      expect(typeOf('application.submitted'), NotificationType.applicationSubmitted);
      expect(typeOf('application.not_selected'), NotificationType.applicationNotSelected);
      expect(typeOf('event.reminder'), NotificationType.unknown);
    });
  });
}
