import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/features/notifications/models/app_notification.dart';

/// "Now" for relative-time copy: Mon 5 Oct 2026, 14:00 local.
final now = DateTime(2026, 10, 5, 14);

/// One `GET /notifications` row; defaults to the contract sample
/// (`application.selected`, unread, created 2 hours before [now]).
AppNotification notification({
  int id = 9001,
  NotificationType type = NotificationType.applicationSelected,
  String title = "You're selected",
  String body = 'Arunika annual gathering · 5 Oct · Crew',
  DateTime? createdAt,
  DateTime? readAt,
}) => AppNotification(
  id: id,
  type: type,
  title: title,
  body: body,
  data: const {'event_id': 41, 'application_id': 301},
  readAt: readAt,
  createdAt: createdAt ?? now.subtract(const Duration(hours: 2)),
);

/// One paginator page with `meta.unread_count`.
Paginated<AppNotification> page(
  List<AppNotification> data, {
  int currentPage = 1,
  int lastPage = 1,
  int? unreadCount,
}) => Paginated(
  data: data,
  currentPage: currentPage,
  lastPage: lastPage,
  total: data.length,
  meta: {
    'current_page': currentPage,
    'last_page': lastPage,
    'unread_count':
        unreadCount ??
        data.where((notification) => !notification.isRead).length,
  },
);
