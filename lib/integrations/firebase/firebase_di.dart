import 'package:get_it/get_it.dart';

import '../../core/push/push_service.dart';
import 'firebase_push_service.dart';

/// Requires `registerLocalNotifications(sl)` to have run first.
void registerFirebase(GetIt sl) {
  sl.registerLazySingleton<PushService>(
    () => FirebasePushService(local: sl(), talker: sl()),
  );
}
