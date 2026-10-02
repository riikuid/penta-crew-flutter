import 'package:dio/dio.dart';

import '../../../core/network/api_json.dart';
import '../../../core/network/dio_call.dart';
import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../models/application.dart';
import '../models/event.dart';
import '../models/event_detail.dart';

/// Pure HTTP. One method per endpoint (contract §4), no side effects.
class EventsRepository {
  const EventsRepository(this._dio);

  final Dio _dio;

  /// §4.1 — open events of the user's branch, sorted by `apply_deadline ASC`.
  /// `meta.total` feeds the "3 open" header.
  Future<Result<Paginated<Event>>> getOpenEvents({
    required int branchId,
    required int page,
    int perPage = 20,
    String? search,
  }) => dioCall(
    () => _dio.get(
      '/events',
      queryParameters: {
        'branch_id': branchId,
        'status': 'open',
        'page': page,
        'per_page': perPage,
        'search': ?search,
      },
    ),
    parse: (body) => Paginated.fromJson(body, Event.fromJson),
  );

  /// §4.2 — reachable after close too (opened from Tracked / Schedule).
  Future<Result<EventDetail>> getEventDetail(int id) => dioCall(
    () => _dio.get('/events/$id'),
    parse: (body) => EventDetail.fromJson(asObject(body)),
  );

  /// §4.3 — 422 `code`: closed · already_applied · position_not_matching_role
  /// · date_conflict.
  Future<Result<Application>> apply({
    required int eventId,
    required int positionId,
  }) => dioCall(
    () => _dio.post(
      '/events/$eventId/applications',
      data: {'position_id': positionId},
    ),
    parse: (body) => Application.fromJson(asObject(body)),
  );

  /// §4.4 — 422 `code`: deadline_passed · not_withdrawable.
  Future<Result<void>> withdraw(int applicationId) => dioCall(
    () => _dio.delete('/applications/$applicationId'),
    parse: noBody,
  );

  /// §4.5 — never returns `withdrawn`. Home uses `statuses: [waiting],
  /// perPage: 1` and reads `meta.total`.
  Future<Result<Paginated<Application>>> getApplications({
    List<ApplicationStatus> statuses = const [],
    required int page,
    int perPage = 20,
  }) => dioCall(
    () => _dio.get(
      '/applications',
      queryParameters: {
        if (statuses.isNotEmpty)
          'status': statuses.map(_wireStatus).join(','),
        'page': page,
        'per_page': perPage,
      },
    ),
    parse: (body) => Paginated.fromJson(body, Application.fromJson),
  );
}

String _wireStatus(ApplicationStatus s) => switch (s) {
  ApplicationStatus.waiting => 'waiting',
  ApplicationStatus.selected => 'selected',
  ApplicationStatus.notSelected => 'not_selected',
  ApplicationStatus.withdrawn => 'withdrawn',
  ApplicationStatus.unknown => 'unknown',
};
