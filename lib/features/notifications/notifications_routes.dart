import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/cubit/notifications_cubit.dart';
import 'presentation/screens/notifications_screen.dart';

abstract final class NotificationsRoutes {
  static const root = '/notifications';
}

/// Root-level page (no pill nav), opened from the Home bell.
final List<RouteBase> notificationsRoutes = [
  GoRoute(
    path: NotificationsRoutes.root,
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(),
    builder: (context, state) => BlocProvider(
      create: (_) => sl<NotificationsCubit>()..load(),
      child: const NotificationsScreen(),
    ),
  ),
];
