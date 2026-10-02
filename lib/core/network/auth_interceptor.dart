import 'package:dio/dio.dart';

import '../session/session_events.dart';
import '../session/session_storage.dart';

/// Request options for endpoints that must NOT carry the bearer token (login,
/// register, forgot password...). Usage: `_dio.post('/login', options: noAuth())`.
Options noAuth() => Options(extra: const {_skipAuthKey: true});

const _skipAuthKey = 'skipAuth';

/// Injects `Authorization: Bearer <token>` and reports `401` responses.
///
/// This class knows nothing about the UI: on 401 it only emits
/// [SessionEvent.unauthorized]. `AuthCubit` subscribes to that stream and
/// decides what to do (clear the session, show a toast, redirect).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._events);

  final SessionStorage _storage;
  final SessionEvents _events;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_skipAuthKey] != true) {
      final token = await _storage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final skipped = err.requestOptions.extra[_skipAuthKey] == true;
    if (!skipped && err.response?.statusCode == 401) {
      _events.emit(SessionEvent.unauthorized);
    }
    handler.next(err);
  }
}
