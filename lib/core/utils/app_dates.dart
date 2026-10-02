import 'package:intl/intl.dart';

/// Date copy exactly as the prototype writes it. All formats are English
/// (D-13 §2.1) and locale-independent on purpose.
abstract final class AppDates {
  /// `MON 05 OCT` — event card header (C1, B1).
  static String dayStamp(DateTime d) =>
      DateFormat('EEE dd MMM').format(d).toUpperCase();

  /// `05` — the big numeral in date blocks (D1, B1 next shift).
  static String dayNumber(DateTime d) => DateFormat('dd').format(d);

  /// `SAT` — weekday eyebrow under the numeral.
  static String weekday(DateTime d) =>
      DateFormat('EEE').format(d).toUpperCase();

  /// `OCT` — month eyebrow.
  static String month(DateTime d) => DateFormat('MMM').format(d).toUpperCase();

  /// `Monday, 5 October 2026` — detail screens (C3–C9).
  static String long(DateTime d) => DateFormat('EEEE, d MMMM yyyy').format(d);

  /// `25 Sep 2026` — timeline sub-labels, profile "member since".
  static String short(DateTime d) => DateFormat('d MMM yyyy').format(d);

  /// `25 Sep 10:12` — C5 timeline "applied".
  static String shortWithTime(DateTime d) =>
      DateFormat('d MMM HH:mm').format(d);

  /// `Jul 2026` — "worked since" (D2, B1).
  static String monthYear(DateTime d) => DateFormat('MMM yyyy').format(d);

  /// `25 SEP 2026 · 09:40` — A6 timeline.
  static String stampWithTime(DateTime d) =>
      '${DateFormat('d MMM yyyy').format(d).toUpperCase()} · ${DateFormat('HH:mm').format(d)}';

  /// Deadline chip copy (C1): `3 days left` / `Last day` when urgent,
  /// otherwise `Apply by 2 Oct`.
  static String deadline(DateTime deadline, {required DateTime now}) {
    final days = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days <= 0) return 'Last day';
    if (days <= 3) return days == 1 ? '1 day left' : '$days days left';
    return 'Apply by ${DateFormat('d MMM').format(deadline)}';
  }

  /// `Closes 28 Sep` — C5 timeline.
  static String closes(DateTime d) => 'Closes ${DateFormat('d MMM').format(d)}';

  /// Days until [date] from [now], for "Your next shift is in 8 days." (B1).
  static int daysUntil(DateTime date, {required DateTime now}) => DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime(now.year, now.month, now.day)).inDays;
}
