import 'package:get_it/get_it.dart';

import 'repositories/events_repository.dart';
import 'usecases/apply_to_event.dart';
import 'usecases/get_applications.dart';
import 'usecases/get_event_detail.dart';
import 'usecases/get_open_events.dart';
import 'usecases/withdraw_application.dart';

void registerEvents(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => EventsRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => GetOpenEvents(sl()));
  sl.registerFactory(() => GetEventDetail(sl()));
  sl.registerFactory(() => ApplyToEvent(sl()));
  sl.registerFactory(() => WithdrawApplication(sl()));
  sl.registerFactory(() => GetApplications(sl()));

  // Page cubits are added by the Events feature ticket (TASK-016).
}
