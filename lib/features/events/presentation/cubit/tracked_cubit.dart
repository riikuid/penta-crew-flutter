import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../models/application.dart';
import '../../usecases/get_applications.dart';
import 'tracked_state.dart';

/// C2 Tracked tab — `GET /applications?status=waiting,selected,not_selected`
/// (D-04: withdrawn never shows). Ordering is the backend's (waiting first by
/// `closes_at`, then decided by `decided_at DESC`, §4.5).
///
/// Same lifecycle as `OpenEventsCubit`: [fetch] with skeletons, silent
/// [refresh], [loadMore] appending the next page.
class TrackedCubit extends Cubit<TrackedState> {
  TrackedCubit(this._getApplications) : super(const TrackedState.initial());

  final GetApplications _getApplications;

  static const trackedStatuses = [
    ApplicationStatus.waiting,
    ApplicationStatus.selected,
    ApplicationStatus.notSelected,
  ];

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a fetch/refresh started after it) is discarded.
  int _sequence = 0;

  Future<void> fetch() => _loadFirstPage(showLoading: true);

  Future<void> retry() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! TrackedLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! TrackedLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final sequence = _sequence;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getApplications(
      GetApplicationsParams(statuses: trackedStatuses, page: current.page + 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          current.copyWith(
            data: [...current.data, ...value.data],
            total: value.total,
            page: value.currentPage,
            hasReachedMax: !value.hasMore || value.isEmpty,
            isLoadingMore: false,
          ),
        );
      case Failed(:final message):
        emit(TrackedState.error(message: message, data: current.data));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final sequence = ++_sequence;
    final previous = state;
    if (showLoading) emit(const TrackedState.loading());

    final result = await _getApplications(
      const GetApplicationsParams(statuses: trackedStatuses, page: 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          TrackedState.loaded(
            data: value.data,
            total: value.total,
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
          ),
        );
      case Failed(:final message):
        if (previous is TrackedLoaded && !showLoading) {
          emit(TrackedState.error(message: message, data: previous.data));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(TrackedState.error(message: message));
        }
    }
  }
}
