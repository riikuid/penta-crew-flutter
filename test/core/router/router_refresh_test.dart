import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/router/router_refresh.dart';
import 'package:penta_crew/core/session/session_info.dart';

class _FakeSession implements SessionInfo {
  @override
  bool isResolving = false;
  @override
  bool isAuthenticated = true;
  @override
  bool isVerified = true;
  @override
  Set<String> permissions = const {};
  @override
  bool signedOutByUser = false;
}

void main() {
  late StreamController<int> changes;
  late _FakeSession session;
  late RouterRefresh refresh;
  late int notifications;

  setUp(() {
    changes = StreamController<int>.broadcast(sync: true);
    session = _FakeSession();
    refresh = RouterRefresh(changes.stream, session);
    notifications = 0;
    refresh.addListener(() => notifications++);
  });

  tearDown(() {
    refresh.dispose();
    changes.close();
  });

  test('does not notify on a user-only update', () {
    changes.add(1);
    expect(notifications, 0);
  });

  test('notifies on sign-out and sign-in', () {
    session.isAuthenticated = false;
    changes.add(1);
    expect(notifications, 1);

    session.isAuthenticated = true;
    changes.add(2);
    expect(notifications, 2);
  });

  test('notifies when verification or permissions change', () {
    session.isVerified = false;
    changes.add(1);
    session.permissions = const {'events.view'};
    changes.add(2);
    expect(notifications, 2);
  });
}
