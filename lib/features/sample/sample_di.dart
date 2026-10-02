import 'package:get_it/get_it.dart';

import 'presentation/cubit/sample_detail_cubit.dart';
import 'presentation/cubit/sample_list_cubit.dart';
import 'repositories/sample_repository.dart';
import 'usecases/get_sample_detail.dart';
import 'usecases/get_sample_list.dart';

/// Template feature — copy this folder to start a new feature; see README
/// "Adding a feature". Then: rename, call `registerX(sl)` in
/// `core/di/locator.dart`, and spread `...xRoutes` in `core/router/app_router.dart`.
void registerSample(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => SampleRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => GetSampleList(sl()));
  sl.registerFactory(() => GetSampleDetail(sl()));

  // Page-scoped cubits are factories; the route's BlocProvider owns their lifecycle.
  sl.registerFactory(() => SampleListCubit(sl()));
  sl.registerFactory(() => SampleDetailCubit(sl()));
}
