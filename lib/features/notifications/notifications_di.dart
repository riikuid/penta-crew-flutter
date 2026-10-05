import 'package:get_it/get_it.dart';

import 'presentation/cubit/notifications_cubit.dart';
import 'repositories/notifications_repository.dart';
import 'usecases/get_notifications.dart';
import 'usecases/get_unread_count.dart';
import 'usecases/mark_all_notifications_read.dart';
import 'usecases/mark_notification_read.dart';

void registerNotifications(GetIt sl) {
  // Repository: stateless → one instance.
  sl.registerLazySingleton(() => NotificationsRepository(sl()));

  // Usecases: cheap, new instance per use.
  sl.registerFactory(() => GetNotifications(sl()));
  sl.registerFactory(() => GetUnreadCount(sl()));
  sl.registerFactory(() => MarkNotificationRead(sl()));
  sl.registerFactory(() => MarkAllNotificationsRead(sl()));

  // Page cubits are factories; the route's BlocProvider owns their lifecycle.
  sl.registerFactory(
    () => NotificationsCubit(
      getNotifications: sl(),
      markNotificationRead: sl(),
      markAllNotificationsRead: sl(),
    ),
  );
}
