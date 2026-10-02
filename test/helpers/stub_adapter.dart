import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Records the last request and answers with a canned JSON body, so repository
/// tests can assert on method/path/payload without opening a socket.
class StubAdapter implements HttpClientAdapter {
  StubAdapter.json(Object body, {this.status = 200}) : _body = jsonEncode(body);

  final String _body;
  final int status;

  RequestOptions? lastRequest;

  /// Decoded JSON body of the last request (`null` for FormData / no body).
  Map<String, dynamic>? get lastJsonBody {
    final data = lastRequest?.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      _body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio stubDio(StubAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://test.local'))..httpClientAdapter = adapter;
