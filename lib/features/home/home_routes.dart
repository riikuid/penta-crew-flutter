import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import 'presentation/screens/home_screen.dart';

abstract final class HomeRoutes {
  static const root = AppRoutes.home;
}

/// Tab root — mounted inside the shell by `core/router/app_shell.dart`.
/// The shell applies `guard()` once for all four tabs.
final GoRoute homeTabRoute = GoRoute(
  path: HomeRoutes.root,
  builder: (context, state) => const HomeScreen(),
);
