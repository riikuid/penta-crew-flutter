import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../events/events_routes.dart';
import '../verification/verification_routes.dart';
import 'models/app_notification.dart';

/// Where a notification takes the user (D-06 table). Used by the N1 list row
/// tap and by the push-notification handler, so both land in the same place.
///
/// Returns `null` for "stay where you are": the `unknown` type, and the
/// event-detail types when `data.event_id` is missing or not a number.
String? routeForNotification(NotificationType type, Map<String, dynamic> data) {
  switch (type) {
    case NotificationType.verificationApproved:
      return AppRoutes.home;
    case NotificationType.verificationRejected:
      return VerificationRoutes.root;
    case NotificationType.eventPublished:
    case NotificationType.applicationSubmitted:
    case NotificationType.applicationSelected:
    case NotificationType.applicationNotSelected:
      final eventId = tolerantInt(data['event_id']);
      return eventId == null ? null : EventsRoutes.detail(eventId);
    case NotificationType.unknown:
      return null;
  }
}

/// Opens a path from [routeForNotification]: the Home tab root is a `go`
/// (it lives inside the shell), every other target is a root-level page and
/// is pushed so the back header returns to where the user was.
void openNotificationRoute(GoRouter router, String path) {
  if (path == AppRoutes.home) {
    router.go(path);
  } else {
    router.push(path);
  }
}

/// Wire `type` → [NotificationType] for the push handler, whose payload is
/// a flat `Map<String, String>` rather than a full `AppNotification` JSON.
/// Anything unrecognised (or absent) is [NotificationType.unknown].
NotificationType notificationTypeFromWire(String? value) =>
    _notificationTypeByWireName[value] ?? NotificationType.unknown;

/// Mirrors the `@JsonValue` names on [NotificationType] (contract §6).
const Map<String, NotificationType> _notificationTypeByWireName = {
  'verification.approved': NotificationType.verificationApproved,
  'verification.rejected': NotificationType.verificationRejected,
  'event.published': NotificationType.eventPublished,
  'application.submitted': NotificationType.applicationSubmitted,
  'application.selected': NotificationType.applicationSelected,
  'application.not_selected': NotificationType.applicationNotSelected,
};
