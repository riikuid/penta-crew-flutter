import 'package:intl/intl.dart';

import '../../../core/utils/app_dates.dart';

/// Copy fragments the Events screens need that `AppDates` does not provide
/// (TASK-006: feature-local helpers, `core/utils` untouched). Everything is
/// character-exact to `docs/prototype/screens.html` C1–C10; eyebrow-style
/// strings are returned in natural case because `Eyebrow` uppercases them.
abstract final class EventFormats {
  /// `Closed 28 Sep` — C7 timeline step after the deadline.
  static String closed(DateTime deadline) =>
      'Closed ${DateFormat('d MMM').format(deadline)}';

  /// `Mon, 28 Sep · 18:00` — deadline card (C3), withdraw note (C4/C6).
  static String deadlineStamp(DateTime deadline) =>
      '${DateFormat('EEE, d MMM').format(deadline)} · '
      '${DateFormat('HH:mm').format(deadline)}';

  /// `3 days left` / `1 day left` / `Last day` — C3 deadline sub-eyebrow.
  static String daysLeft(DateTime deadline, {required DateTime now}) {
    final days = AppDates.daysUntil(deadline, now: now);
    if (days <= 0) return 'Last day';
    return days == 1 ? '1 day left' : '$days days left';
  }

  /// `6 hours` / `1 hour` — time rows on C3/C5/C7.
  static String hours(int hours) => hours == 1 ? '1 hour' : '$hours hours';

  /// `02` — tab counts, `02 NEEDED`, `{open_total:02}`.
  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  /// `4 applications` / `1 application` — C2 eyebrow.
  static String applications(int total) =>
      total == 1 ? '1 application' : '$total applications';

  /// `Oct 2026` — C3 date hero month line (rendered uppercase).
  static String monthYear(DateTime date) => DateFormat('MMM yyyy').format(date);

  /// `Monday` — C3 date hero weekday line (rendered uppercase).
  static String weekdayLong(DateTime date) => DateFormat('EEEE').format(date);

  /// `Mon 05 Oct · 14:00–20:00` — C4 sheet eyebrow (rendered uppercase).
  static String dayStampWithTime(DateTime date, String timeRange) =>
      '${DateFormat('EEE dd MMM').format(date)} · $timeRange';

  /// `Mon 05 Oct · as Crew` — C2 card meta (rendered uppercase).
  static String trackedMeta(DateTime date, String roleName) =>
      '${DateFormat('EEE dd MMM').format(date)} · as $roleName';
}
