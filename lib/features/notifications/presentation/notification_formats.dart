import 'package:intl/intl.dart';

import '../models/app_notification.dart';

/// The N1 list split into its two sections (`Today` / `Earlier`), each in
/// the order the server returned (`created_at DESC`).
typedef NotificationGroups = ({
  List<AppNotification> today,
  List<AppNotification> earlier,
});

/// Copy fragments the Notifications screen needs (copy-table N1). Everything
/// is English (D-13) and locale-independent on purpose.
///
/// `created_at` arrives as UTC (`DateTime.parse` of an ISO string with an
/// offset); every comparison here converts to local first, so "today" means
/// the user's calendar day.
abstract final class NotificationFormats {
  /// `Just now` (under an hour) / `2 h ago` (today) / `Yesterday` /
  /// `25 Sep` — the row's time line.
  static String relativeTime(DateTime createdAt, {required DateTime now}) {
    final local = createdAt.toLocal();
    final days = _daysBetween(local, now);
    if (days <= 0) {
      final hours = now.difference(local).inHours;
      return hours < 1 ? 'Just now' : '$hours h ago';
    }
    if (days == 1) return 'Yesterday';
    return DateFormat('d MMM').format(local);
  }

  /// `true` when [createdAt] falls on the same local calendar day as [now].
  static bool isToday(DateTime createdAt, {required DateTime now}) =>
      _daysBetween(createdAt.toLocal(), now) == 0;

  /// Splits [notifications] into the `Today` / `Earlier` sections, keeping
  /// the server order inside each.
  static NotificationGroups group(
    List<AppNotification> notifications, {
    required DateTime now,
  }) {
    final today = <AppNotification>[];
    final earlier = <AppNotification>[];
    for (final notification in notifications) {
      (isToday(notification.createdAt, now: now) ? today : earlier).add(
        notification,
      );
    }
    return (today: today, earlier: earlier);
  }

  /// Whole calendar days from [from] to [now] (both already local).
  static int _daysBetween(DateTime from, DateTime now) => DateTime(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime(from.year, from.month, from.day)).inDays;
}
