import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Startup: stored token not yet verified.
  const factory AuthState.unknown() = AuthUnknown;

  const factory AuthState.authenticated(User user) = Authenticated;

  const factory AuthState.unauthenticated({
    @Default(false) bool sessionExpired,
  }) = Unauthenticated;

  /// Token exists but could not be verified (offline, server down).
  /// Splash shows a retry; nothing is cleared.
  const factory AuthState.unavailable(String message) = AuthUnavailable;
}
