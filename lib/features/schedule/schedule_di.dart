import 'package:get_it/get_it.dart';

import 'repositories/schedule_repository.dart';
import 'usecases/get_schedule_history.dart';
import 'usecases/get_upcoming_schedule.dart';

void registerSchedule(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => ScheduleRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => GetUpcomingSchedule(sl()));
  sl.registerFactory(() => GetScheduleHistory(sl()));

  // Page cubits are added by the Schedule feature ticket (TASK-017).
}
