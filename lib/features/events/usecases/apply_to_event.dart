import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/application.dart';
import '../repositories/events_repository.dart';

class ApplyToEventParams {
  const ApplyToEventParams({required this.eventId, required this.positionId});

  final int eventId;
  final int positionId;
}

/// Failure codes to branch on: `closed`, `already_applied`,
/// `position_not_matching_role`, `date_conflict` (§4.3).
class ApplyToEvent implements UseCase<Result<Application>, ApplyToEventParams> {
  const ApplyToEvent(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<Application>> call(ApplyToEventParams params) =>
      _repository.apply(eventId: params.eventId, positionId: params.positionId);
}
