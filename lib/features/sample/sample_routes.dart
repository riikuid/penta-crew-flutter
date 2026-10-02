import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/router/route_guard.dart';
import '../../core/widgets/state_views.dart';
import 'presentation/cubit/sample_detail_cubit.dart';
import 'presentation/cubit/sample_list_cubit.dart';
import 'presentation/screens/sample_detail_screen.dart';
import 'presentation/screens/sample_list_screen.dart';

/// Paths owned by this feature. Navigate with `context.push(SampleRoutes.detail(id))`.
abstract final class SampleRoutes {
  static const list = '/samples';
  static String detail(int id) => '/samples/$id';
}

final List<RouteBase> sampleRoutes = [
  GoRoute(
    path: SampleRoutes.list,
    redirect: guard(),
    builder: (context, state) => BlocProvider(
      create: (_) => sl<SampleListCubit>()..fetch(),
      child: const SampleListScreen(),
    ),
  ),
  GoRoute(
    path: '${SampleRoutes.list}/:id',
    redirect: guard(),
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id'] ?? '');
      if (id == null) {
        return ErrorView(
          message: 'Invalid id: ${state.pathParameters['id']}',
          onRetry: context.pop,
          retryLabel: 'Back',
        );
      }
      return BlocProvider(
        create: (_) => sl<SampleDetailCubit>()..fetch(id),
        child: const SampleDetailScreen(),
      );
    },
  ),
];
