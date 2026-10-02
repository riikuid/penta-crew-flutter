import 'package:dio/dio.dart';

import '../../../core/network/api_json.dart';
import '../../../core/network/dio_call.dart';
import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../models/app_notification.dart';

/// Pure HTTP. One method per endpoint (contract §6), no side effects.
class NotificationsRepository {
  const NotificationsRepository(this._dio);

  final Dio _dio;

  /// §6.1 — `created_at DESC`; `meta.unread_count` on every page.
  Future<Result<Paginated<AppNotification>>> getNotifications({
    required int page,
    int perPage = 20,
  }) => dioCall(
    () => _dio.get(
      '/notifications',
      queryParameters: {'page': page, 'per_page': perPage},
    ),
    parse: (body) => Paginated.fromJson(body, AppNotification.fromJson),
  );

  /// §6.2 — bell badge on Home.
  Future<Result<int>> getUnreadCount() => dioCall(
    () => _dio.get('/notifications/unread-count'),
    parse: (body) => asObject(body)['count'] as int,
  );

  /// §6.3 — idempotent.
  Future<Result<void>> markRead(int id) =>
      dioCall(() => _dio.post('/notifications/$id/read'), parse: noBody);

  /// §6.4
  Future<Result<void>> markAllRead() =>
      dioCall(() => _dio.post('/notifications/read-all'), parse: noBody);
}
