import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/screens/home_screen.dart';

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: AppRoutes.home,
    redirect: guard(),
    builder: (context, state) => const HomeScreen(),
  ),
];
