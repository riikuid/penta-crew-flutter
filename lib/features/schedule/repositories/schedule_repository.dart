import 'package:dio/dio.dart';

import '../../../core/network/dio_call.dart';
import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../events/models/application.dart';

/// Pure HTTP. One method per endpoint (contract §5), no side effects.
class ScheduleRepository {
  const ScheduleRepository(this._dio);

  final Dio _dio;

  /// §5.1 — `selected` applications with `event.date ≥ today`, sorted by
  /// date/time ASC. The first item is "Next" (D1) and Home's next shift.
  Future<Result<Paginated<Application>>> getUpcoming({
    required int page,
    int perPage = 20,
  }) => dioCall(
    () => _dio.get(
      '/schedule/upcoming',
      queryParameters: {'page': page, 'per_page': perPage},
    ),
    parse: (body) => Paginated.fromJson(body, Application.fromJson),
  );

  /// §5.2 — past `selected` (Completed) + `not_selected`, date DESC.
  /// `meta.summary` → `HistorySummary.fromMeta(page.meta)`.
  Future<Result<Paginated<Application>>> getHistory({
    required int page,
    int perPage = 20,
  }) => dioCall(
    () => _dio.get(
      '/schedule/history',
      queryParameters: {'page': page, 'per_page': perPage},
    ),
    parse: (body) => Paginated.fromJson(body, Application.fromJson),
  );
}
