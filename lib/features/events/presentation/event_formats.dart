import 'package:intl/intl.dart';

import '../../../core/utils/app_dates.dart';

/// Copy fragments the Events screens need that `AppDates` does not provide
/// (TASK-006: feature-local helpers, `core/utils` untouched). Everything is
/// character-exact to `docs/prototype/screens.html` C1–C10; eyebrow-style
/// strings are returned in natural case because `Eyebrow` uppercases them.
///
/// `*_at` instants arrive as UTC (`DateTime.parse` of an ISO string with an
/// offset); anything that prints a clock time converts to local first.
abstract final class EventFormats {
  /// `3 open · Jakarta` — C1 eyebrow (D-10: `meta.total` + user's branch).
  static String openHeader(int total, String branchName) =>
      '$total open · $branchName';

  /// `Closes 28 Sep` — C2/C5 timeline step while the deadline is ahead.
  static String closes(DateTime deadline) =>
      AppDates.closes(deadline.toLocal());

  /// `Closed 28 Sep` — C7 timeline step after the deadline.
  static String closed(DateTime deadline) =>
      'Closed ${DateFormat('d MMM').format(deadline.toLocal())}';

  /// `Mon, 28 Sep · 18:00` — deadline card (C3), withdraw note (C4/C6).
  static String deadlineStamp(DateTime deadline) {
    final local = deadline.toLocal();
    return '${DateFormat('EEE, d MMM').format(local)} · '
        '${DateFormat('HH:mm').format(local)}';
  }

  /// `25 Sep 10:12` — C5/C7 timeline "applied" step.
  static String appliedStamp(DateTime appliedAt) =>
      AppDates.shortWithTime(appliedAt.toLocal());

  /// `3 days left` / `1 day left` / `Last day` — C3 deadline sub-eyebrow.
  static String daysLeft(DateTime deadline, {required DateTime now}) {
    final days = AppDates.daysUntil(deadline.toLocal(), now: now);
    if (days <= 0) return 'Last day';
    return days == 1 ? '1 day left' : '$days days left';
  }

  /// `6 hours` / `1 hour` — time rows on C3/C5/C7.
  static String hours(int hours) => hours == 1 ? '1 hour' : '$hours hours';

  /// `02` — tab counts, `02 NEEDED`, `{open_total:02}`.
  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  /// `02 needed` — position rows (C3) and apply options (C4); rendered
  /// uppercase by the caller.
  static String needed(int count) => '${twoDigits(count)} needed';

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
