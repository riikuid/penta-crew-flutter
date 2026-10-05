import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

abstract final class HomeRoutes {
  static const root = AppRoutes.home;
}

/// Tab root — mounted inside the shell by `core/router/app_shell.dart`.
/// The shell applies `guard()` once for all four tabs, so the user here is
/// always verified and therefore has a branch (contract §1); `0` only
/// happens on a partial payload and surfaces as that section's server error.
final GoRoute homeTabRoute = GoRoute(
  path: HomeRoutes.root,
  builder: (context, state) => BlocProvider(
    create: (context) => sl<HomeCubit>()
      ..load(branchId: context.read<AuthCubit>().user?.branch?.id ?? 0),
    child: const HomeScreen(),
  ),
);
