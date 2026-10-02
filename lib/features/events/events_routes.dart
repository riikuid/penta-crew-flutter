import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/screens/event_detail_screen.dart';
import 'presentation/screens/events_screen.dart';

/// Paths owned by this feature. Navigate with
/// `context.push(EventsRoutes.detail(id))`.
abstract final class EventsRoutes {
  static const root = '/events';
  static String detail(int id) => '/events/$id';
}

/// Tab root (C1/C2) — mounted inside the shell.
final GoRoute eventsTabRoute = GoRoute(
  path: EventsRoutes.root,
  builder: (context, state) => const EventsScreen(),
);

/// Root-level pages (no pill nav): event detail C3–C9.
final List<RouteBase> eventsRoutes = [
  GoRoute(
    path: '${EventsRoutes.root}/:id',
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(),
    builder: (context, state) => EventDetailScreen(
      eventId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
    ),
  ),
];
