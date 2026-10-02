import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/repositories/events_repository.dart';

import '../../helpers/stub_adapter.dart';
import 'event_models_test.dart' show applicationJson, eventJson;

void main() {
  group('EventsRepository', () {
    test('getOpenEvents sends branch_id/status/page and parses meta.total', () async {
      final adapter = StubAdapter.json({
        'data': [eventJson],
        'meta': {'current_page': 1, 'last_page': 1, 'total': 3},
      });
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.getOpenEvents(branchId: 1, page: 1, search: 'aru');

      expect(adapter.lastRequest?.path, '/events');
      expect(adapter.lastRequest?.queryParameters, {
        'branch_id': 1,
        'status': 'open',
        'page': 1,
        'per_page': 20,
        'search': 'aru',
      });
      final page = (result as Success).value;
      expect(page.total, 3);
      expect(page.data.single.title, 'Arunika annual gathering');
    });

    test('apply posts position_id and parses the Application', () async {
      final adapter = StubAdapter.json({'data': applicationJson}, status: 201);
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.apply(eventId: 41, positionId: 7);

      expect(adapter.lastRequest?.method, 'POST');
      expect(adapter.lastRequest?.path, '/events/41/applications');
      expect(adapter.lastJsonBody, {'position_id': 7});
      expect((result as Success).value.status, ApplicationStatus.waiting);
    });

    test('apply 422 date_conflict → Failed.code', () async {
      final adapter = StubAdapter.json({
        'message': 'You already have a shift on 5 Oct.',
        'code': 'date_conflict',
      }, status: 422);
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.apply(eventId: 41, positionId: 7);

      final failed = result as Failed;
      expect(failed.isValidation, isTrue);
      expect(failed.code, 'date_conflict');
      expect(failed.fieldErrors, isNull);
    });

    test('withdraw DELETEs the application', () async {
      final adapter = StubAdapter.json({'message': 'ok'});
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.withdraw(301);

      expect(adapter.lastRequest?.method, 'DELETE');
      expect(adapter.lastRequest?.path, '/applications/301');
      expect(result.isSuccess, isTrue);
    });

    test('withdraw after deadline → Failed.code deadline_passed', () async {
      final adapter = StubAdapter.json({
        'message': 'Applications closed on 28 Sep.',
        'code': 'deadline_passed',
      }, status: 422);
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.withdraw(301);

      expect((result as Failed).code, 'deadline_passed');
    });

    test('getApplications joins statuses with a comma', () async {
      final adapter = StubAdapter.json({
        'data': [applicationJson],
        'meta': {'current_page': 1, 'last_page': 1, 'total': 2},
      });
      final repo = EventsRepository(stubDio(adapter));

      final result = await repo.getApplications(
        statuses: const [ApplicationStatus.waiting, ApplicationStatus.notSelected],
        page: 1,
        perPage: 1,
      );

      expect(adapter.lastRequest?.queryParameters, {
        'status': 'waiting,not_selected',
        'page': 1,
        'per_page': 1,
      });
      expect((result as Success).value.total, 2);
    });

    test('getApplications without statuses omits the filter', () async {
      final adapter = StubAdapter.json({'data': [], 'meta': {}});
      final repo = EventsRepository(stubDio(adapter));

      await repo.getApplications(page: 2);

      expect(adapter.lastRequest?.queryParameters, {'page': 2, 'per_page': 20});
    });
  });
}
