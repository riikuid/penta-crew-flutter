import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsParams {
  const GetNotificationsParams({required this.page, this.perPage = 20});

  final int page;
  final int perPage;
}

/// `page.meta['unread_count']` carries the badge count.
class GetNotifications
    implements
        UseCase<Result<Paginated<AppNotification>>, GetNotificationsParams> {
  const GetNotifications(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<Paginated<AppNotification>>> call(
    GetNotificationsParams params,
  ) => _repository.getNotifications(page: params.page, perPage: params.perPage);
}
