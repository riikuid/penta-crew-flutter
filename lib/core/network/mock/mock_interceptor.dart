import 'dart:convert';

import 'package:dio/dio.dart';

import 'mock_server.dart';

/// Short-circuits every request to [MockServer] when `Env.useMock` is on.
/// Installed by `buildDio` *after* `AuthInterceptor` (so the bearer header is
/// already there) and *before* the logger (so mock traffic still shows up in
/// Talker). Error statuses are rejected as `DioExceptionType.badResponse`,
/// exactly like a real server, so `dioCall` needs no special casing.
class MockInterceptor extends Interceptor {
  MockInterceptor(this._server);

  final MockServer _server;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(_server.nextLatency());

    final auth = options.headers['Authorization']?.toString();
    final result = _server.handle(
      method: options.method,
      path: _relativePath(options),
      query: options.queryParameters,
      body: _bodyOf(options.data),
      bearer: auth != null && auth.startsWith('Bearer ')
          ? auth.substring(7)
          : null,
    );

    final response = Response<dynamic>(
      requestOptions: options,
      statusCode: result.status,
      // Round-trip through JSON so nested maps arrive as `Map<String, dynamic>`
      // exactly like a decoded HTTP body (and so the body is proven serialisable).
      data: jsonDecode(jsonEncode(result.body)),
      headers: Headers.fromMap({
        Headers.contentTypeHeader: [Headers.jsonContentType],
      }),
    );

    if (result.isError) {
      handler.reject(
        DioException.badResponse(
          statusCode: result.status,
          requestOptions: options,
          response: response,
        ),
      );
      return;
    }
    handler.resolve(response);
  }

  /// `/login` whether the request used a relative path or a full URL.
  static String _relativePath(RequestOptions options) {
    final basePath = Uri.parse(options.baseUrl).path;
    final path = options.uri.path;
    return path.startsWith(basePath) ? path.substring(basePath.length) : path;
  }

  static Map<String, dynamic>? _bodyOf(Object? data) => switch (data) {
    final Map<String, dynamic> m => m,
    final Map m => Map<String, dynamic>.from(m),
    final FormData f => {for (final e in f.fields) e.key: e.value},
    _ => null,
  };
}
