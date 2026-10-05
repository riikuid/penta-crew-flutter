import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import 'presentation/cubit/history_cubit.dart';
import 'presentation/cubit/upcoming_cubit.dart';
import 'presentation/screens/schedule_screen.dart';

abstract final class ScheduleRoutes {
  static const root = '/schedule';
}

/// Tab root (D1/D2/D3) — mounted inside the shell. Both tab cubits are
/// created here so they stay alive while the user switches Upcoming ↔
/// History; the shell's indexed stack keeps them alive across tab changes.
final GoRoute scheduleTabRoute = GoRoute(
  path: ScheduleRoutes.root,
  builder: (context, state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<UpcomingCubit>()..fetch()),
      BlocProvider(create: (_) => sl<HistoryCubit>()..fetch()),
    ],
    child: const ScheduleScreen(),
  ),
);
