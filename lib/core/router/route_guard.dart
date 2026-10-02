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
/// Order of checks: signed in → verified (D-01) → permissions. Routes that an
/// unverified user may open (`/verification/data`, `/profile/edit`) pass
/// `requireVerified: false`.
///
/// Startup resolution is handled once by the top-level redirect in
/// `app_router.dart`, so by the time this runs the session is known.
GoRouterRedirect guard({
  bool requireAuth = true,
  bool requireVerified = true,
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

    if (requireVerified && session.isAuthenticated && !session.isVerified) {
      return AppRoutes.verification;
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

/// For login/register: a signed-in user is bounced to [AppRoutes.home]
/// (and from there to `/verification` if they are not approved yet).
GoRouterRedirect guestOnly() {
  return (context, state) {
    final session = sl<SessionInfo>();
    if (session.isResolving) return null;
    return session.isAuthenticated ? AppRoutes.home : null;
  };
}

/// For `/verification`: requires a session, and an already-verified user is
/// sent to [AppRoutes.home] instead of seeing the pending screen.
GoRouterRedirect unverifiedOnly() {
  return (context, state) {
    final session = sl<SessionInfo>();
    if (session.isResolving) return null;
    if (!session.isAuthenticated) {
      return Uri(
        path: AppRoutes.login,
        queryParameters: {AppRoutes.fromParam: state.uri.toString()},
      ).toString();
    }
    return session.isVerified ? AppRoutes.home : null;
  };
}
