import 'dart:async';

import 'package:flutter/foundation.dart';

import '../session/session_info.dart';

/// Re-runs GoRouter redirects when the session the guards look at changes.
/// Emissions that leave it unchanged (e.g. a profile-only `updateUser`) are
/// ignored, otherwise routes whose cubit is built in the route builder are
/// rebuilt and lose their state mid-flow.
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Stream<dynamic> sessionChanges, this._session)
    : _lastKey = _keyOf(_session) {
    _subscription = sessionChanges.listen((_) {
      final key = _keyOf(_session);
      if (key == _lastKey) return;
      _lastKey = key;
      notifyListeners();
    });
  }

  final SessionInfo _session;
  late final StreamSubscription<dynamic> _subscription;
  String _lastKey;

  static String _keyOf(SessionInfo session) {
    final permissions = session.permissions.toList()..sort();
    return '${session.isResolving}|${session.isAuthenticated}|'
        '${session.isVerified}|${permissions.join(',')}';
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
