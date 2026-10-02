import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/router/route_guard.dart';
import 'package:penta_crew/core/session/session_info.dart';

class _FakeSession implements SessionInfo {
  @override
  bool isResolving = false;
  @override
  bool isAuthenticated = false;
  @override
  Set<String> permissions = const {};
}

/// Minimal router exercising the guards exactly as feature routes do.
GoRouter _router({String initial = '/protected'}) => GoRouter(
  initialLocation: initial,
  routes: [
    GoRoute(path: AppRoutes.login, redirect: guestOnly(), builder: _page),
    GoRoute(path: AppRoutes.home, builder: _page),
    GoRoute(path: AppRoutes.forbidden, builder: _page),
    GoRoute(path: '/protected', redirect: guard(), builder: _page),
    GoRoute(
      path: '/orders',
      redirect: guard(perms: ['order.read']),
      builder: _page,
    ),
    GoRoute(
      path: '/admin',
      redirect: guard(perms: ['user.manage', 'role.manage'], mode: PermMode.all),
      builder: _page,
    ),
    GoRoute(path: '/public', redirect: guard(requireAuth: false), builder: _page),
  ],
);

Widget _page(BuildContext context, GoRouterState state) =>
    Text(state.uri.toString());

Future<GoRouter> _pump(WidgetTester tester, GoRouter router) async {
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  final sl = GetIt.instance;
  late _FakeSession session;

  setUp(() {
    session = _FakeSession();
    sl.registerSingleton<SessionInfo>(session);
  });

  tearDown(() async => sl.reset());

  group('guard()', () {
    testWidgets('unauthenticated → /login?from=<original>', (tester) async {
      final router = await _pump(tester, _router(initial: '/protected?tab=2'));

      expect(router.state.uri.path, AppRoutes.login);
      expect(router.state.uri.queryParameters[AppRoutes.fromParam], '/protected?tab=2');
    });

    testWidgets('authenticated → stays', (tester) async {
      session.isAuthenticated = true;
      final router = await _pump(tester, _router());

      expect(router.state.uri.path, '/protected');
    });

    testWidgets('while resolving → no redirect (splash owns it)', (tester) async {
      session.isResolving = true;
      final router = await _pump(tester, _router());

      expect(router.state.uri.path, '/protected');
    });

    testWidgets('requireAuth: false lets guests through', (tester) async {
      final router = await _pump(tester, _router(initial: '/public'));

      expect(router.state.uri.path, '/public');
    });

    testWidgets('authenticated without permission → /forbidden', (tester) async {
      session
        ..isAuthenticated = true
        ..permissions = {'order.create'};
      final router = await _pump(tester, _router(initial: '/orders'));

      expect(router.state.uri.path, AppRoutes.forbidden);
    });

    testWidgets('PermMode.any: one matching permission is enough', (tester) async {
      session
        ..isAuthenticated = true
        ..permissions = {'order.read'};
      final router = await _pump(tester, _router(initial: '/orders'));

      expect(router.state.uri.path, '/orders');
    });

    testWidgets('PermMode.all: every permission required', (tester) async {
      session
        ..isAuthenticated = true
        ..permissions = {'user.manage'};
      var router = await _pump(tester, _router(initial: '/admin'));
      expect(router.state.uri.path, AppRoutes.forbidden);

      session.permissions = {'user.manage', 'role.manage'};
      router = await _pump(tester, _router(initial: '/admin'));
      expect(router.state.uri.path, '/admin');
    });

    testWidgets('unauthenticated beats permission check', (tester) async {
      final router = await _pump(tester, _router(initial: '/orders'));

      expect(router.state.uri.path, AppRoutes.login);
    });
  });

  group('guestOnly()', () {
    testWidgets('authenticated → home', (tester) async {
      session.isAuthenticated = true;
      final router = await _pump(tester, _router(initial: AppRoutes.login));

      expect(router.state.uri.path, AppRoutes.home);
    });

    testWidgets('guest → stays on login', (tester) async {
      final router = await _pump(tester, _router(initial: AppRoutes.login));

      expect(router.state.uri.path, AppRoutes.login);
    });
  });
}
