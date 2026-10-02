import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkAllNotificationsRead implements UseCase<Result<void>, NoParams> {
  const MarkAllNotificationsRead(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.markAllRead();
}
