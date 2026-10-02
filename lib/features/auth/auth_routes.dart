import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/cubit/login_cubit.dart';
import 'presentation/screens/forbidden_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/splash_screen.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) =>
        SplashScreen(from: state.uri.queryParameters[AppRoutes.fromParam]),
  ),
  GoRoute(
    path: AppRoutes.login,
    redirect: guestOnly(),
    builder: (context, state) => BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: LoginScreen(from: state.uri.queryParameters[AppRoutes.fromParam]),
    ),
  ),
  GoRoute(
    path: AppRoutes.forbidden,
    builder: (context, state) => const ForbiddenScreen(),
  ),
];
