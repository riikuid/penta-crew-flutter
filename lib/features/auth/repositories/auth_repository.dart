import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/json/converters.dart';
import '../../../core/network/api_json.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_call.dart';
import '../../../core/network/result.dart';
import '../models/auth_response.dart';
import '../models/branch.dart';
import '../models/user.dart';

/// `device_platform` value for contract §2.1 / §2.10.
String? devicePlatform() {
  if (kIsWeb) return null;
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  return null;
}

/// Profile fields shared by register (§2.2) and update profile (§2.7).
class ProfileFields {
  const ProfileFields({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.branchId,
    required this.address,
  });

  final String name;
  final String phone;
  final DateTime dateOfBirth;
  final Gender gender;
  final int branchId;
  final String address;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'date_of_birth': const DateOnlyConverter().toJson(dateOfBirth),
    'gender': gender.name,
    'branch_id': branchId,
    'address': address,
  };
}

/// Pure HTTP. One method per endpoint (contract §2–§3), no side effects —
/// persisting the token is the `Login` / `Register` usecase's job.
class AuthRepository {
  const AuthRepository(this._dio);

  final Dio _dio;

  /// §2.1
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
        'device_platform': ?(deviceToken == null ? null : devicePlatform()),
      },
      options: noAuth(),
    ),
    parse: (body) => AuthResponse.fromJson(asObject(body)),
  );

  /// §2.2 — the user comes back signed in with `verification_status: pending`.
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required ProfileFields profile,
    String? deviceToken,
  }) => dioCall(
    () => _dio.post(
      '/register',
      data: {
        ...profile.toJson(),
        'email': email,
        'password': password,
        'password_confirmation': password,
        'device_token': ?deviceToken,
      },
      options: noAuth(),
    ),
    parse: (body) => AuthResponse.fromJson(asObject(body)),
  );

  /// §2.3
  Future<Result<User>> me() => dioCall(
    () => _dio.get('/me'),
    parse: (body) => User.fromJson(asObject(body)),
  );

  /// §2.4
  Future<Result<void>> logout() =>
      dioCall(() => _dio.post('/logout'), parse: noBody);

  /// §2.5 — always 200, never reveals whether the email exists.
  Future<Result<void>> forgotPassword(String email) => dioCall(
    () => _dio.post('/forgot-password', data: {'email': email}, options: noAuth()),
    parse: noBody,
  );

  /// §2.6 — 422 `code: token_expired | token_invalid`.
  Future<Result<void>> resetPassword({
    required String token,
    required String email,
    required String password,
  }) => dioCall(
    () => _dio.post(
      '/reset-password',
      data: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
      options: noAuth(),
    ),
    parse: noBody,
  );

  /// §2.7 — email cannot change; verification status is untouched (D-08).
  Future<Result<User>> updateProfile(ProfileFields profile) => dioCall(
    () => _dio.put('/me/profile', data: profile.toJson()),
    parse: (body) => User.fromJson(asObject(body)),
  );

  /// §2.8 — 422 `errors.current_password` when the current one is wrong.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String password,
  }) => dioCall(
    () => _dio.put(
      '/me/password',
      data: {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': password,
      },
    ),
    parse: noBody,
  );

  /// §2.9 — multipart `avatar`; returns the new URL.
  Future<Result<String>> uploadAvatar(String filePath) => dioCall(
    () async => _dio.post(
      '/me/avatar',
      data: FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      }),
    ),
    parse: (body) => asObject(body)['avatar_url'] as String,
  );

  /// §2.10 — on FCM token refresh.
  Future<Result<void>> updateDeviceToken(String deviceToken) => dioCall(
    () => _dio.put(
      '/me/device-token',
      data: {
        'device_token': deviceToken,
        'device_platform': ?devicePlatform(),
      },
    ),
    parse: noBody,
  );

  /// §2.11 — public, for the registration picker.
  Future<Result<List<Branch>>> getBranches() => dioCall(
    () => _dio.get('/branches', options: noAuth()),
    parse: (body) => asList(body).map(Branch.fromJson).toList(),
  );

  /// §3.1 — only when `rejected`; status goes back to `pending`.
  Future<Result<User>> resubmitVerification() => dioCall(
    () => _dio.post('/me/verification/resubmit'),
    parse: (body) => User.fromJson(asObject(body)),
  );
}
