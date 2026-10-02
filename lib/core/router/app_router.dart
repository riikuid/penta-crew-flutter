import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/events/events_routes.dart';
import '../../features/notifications/notifications_routes.dart';
import '../../features/profile/profile_routes.dart';
import '../../features/sample/sample_routes.dart';
import '../../features/verification/verification_routes.dart';
import '../config/env.dart';
import '../di/locator.dart';
import '../session/session_info.dart';
import '../widgets/state_views.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// Assembles every feature's routes. This, `app_shell.dart` and `locator.dart`
/// are the only files in `core/` that import from `features/`.
GoRouter buildAppRouter({required Listenable refreshListenable}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: !Env.isProd,
    refreshListenable: refreshListenable,
    redirect: _resolveSessionFirst,
    routes: [
      ...authRoutes,
      ...verificationRoutes,
      // The four tab roots (home, events, schedule, profile).
      appShellRoute,
      // Root-level pages shown without the pill nav.
      ...eventsRoutes,
      ...profileRoutes,
      ...notificationsRoutes,
      ...sampleRoutes,
    ],
    errorBuilder: (context, state) => ErrorView(
      message: 'Page not found: ${state.uri}',
      onRetry: () => context.go(AppRoutes.home),
      retryLabel: 'Go home',
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
