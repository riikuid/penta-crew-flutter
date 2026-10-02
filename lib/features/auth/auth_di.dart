import 'package:get_it/get_it.dart';

import '../../core/session/session_info.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/login_cubit.dart';
import 'repositories/auth_repository.dart';
import 'usecases/change_password.dart';
import 'usecases/forgot_password.dart';
import 'usecases/get_branches.dart';
import 'usecases/get_me.dart';
import 'usecases/login.dart';
import 'usecases/logout.dart';
import 'usecases/register.dart';
import 'usecases/reset_password.dart';
import 'usecases/resubmit_verification.dart';
import 'usecases/update_device_token.dart';
import 'usecases/update_profile.dart';
import 'usecases/upload_avatar.dart';

void registerAuth(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => AuthRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => Login(sl(), sl(), sl()));
  sl.registerFactory(() => Register(sl(), sl(), sl()));
  sl.registerFactory(() => GetMe(sl()));
  sl.registerFactory(() => Logout(sl(), sl(), sl()));
  sl.registerFactory(() => ForgotPassword(sl()));
  sl.registerFactory(() => ResetPassword(sl()));
  sl.registerFactory(() => UpdateProfile(sl()));
  sl.registerFactory(() => ChangePassword(sl()));
  sl.registerFactory(() => UploadAvatar(sl()));
  sl.registerFactory(() => UpdateDeviceToken(sl()));
  sl.registerFactory(() => GetBranches(sl()));
  sl.registerFactory(() => ResubmitVerification(sl()));

  // AuthCubit is the only app-wide cubit; also exposed to the router as SessionInfo.
  sl.registerLazySingleton(
    () => AuthCubit(getMe: sl(), logout: sl(), storage: sl(), events: sl()),
  );
  sl.registerLazySingleton<SessionInfo>(() => sl<AuthCubit>());

  // Page-scoped cubits are factories; the route's BlocProvider owns their lifecycle.
  sl.registerFactory(() => LoginCubit(sl(), sl()));
}
