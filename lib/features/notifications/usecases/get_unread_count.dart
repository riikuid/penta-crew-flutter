import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class GetUnreadCount implements UseCase<Result<int>, NoParams> {
  const GetUnreadCount(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<int>> call(NoParams params) => _repository.getUnreadCount();
}
