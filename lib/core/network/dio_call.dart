import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_messages.dart';
import '../config/env.dart';
import 'result.dart';

typedef Parser<T> = T Function(dynamic data);

/// Parser for endpoints whose body we do not care about (`Result<void>`).
void noBody(dynamic _) {}

/// Wrap a Dio request into a [Result], translating every failure mode into a
/// [Failed] with a user-safe message. Repositories are the only callers:
///
/// ```dart
/// Future<Result<User>> me() => dioCall(
///   () => _dio.get('/me'),
///   parse: (data) => User.fromJson(data['data'] as Map<String, dynamic>),
/// );
/// ```
Future<Result<T>> dioCall<T>(
  Future<Response<dynamic>> Function() request, {
  required Parser<T> parse,
}) async {
  try {
    final response = await request();
    return Result.success(parse(response.data), statusCode: response.statusCode);
  } on DioException catch (e) {
    return _fromDioException<T>(e);
  } catch (e, st) {
    // Parsing error, unexpected type, etc. Show details only outside prod.
    debugPrintStack(stackTrace: st, label: 'dioCall: $e');
    return Result.failed(Env.isProd ? AppMessages.generic : e.toString());
  }
}

Result<T> _fromDioException<T>(DioException e) {
  final response = e.response;
  final statusCode = response?.statusCode;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return Result.failed(AppMessages.timeout, statusCode: statusCode);
    case DioExceptionType.connectionError:
      return Result.failed(AppMessages.noConnection, statusCode: statusCode);
    case DioExceptionType.cancel:
      return Result.failed(AppMessages.cancelled, statusCode: statusCode);
    case DioExceptionType.unknown:
      final detail = e.error?.toString() ?? e.message;
      return Result.failed(
        Env.isProd ? AppMessages.noConnection : '[${e.type.name}] $detail',
        statusCode: statusCode,
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
      break;
  }

  // Non-2xx with a body. 401 is additionally broadcast by AuthInterceptor.
  final body = response?.data;
  final serverMessage = _serverMessage(body) ?? response?.statusMessage;
  final message =
      serverMessage ?? (Env.isProd ? AppMessages.generic : (e.message ?? 'HTTP error'));

  return Result.failed(
    message,
    statusCode: statusCode,
    code: _errorCode(body),
    fieldErrors: _fieldErrors(body),
  );
}

/// Business error code (`{"message": "...", "code": "deadline_passed"}`).
String? _errorCode(dynamic body) {
  if (body is Map && body['code'] is String) return body['code'] as String;
  return null;
}

String? _serverMessage(dynamic body) {
  if (body is Map && body['message'] is String) return body['message'] as String;
  if (body is Map && body['error'] is String) return body['error'] as String;
  return null;
}

/// Laravel validation shape: `{"errors": {"email": ["The email field is required."]}}`.
Map<String, List<String>>? _fieldErrors(dynamic body) {
  if (body is! Map || body['errors'] is! Map) return null;
  final raw = body['errors'] as Map;
  return {
    for (final entry in raw.entries)
      entry.key.toString(): switch (entry.value) {
        final List list => list.map((e) => e.toString()).toList(),
        final String s => [s],
        _ => const <String>[],
      },
  };
}
