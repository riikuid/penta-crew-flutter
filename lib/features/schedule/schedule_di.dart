import 'package:get_it/get_it.dart';

import 'presentation/cubit/history_cubit.dart';
import 'presentation/cubit/upcoming_cubit.dart';
import 'repositories/schedule_repository.dart';
import 'usecases/get_schedule_history.dart';
import 'usecases/get_upcoming_schedule.dart';

void registerSchedule(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => ScheduleRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => GetUpcomingSchedule(sl()));
  sl.registerFactory(() => GetScheduleHistory(sl()));

  // Tab cubits: one of each per Schedule tab mount (see schedule_routes.dart).
  sl.registerFactory(() => UpcomingCubit(sl()));
  sl.registerFactory(() => HistoryCubit(sl()));
}
