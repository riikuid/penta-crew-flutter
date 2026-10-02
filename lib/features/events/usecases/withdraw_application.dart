import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/events_repository.dart';

class WithdrawApplicationParams {
  const WithdrawApplicationParams({required this.applicationId});

  final int applicationId;
}

/// Failure codes to branch on: `deadline_passed`, `not_withdrawable` (§4.4).
class WithdrawApplication
    implements UseCase<Result<void>, WithdrawApplicationParams> {
  const WithdrawApplication(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<void>> call(WithdrawApplicationParams params) =>
      _repository.withdraw(params.applicationId);
}
