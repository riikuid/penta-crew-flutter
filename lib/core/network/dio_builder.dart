import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/env.dart';
import '../session/session_events.dart';
import '../session/session_storage.dart';
import 'auth_interceptor.dart';
import 'mock/mock_interceptor.dart';
import 'mock/mock_server.dart';

/// Single Dio instance for the app, registered as a lazy singleton in the locator.
Dio buildDio({
  required SessionStorage storage,
  required SessionEvents events,
  required Talker talker,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(storage, events));

  // Dev-only in-memory backend (D-13 §2.2). `Env.useMock` is a compile-time
  // constant, so release builds drop this branch and the mock code with it.
  if (Env.useMock) {
    dio.interceptors.add(MockInterceptor(MockServer()));
  }

  if (Env.enableLogging) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
        ),
      ),
    );
  }

  return dio;
}
