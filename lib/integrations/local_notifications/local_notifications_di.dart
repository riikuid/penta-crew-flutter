import 'package:get_it/get_it.dart';

import 'local_notification_service.dart';

void registerLocalNotifications(GetIt sl) {
  sl.registerLazySingleton(() => LocalNotificationService(talker: sl()));
}
