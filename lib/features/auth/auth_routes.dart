import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/cubit/login_cubit.dart';
import 'presentation/screens/forbidden_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/splash_screen.dart';

/// Paths owned by this feature beyond the core ones in `AppRoutes`. The
/// screens behind `register` / `forgotPassword` / `checkEmail` /
/// `resetPassword` arrive with the Auth feature ticket (TASK-014); the
/// constants exist now so other features can link to them.
abstract final class AuthRoutes {
  static const login = AppRoutes.login;
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const checkEmail = '/check-email';
  static const resetPassword = '/reset-password';
}

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
