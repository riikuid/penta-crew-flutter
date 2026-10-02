import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/event.dart';
import '../repositories/events_repository.dart';

class GetOpenEventsParams {
  const GetOpenEventsParams({
    required this.branchId,
    required this.page,
    this.perPage = 20,
    this.search,
  });

  /// The user's branch (D-10) — read from `AuthCubit`'s user.
  final int branchId;
  final int page;
  final int perPage;

  /// `null` or blank means "no filter".
  final String? search;
}

class GetOpenEvents
    implements UseCase<Result<Paginated<Event>>, GetOpenEventsParams> {
  const GetOpenEvents(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<Paginated<Event>>> call(GetOpenEventsParams params) {
    final search = params.search?.trim();
    return _repository.getOpenEvents(
      branchId: params.branchId,
      page: params.page,
      perPage: params.perPage,
      search: (search == null || search.isEmpty) ? null : search,
    );
  }
}
