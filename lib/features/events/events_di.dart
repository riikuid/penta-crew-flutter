import 'package:get_it/get_it.dart';

import 'presentation/cubit/open_events_cubit.dart';
import 'presentation/cubit/tracked_cubit.dart';
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

  // Page cubits are factories; the route's BlocProvider owns their lifecycle.
  // `OpenEventsCubit` takes the user's branch id (D-10) as `param1`.
  sl.registerFactoryParam<OpenEventsCubit, int, void>(
    (branchId, _) => OpenEventsCubit(sl(), branchId: branchId),
  );
  sl.registerFactory(() => TrackedCubit(sl()));
}
