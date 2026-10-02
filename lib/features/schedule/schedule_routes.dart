import 'package:go_router/go_router.dart';

import 'presentation/screens/schedule_screen.dart';

abstract final class ScheduleRoutes {
  static const root = '/schedule';
}

/// Tab root (D1/D2/D3) — mounted inside the shell.
final GoRoute scheduleTabRoute = GoRoute(
  path: ScheduleRoutes.root,
  builder: (context, state) => const ScheduleScreen(),
);
