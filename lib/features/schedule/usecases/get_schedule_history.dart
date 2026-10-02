import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../../events/models/application.dart';
import '../repositories/schedule_repository.dart';

class GetScheduleHistoryParams {
  const GetScheduleHistoryParams({required this.page, this.perPage = 20});

  final int page;
  final int perPage;

  /// Home's Worked tile only needs `meta.summary`.
  static const summaryOnly = GetScheduleHistoryParams(page: 1, perPage: 1);
}

/// Read the counter with `HistorySummary.fromMeta(page.meta)`.
class GetScheduleHistory
    implements
        UseCase<Result<Paginated<Application>>, GetScheduleHistoryParams> {
  const GetScheduleHistory(this._repository);

  final ScheduleRepository _repository;

  @override
  Future<Result<Paginated<Application>>> call(
    GetScheduleHistoryParams params,
  ) => _repository.getHistory(page: params.page, perPage: params.perPage);
}
