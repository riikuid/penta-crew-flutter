import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/cubit/check_email_cubit.dart';
import 'presentation/cubit/forgot_password_cubit.dart';
import 'presentation/cubit/login_cubit.dart';
import 'presentation/cubit/register_cubit.dart';
import 'presentation/cubit/reset_password_cubit.dart';
import 'presentation/screens/check_email_screen.dart';
import 'presentation/screens/forbidden_screen.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/reset_password_screen.dart';
import 'presentation/screens/splash_screen.dart';

/// Paths owned by this feature beyond the core ones in `AppRoutes`.
abstract final class AuthRoutes {
  static const login = AppRoutes.login;
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const checkEmail = '/check-email';

  /// Deep-link target (D-02): `?token=…&email=…`. The Laravel-default shape
  /// `/reset-password/<token>?email=…` is accepted too (see [authRoutes]).
  static const resetPassword = '/reset-password';

  /// Query keys of the reset-password link.
  static const tokenParam = 'token';
  static const emailParam = 'email';
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
    path: AuthRoutes.register,
    redirect: guestOnly(),
    builder: (context, state) => BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const RegisterScreen(),
    ),
  ),
  // Forgot / Check email / Reset have no guard at all: a signed-in user may
  // open them from the email link as well (D-02, implementation plan §2.4).
  GoRoute(
    path: AuthRoutes.forgotPassword,
    builder: (context, state) => BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      // Sign in hands over whatever the user typed via `extra`.
      child: ForgotPasswordScreen(initialEmail: state.extra as String?),
    ),
  ),
  GoRoute(
    path: AuthRoutes.checkEmail,
    // The email arrives via `extra` from Forgot password; without it there is
    // nothing to show, so start the flow over.
    redirect: (context, state) =>
        state.extra is String ? null : AuthRoutes.forgotPassword,
    builder: (context, state) {
      final email = state.extra! as String;
      return BlocProvider(
        create: (_) => sl<CheckEmailCubit>(param1: email),
        child: CheckEmailScreen(email: email),
      );
    },
  ),
  GoRoute(path: AuthRoutes.resetPassword, builder: _buildResetPassword),
  GoRoute(
    path: '${AuthRoutes.resetPassword}/:${AuthRoutes.tokenParam}',
    builder: _buildResetPassword,
  ),
  GoRoute(
    path: AppRoutes.forbidden,
    builder: (context, state) => const ForbiddenScreen(),
  ),
];

/// Token from the path (`/reset-password/:token`) or the query
/// (`?token=`); email always from the query. Missing values become empty
/// strings and the cubit shows the expired state.
Widget _buildResetPassword(BuildContext context, GoRouterState state) {
  final query = state.uri.queryParameters;
  final token =
      state.pathParameters[AuthRoutes.tokenParam] ??
      query[AuthRoutes.tokenParam] ??
      '';
  final email = query[AuthRoutes.emailParam] ?? '';
  return BlocProvider(
    create: (_) => sl<ResetPasswordCubit>(param1: token, param2: email),
    child: ResetPasswordScreen(token: token, email: email),
  );
}
