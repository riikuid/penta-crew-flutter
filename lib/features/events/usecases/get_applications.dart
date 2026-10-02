import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/application.dart';
import '../repositories/events_repository.dart';

class GetApplicationsParams {
  const GetApplicationsParams({
    this.statuses = const [],
    required this.page,
    this.perPage = 20,
  });

  /// Empty = every non-withdrawn status (Tracked tab, C2).
  final List<ApplicationStatus> statuses;
  final int page;
  final int perPage;

  /// Home's "waiting" counter: one item is enough, `meta.total` has the count.
  static const waitingCount = GetApplicationsParams(
    statuses: [ApplicationStatus.waiting],
    page: 1,
    perPage: 1,
  );
}

class GetApplications
    implements UseCase<Result<Paginated<Application>>, GetApplicationsParams> {
  const GetApplications(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<Paginated<Application>>> call(GetApplicationsParams params) =>
      _repository.getApplications(
        statuses: params.statuses,
        page: params.page,
        perPage: params.perPage,
      );
}
