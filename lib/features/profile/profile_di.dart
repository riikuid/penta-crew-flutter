import 'package:get_it/get_it.dart';

import 'avatar_picker.dart';
import 'presentation/cubit/change_password_cubit.dart';
import 'presentation/cubit/edit_profile_cubit.dart';

/// Profile reuses `AuthRepository` and the auth usecases (UpdateProfile,
/// ChangePassword, UploadAvatar, ResubmitVerification, GetBranches); only
/// the photo picker and the page cubits are registered here.
void registerProfile(GetIt sl) {
  sl.registerLazySingleton<AvatarPicker>(ImagePickerAvatarPicker.new);

  // Page-scoped cubits are factories; the route's BlocProvider owns them.
  sl.registerFactory(
    () => EditProfileCubit(
      getBranches: sl(),
      updateProfile: sl(),
      uploadAvatar: sl(),
      resubmitVerification: sl(),
      avatarPicker: sl(),
      auth: sl(),
    ),
  );
  sl.registerFactory(() => ChangePasswordCubit(sl()));
}
