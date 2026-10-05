import 'package:get_it/get_it.dart';

/// Verification has no page cubit: A6/A7 read `AuthCubit.user` directly and
/// refresh through `AuthCubit.checkSession()`; "Submit again" runs inside
/// `EditProfileCubit` (profile feature). Nothing to register.
void registerVerification(GetIt sl) {}
