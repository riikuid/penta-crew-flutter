import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationRead implements UseCase<Result<void>, int> {
  const MarkNotificationRead(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<void>> call(int notificationId) =>
      _repository.markRead(notificationId);
}
