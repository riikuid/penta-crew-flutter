import 'dart:async';

import 'package:flutter/foundation.dart';

/// Re-runs GoRouter redirects whenever any of the given streams emits.
/// Pass the global cubits' `.stream` (AuthCubit) so guards react to login/logout.
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Iterable<Stream<dynamic>> streams) {
    for (final stream in streams) {
      _subscriptions.add(stream.listen((_) => notifyListeners()));
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
