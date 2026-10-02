import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/config/app_messages.dart';
import 'package:penta_crew/core/network/api_json.dart';
import 'package:penta_crew/core/network/dio_call.dart';
import 'package:penta_crew/core/network/result.dart';

/// Adapter that answers every request with a canned response or error, so no
/// socket is ever opened.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter.json(Object body, {this.status = 200})
    : _body = jsonEncode(body),
      _error = null;

  _StubAdapter.error(DioExceptionType type)
    : _body = null,
      status = 0,
      _error = type;

  final String? _body;
  final int status;
  final DioExceptionType? _error;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_error != null) {
      throw DioException(requestOptions: options, type: _error);
    }
    return ResponseBody.fromString(
      _body!,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(HttpClientAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://test.local'))..httpClientAdapter = adapter;

void main() {
  group('dioCall', () {
    test('2xx → Success with parsed value and statusCode', () async {
      final dio = _dio(_StubAdapter.json({'data': {'id': 7}}));

      final result = await dioCall(
        () => dio.get('/x'),
        parse: (body) => asObject(body)['id'] as int,
      );

      expect(result, isA<Success<int>>());
      expect(result.valueOrNull, 7);
      expect(result.statusCode, 200);
    });

    test('parser throwing → Failed (never throws out of dioCall)', () async {
      final dio = _dio(_StubAdapter.json({'data': 'not-an-object'}));

      final result = await dioCall(
        () => dio.get('/x'),
        parse: (body) => asObject(body)['id'] as int,
      );

      expect(result, isA<Failed<int>>());
      // Outside prod the raw error is surfaced to help debugging.
      expect(result.errorMessage, contains('Expected a JSON object'));
    });

    test('422 Laravel body → Failed with message and fieldErrors', () async {
      final dio = _dio(
        _StubAdapter.json(
          {
            'message': 'The given data was invalid.',
            'errors': {
              'email': ['The email field is required.'],
              'password': 'Too short', // single string is tolerated
            },
          },
          status: 422,
        ),
      );

      final result = await dioCall(() => dio.post('/login'), parse: noBody);

      final failed = result as Failed<void>;
      expect(failed.isValidation, isTrue);
      expect(failed.message, 'The given data was invalid.');
      expect(failed.fieldError('email'), 'The email field is required.');
      expect(failed.fieldErrors?['password'], ['Too short']);
    });

    test('401 → Failed with statusCode 401 and server message', () async {
      final dio = _dio(_StubAdapter.json({'message': 'Unauthenticated.'}, status: 401));

      final result = await dioCall(() => dio.get('/me'), parse: noBody);

      final failed = result as Failed<void>;
      expect(failed.isUnauthorized, isTrue);
      expect(failed.message, 'Unauthenticated.');
      expect(failed.fieldErrors, isNull);
    });

    test('500 without message → generic/HTTP message, no crash', () async {
      final dio = _dio(_StubAdapter.json({'trace': '...'}, status: 500));

      final result = await dioCall(() => dio.get('/x'), parse: noBody);

      expect(result.isFailed, isTrue);
      expect(result.statusCode, 500);
    });

    test('connectionTimeout → timeout message', () async {
      final dio = _dio(_StubAdapter.error(DioExceptionType.connectionTimeout));

      final result = await dioCall(() => dio.get('/x'), parse: noBody);

      expect(result.errorMessage, AppMessages.timeout);
      expect(result.statusCode, isNull);
    });

    test('receiveTimeout → timeout message', () async {
      final dio = _dio(_StubAdapter.error(DioExceptionType.receiveTimeout));

      final result = await dioCall(() => dio.get('/x'), parse: noBody);

      expect(result.errorMessage, AppMessages.timeout);
    });

    test('connectionError → no-connection message', () async {
      final dio = _dio(_StubAdapter.error(DioExceptionType.connectionError));

      final result = await dioCall(() => dio.get('/x'), parse: noBody);

      expect(result.errorMessage, AppMessages.noConnection);
    });

    test('cancel → Failed', () async {
      final dio = _dio(_StubAdapter.error(DioExceptionType.cancel));

      final result = await dioCall(() => dio.get('/x'), parse: noBody);

      expect(result.isFailed, isTrue);
    });
  });
}
