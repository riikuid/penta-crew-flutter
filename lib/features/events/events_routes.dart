import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/event_detail_cubit.dart';
import 'presentation/cubit/open_events_cubit.dart';
import 'presentation/cubit/tracked_cubit.dart';
import 'presentation/screens/event_detail_screen.dart';
import 'presentation/screens/events_screen.dart';

/// Paths owned by this feature. Navigate with
/// `context.push(EventsRoutes.detail(id))`; other features land on a specific
/// tab with `context.go(EventsRoutes.open)` / `EventsRoutes.tracked`.
abstract final class EventsRoutes {
  static const root = '/events';

  /// Query parameter selecting the tab (`open` | `tracked`).
  static const tabParam = 'tab';
  static const open = '$root?$tabParam=open';
  static const tracked = '$root?$tabParam=tracked';

  static String detail(int id) => '$root/$id';
}

/// Tab root (C1/C2) — mounted inside the shell. Both tab cubits live for as
/// long as the tab does, so switching Open ↔ Tracked keeps each list.
final GoRoute eventsTabRoute = GoRoute(
  path: EventsRoutes.root,
  builder: (context, state) {
    // D-10: `GET /events` is always scoped to the signed-in user's branch.
    final branchId = context.read<AuthCubit>().user?.branch?.id ?? 0;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<OpenEventsCubit>(param1: branchId)..fetch(),
        ),
        BlocProvider(create: (_) => sl<TrackedCubit>()..fetch()),
      ],
      child: EventsScreen(
        initialTab: EventsTab.fromName(
          state.uri.queryParameters[EventsRoutes.tabParam],
        ),
      ),
    );
  },
);

/// Root-level pages (no pill nav): event detail C3–C9.
final List<RouteBase> eventsRoutes = [
  GoRoute(
    path: '${EventsRoutes.root}/:id',
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(),
    builder: (context, state) {
      final eventId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
      return BlocProvider(
        create: (_) => sl<EventDetailCubit>()..fetch(eventId),
        child: const EventDetailScreen(),
      );
    },
  ),
];
