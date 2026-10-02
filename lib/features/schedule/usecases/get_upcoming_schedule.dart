import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../../events/models/application.dart';
import '../repositories/schedule_repository.dart';

class GetUpcomingScheduleParams {
  const GetUpcomingScheduleParams({required this.page, this.perPage = 20});

  final int page;
  final int perPage;

  /// Home's next shift: the first upcoming item only.
  static const next = GetUpcomingScheduleParams(page: 1, perPage: 1);
}

class GetUpcomingSchedule
    implements
        UseCase<Result<Paginated<Application>>, GetUpcomingScheduleParams> {
  const GetUpcomingSchedule(this._repository);

  final ScheduleRepository _repository;

  @override
  Future<Result<Paginated<Application>>> call(
    GetUpcomingScheduleParams params,
  ) => _repository.getUpcoming(page: params.page, perPage: params.perPage);
}
