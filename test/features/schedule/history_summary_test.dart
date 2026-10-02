import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';

void main() {
  group('HistorySummary', () {
    test('fromMeta reads meta.summary', () {
      final s = HistorySummary.fromMeta({
        'current_page': 1,
        'summary': {'worked_count': 6, 'worked_since': '2026-07-01'},
      });
      expect(s.workedCount, 6);
      expect(s.workedSince, DateTime(2026, 7, 1));
    });

    test('fromMeta without summary is empty', () {
      final s = HistorySummary.fromMeta(const {'current_page': 1});
      expect(s.workedCount, 0);
      expect(s.workedSince, isNull);
    });
  });
}
