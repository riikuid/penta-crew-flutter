import 'package:get_it/get_it.dart';

import 'presentation/cubit/home_cubit.dart';

/// Home owns no endpoint (D-05): it only composes usecases registered by
/// `events` and `schedule`. Call from `core/di/locator.dart` after those.
void registerHome(GetIt sl) {
  // Page-scoped cubit: a factory; the route's BlocProvider owns its lifecycle.
  sl.registerFactory(
    () => HomeCubit(
      getUpcomingSchedule: sl(),
      getApplications: sl(),
      getScheduleHistory: sl(),
      getOpenEvents: sl(),
    ),
  );
}
