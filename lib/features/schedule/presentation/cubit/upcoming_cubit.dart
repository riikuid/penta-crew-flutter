import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../events/models/application.dart';
import '../../models/month_group.dart';
import '../../usecases/get_upcoming_schedule.dart';
import 'upcoming_state.dart';

/// Tab-scoped: provided by the Schedule tab route and kept alive while the
/// user switches between Upcoming and History. Follows `SampleListCubit`:
///
/// - [fetch] / [retry]: full reload with skeletons.
/// - [refresh]: silent reload of page 1, list stays visible.
/// - [loadMore]: next page appended and regrouped; no-op while loading or at
///   the last page.
class UpcomingCubit extends Cubit<UpcomingState> {
  UpcomingCubit(this._getUpcoming) : super(const UpcomingState.initial());

  final GetUpcomingSchedule _getUpcoming;

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a fetch/refresh started after it) is discarded.
  int _sequence = 0;

  Future<void> fetch() => _loadFirstPage(showLoading: true);

  Future<void> retry() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! UpcomingLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! UpcomingLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final sequence = _sequence;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getUpcoming(
      GetUpcomingScheduleParams(page: current.page + 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        final existing = current.groups.expand((group) => group.items);
        emit(
          current.copyWith(
            groups: _group([...existing, ...value.data]),
            page: value.currentPage,
            hasReachedMax: !value.hasMore || value.isEmpty,
            isLoadingMore: false,
          ),
        );
      case Failed(:final message):
        // Transient: surface the message, keep the list usable.
        emit(UpcomingState.error(message: message, groups: current.groups));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final sequence = ++_sequence;
    final previous = state;
    if (showLoading) emit(const UpcomingState.loading());

    final result = await _getUpcoming(
      const GetUpcomingScheduleParams(page: 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          UpcomingState.loaded(
            groups: _group(value.data),
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
          ),
        );
      case Failed(:final message):
        if (previous is UpcomingLoaded && !showLoading) {
          // Silent refresh failed: toast, then restore what was on screen.
          emit(UpcomingState.error(message: message, groups: previous.groups));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(UpcomingState.error(message: message));
        }
    }
  }

  static List<MonthGroup> _group(Iterable<Application> applications) =>
      MonthGroup.fromApplications(applications);
}
