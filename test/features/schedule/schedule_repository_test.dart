import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:penta_crew/features/schedule/repositories/schedule_repository.dart';

import '../../helpers/stub_adapter.dart';
import '../events/event_models_test.dart' show applicationJson;

void main() {
  group('ScheduleRepository', () {
    test('getHistory parses applications and meta.summary', () async {
      final adapter = StubAdapter.json({
        'data': [
          {...applicationJson, 'status': 'selected'},
          {...applicationJson, 'id': 302, 'status': 'not_selected'},
        ],
        'meta': {
          'current_page': 1,
          'last_page': 1,
          'total': 7,
          'summary': {'worked_count': 6, 'worked_since': '2026-07-01'},
        },
      });
      final repo = ScheduleRepository(stubDio(adapter));

      final result = await repo.getHistory(page: 1);

      expect(adapter.lastRequest?.path, '/schedule/history');
      final page = (result as Success).value;
      expect(page.data, hasLength(2));
      final summary = HistorySummary.fromMeta(page.meta);
      expect(summary.workedCount, 6);
      expect(summary.workedSince, DateTime(2026, 7, 1));
    });

    test('getUpcoming hits /schedule/upcoming with paging', () async {
      final adapter = StubAdapter.json({'data': [], 'meta': {'total': 0}});
      final repo = ScheduleRepository(stubDio(adapter));

      final result = await repo.getUpcoming(page: 1, perPage: 1);

      expect(adapter.lastRequest?.path, '/schedule/upcoming');
      expect(adapter.lastRequest?.queryParameters, {'page': 1, 'per_page': 1});
      expect((result as Success).value.isEmpty, isTrue);
    });
  });
}
