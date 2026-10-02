import 'package:go_router/go_router.dart';

import '../di/locator.dart';
import '../session/session_info.dart';
import 'app_routes.dart';

enum PermMode { any, all }

/// Per-route guard.
///
/// ```dart
/// GoRoute(
///   path: '/orders',
///   redirect: guard(perms: [Perms.orderRead]),
///   builder: ...,
/// )
/// ```
///
/// Startup resolution is handled once by the top-level redirect in
/// `app_router.dart`, so by the time this runs the session is known.
GoRouterRedirect guard({
  bool requireAuth = true,
  List<String> perms = const [],
  PermMode mode = PermMode.any,
}) {
  return (context, state) {
    final session = sl<SessionInfo>();
    if (session.isResolving) return null;

    if (requireAuth && !session.isAuthenticated) {
      return Uri(
        path: AppRoutes.login,
        queryParameters: {AppRoutes.fromParam: state.uri.toString()},
      ).toString();
    }

    if (perms.isNotEmpty && session.isAuthenticated) {
      final ok = switch (mode) {
        PermMode.any => session.permissions.hasAny(perms),
        PermMode.all => session.permissions.hasAll(perms),
      };
      if (!ok) return AppRoutes.forbidden;
    }

    return null;
  };
}

/// For login/register: a signed-in user is bounced to [AppRoutes.home].
GoRouterRedirect guestOnly() {
  return (context, state) {
    final session = sl<SessionInfo>();
    if (session.isResolving) return null;
    return session.isAuthenticated ? AppRoutes.home : null;
  };
}
