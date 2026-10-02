import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/home/home_routes.dart';
import '../../features/sample/sample_routes.dart';
import '../config/env.dart';
import '../di/locator.dart';
import '../session/session_info.dart';
import '../widgets/state_views.dart';
import 'app_routes.dart';

/// Assembles every feature's routes. This and `locator.dart` are the only two
/// files in `core/` that import from `features/`.
GoRouter buildAppRouter({required Listenable refreshListenable}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: !Env.isProd,
    refreshListenable: refreshListenable,
    redirect: _resolveSessionFirst,
    routes: [
      ...authRoutes,
      ...homeRoutes,
      ...sampleRoutes,
      // ...add each feature's routes here.
    ],
    errorBuilder: (context, state) => ErrorView(
      message: 'Halaman tidak ditemukan: ${state.uri}',
      onRetry: () => context.go(AppRoutes.home),
      retryLabel: 'Ke beranda',
    ),
  );
}

/// While the stored token is still being verified, park every navigation on the
/// splash screen and remember where the user wanted to go (deep links).
String? _resolveSessionFirst(BuildContext context, GoRouterState state) {
  final session = sl<SessionInfo>();
  final onSplash = state.matchedLocation == AppRoutes.splash;

  if (session.isResolving) {
    if (onSplash) return null;
    return Uri(
      path: AppRoutes.splash,
      queryParameters: {AppRoutes.fromParam: state.uri.toString()},
    ).toString();
  }

  return null;
}
