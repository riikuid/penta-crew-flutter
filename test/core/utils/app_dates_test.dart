import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/utils/app_dates.dart';

void main() {
  final now = DateTime(2026, 10, 2, 9);

  group('AppDates', () {
    test('prototype formats', () {
      final d = DateTime(2026, 10, 5, 14);
      expect(AppDates.dayStamp(d), 'MON 05 OCT');
      expect(AppDates.dayNumber(d), '05');
      expect(AppDates.weekday(d), 'MON');
      expect(AppDates.month(d), 'OCT');
      expect(AppDates.long(d), 'Monday, 5 October 2026');
      expect(AppDates.short(d), '5 Oct 2026');
      expect(AppDates.shortWithTime(DateTime(2026, 9, 25, 10, 12)), '25 Sep 10:12');
      expect(AppDates.monthYear(DateTime(2026, 7, 4)), 'Jul 2026');
      expect(AppDates.stampWithTime(DateTime(2026, 9, 25, 9, 40)), '25 SEP 2026 · 09:40');
      expect(AppDates.closes(DateTime(2026, 9, 28, 23, 59)), 'Closes 28 Sep');
    });

    test('deadline chip copy', () {
      expect(AppDates.deadline(DateTime(2026, 10, 5, 23, 59), now: now), '3 days left');
      expect(AppDates.deadline(DateTime(2026, 10, 3, 23, 59), now: now), '1 day left');
      expect(AppDates.deadline(DateTime(2026, 10, 2, 23, 59), now: now), 'Last day');
      expect(AppDates.deadline(DateTime(2026, 10, 10, 23, 59), now: now), 'Apply by 10 Oct');
    });

    test('daysUntil ignores time of day', () {
      expect(AppDates.daysUntil(DateTime(2026, 10, 10, 1), now: now), 8);
      expect(AppDates.daysUntil(DateTime(2026, 10, 2, 23), now: now), 0);
    });
  });
}
