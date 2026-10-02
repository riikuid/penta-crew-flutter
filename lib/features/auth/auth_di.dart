import 'package:get_it/get_it.dart';

import '../../core/session/session_info.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/login_cubit.dart';
import 'repositories/auth_repository.dart';
import 'usecases/get_me.dart';
import 'usecases/login.dart';
import 'usecases/logout.dart';

void registerAuth(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => AuthRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => Login(sl(), sl(), sl()));
  sl.registerFactory(() => GetMe(sl()));
  sl.registerFactory(() => Logout(sl(), sl(), sl()));

  // AuthCubit is the only app-wide cubit; also exposed to the router as SessionInfo.
  sl.registerLazySingleton(
    () => AuthCubit(getMe: sl(), logout: sl(), storage: sl(), events: sl()),
  );
  sl.registerLazySingleton<SessionInfo>(() => sl<AuthCubit>());

  // Page-scoped cubits are factories; the route's BlocProvider owns their lifecycle.
  sl.registerFactory(() => LoginCubit(sl(), sl()));
}
