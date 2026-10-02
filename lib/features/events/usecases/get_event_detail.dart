import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/event_detail.dart';
import '../repositories/events_repository.dart';

class GetEventDetail implements UseCase<Result<EventDetail>, int> {
  const GetEventDetail(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<EventDetail>> call(int eventId) =>
      _repository.getEventDetail(eventId);
}
