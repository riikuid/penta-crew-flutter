import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../core/network/result.dart';
import '../../core/push/push_service.dart';
import '../../core/session/session_info.dart';
import '../auth/usecases/update_device_token.dart';
import 'notification_routing.dart';

/// Routes tapped push notifications and keeps the device token fresh (D-06).
///
/// Started once by `App` with the app's root router. [PushService.onMessageOpened]
/// covers both a background tap and a cold start — the Firebase implementation
/// replays `getInitialMessage` into the same stream — so this is the only
/// subscription needed for tap handling.
///
/// Navigation is **deferred while the session is still resolving**: the router
/// parks every navigation on the splash screen until `SessionInfo.isResolving`
/// turns false, so opening the route early would be lost. Only the latest
/// pending path is kept; it is opened on the first [sessionChanges] event that
/// arrives after the session resolved.
///
/// Token refreshes are forwarded to [UpdateDeviceToken] only while signed in;
/// failures are logged via [Talker] and never surfaced to the user.
class PushNotificationListener {
  PushNotificationListener({
    required this._pushService,
    required this._session,
    required this._sessionChanges,
    required this._router,
    required this._updateDeviceToken,
    required this._talker,
  });

  final PushService _pushService;
  final SessionInfo _session;
  final Stream<Object?> _sessionChanges;
  final GoRouter _router;
  final UpdateDeviceToken _updateDeviceToken;
  final Talker _talker;

  StreamSubscription<PushMessage>? _openedSubscription;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<Object?>? _sessionSubscription;

  /// Path from a tap that arrived while the session was still resolving.
  String? _pendingPath;

  bool get _isStarted => _openedSubscription != null;

  /// Subscribes to the push and session streams. Calling it again is a no-op.
  void start() {
    if (_isStarted) return;
    _openedSubscription = _pushService.onMessageOpened.listen(
      _guard(_onMessageOpened, 'onMessageOpened'),
      onError: _onStreamError,
    );
    _tokenSubscription = _pushService.onTokenRefresh.listen(
      _guard(_onTokenRefresh, 'onTokenRefresh'),
      onError: _onStreamError,
    );
    _sessionSubscription = _sessionChanges.listen(
      _guard((_) => _openPendingIfResolved(), 'sessionChanges'),
      onError: _onStreamError,
    );
  }

  /// Cancels every subscription and drops any pending path.
  Future<void> dispose() async {
    await Future.wait([
      _openedSubscription?.cancel() ?? Future<void>.value(),
      _tokenSubscription?.cancel() ?? Future<void>.value(),
      _sessionSubscription?.cancel() ?? Future<void>.value(),
    ]);
    _openedSubscription = null;
    _tokenSubscription = null;
    _sessionSubscription = null;
    _pendingPath = null;
  }

  void _onMessageOpened(PushMessage message) {
    final type = notificationTypeFromWire(message.data['type'] as String?);
    final path = routeForNotification(type, message.data);
    if (path == null) {
      _talker.debug('Push tap ignored (type: ${message.data['type']})');
      return;
    }
    if (_session.isResolving) {
      _pendingPath = path;
      return;
    }
    openNotificationRoute(_router, path);
  }

  void _openPendingIfResolved() {
    final path = _pendingPath;
    if (path == null || _session.isResolving) return;
    _pendingPath = null;
    openNotificationRoute(_router, path);
  }

  Future<void> _onTokenRefresh(String token) async {
    if (!_session.isAuthenticated) return;
    final result = await _updateDeviceToken(
      UpdateDeviceTokenParams(deviceToken: token),
    );
    if (result case Failed(:final message, :final code)) {
      _talker.warning(
        'Device token refresh not saved: $message'
        '${code == null ? '' : ' ($code)'}',
      );
    }
  }

  /// Wraps a stream callback so a thrown error is logged instead of killing
  /// the subscription.
  void Function(T event) _guard<T>(
    FutureOr<void> Function(T event) handler,
    String name,
  ) {
    return (event) async {
      try {
        await handler(event);
      } catch (error, stackTrace) {
        _talker.handle(error, stackTrace, 'PushNotificationListener.$name');
      }
    };
  }

  void _onStreamError(Object error, StackTrace stackTrace) =>
      _talker.handle(error, stackTrace, 'PushNotificationListener stream');
}
