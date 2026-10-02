import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/screens/change_password_screen.dart';
import 'presentation/screens/edit_profile_screen.dart';
import 'presentation/screens/profile_screen.dart';

abstract final class ProfileRoutes {
  static const root = '/profile';
  static const edit = '/profile/edit';
  static const password = '/profile/password';
}

/// Tab root (E1) — mounted inside the shell.
final GoRoute profileTabRoute = GoRoute(
  path: ProfileRoutes.root,
  builder: (context, state) => const ProfileScreen(),
);

/// Root-level pages (no pill nav). `/profile/edit` is reachable while
/// unverified: A7 "Edit profile" opens it (D-01, D-08).
final List<RouteBase> profileRoutes = [
  GoRoute(
    path: ProfileRoutes.edit,
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(requireVerified: false),
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    path: ProfileRoutes.password,
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(),
    builder: (context, state) => const ChangePasswordScreen(),
  ),
];
