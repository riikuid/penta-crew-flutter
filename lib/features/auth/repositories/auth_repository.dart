import 'package:dio/dio.dart';

import '../../../core/network/api_json.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_call.dart';
import '../../../core/network/result.dart';
import '../models/auth_response.dart';
import '../models/user.dart';

/// Pure HTTP. One method per endpoint, no side effects — persisting the token
/// is the `Login` usecase's job.
class AuthRepository {
  const AuthRepository(this._dio);

  final Dio _dio;

  Future<Result<AuthResponse>> login({
    required String email,
    required String password,
    String? deviceToken,
  }) => dioCall(
    () => _dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
        'device_token': ?deviceToken,
      },
      options: noAuth(),
    ),
    parse: (body) => AuthResponse.fromJson(asObject(body)),
  );

  Future<Result<User>> me() => dioCall(
    () => _dio.get('/me'),
    parse: (body) => User.fromJson(asObject(body)),
  );

  Future<Result<void>> logout() =>
      dioCall(() => _dio.post('/logout'), parse: noBody);
}
