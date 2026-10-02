import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/session/session_events.dart';
import '../../../../core/session/session_info.dart';
import '../../../../core/session/session_storage.dart';
import '../../../../core/usecase/usecase.dart';
import '../../models/user.dart';
import '../../usecases/get_me.dart';
import '../../usecases/logout.dart';
import 'auth_state.dart';

/// The one global cubit: owns the session and feeds the router (as [SessionInfo]).
/// Signing in is `LoginCubit`'s job; it hands the user over via [setAuthenticated].
class AuthCubit extends Cubit<AuthState> implements SessionInfo {
  AuthCubit({
    required this._getMe,
    required this._logout,
    required this._storage,
    required SessionEvents events,
  }) : super(const AuthState.unknown()) {
    _eventsSub = events.stream.listen(_onSessionEvent);
  }

  final GetMe _getMe;
  final Logout _logout;
  final SessionStorage _storage;
  late final StreamSubscription<SessionEvent> _eventsSub;

  // --- SessionInfo -----------------------------------------------------------

  @override
  bool get isResolving => state is AuthUnknown;

  @override
  bool get isAuthenticated => state is Authenticated;

  @override
  bool get isVerified => user?.isVerified ?? false;

  @override
  Set<String> get permissions => switch (state) {
    Authenticated(:final user) => user.permissions,
    _ => const {},
  };

  User? get user => switch (state) {
    Authenticated(:final user) => user,
    _ => null,
  };

  // --- Actions ---------------------------------------------------------------

  /// Verify the stored token at startup (and on retry from the splash screen).
  Future<void> checkSession() async {
    if (state is! AuthUnknown) emit(const AuthState.unknown());

    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      emit(const AuthState.unauthenticated());
      return;
    }

    switch (await _getMe(const NoParams())) {
      case Success(:final value):
        emit(AuthState.authenticated(value));
      case Failed(isUnauthorized: true):
        await _storage.clear();
        emit(const AuthState.unauthenticated(sessionExpired: true));
      case Failed(:final message):
        emit(AuthState.unavailable(message));
    }
  }

  void setAuthenticated(User user) => emit(AuthState.authenticated(user));

  /// Apply a profile change without a round-trip.
  void updateUser(User user) {
    if (isAuthenticated) emit(AuthState.authenticated(user));
  }

  Future<void> logout() async {
    await _logout(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  // --- Internals -------------------------------------------------------------

  Future<void> _onSessionEvent(SessionEvent event) async {
    if (event != SessionEvent.unauthorized) return;
    // Several parallel requests may 401 at once; only react to the first.
    if (!isAuthenticated) return;
    await _storage.clear();
    emit(const AuthState.unauthenticated(sessionExpired: true));
  }

  @override
  Future<void> close() async {
    await _eventsSub.cancel();
    return super.close();
  }
}
