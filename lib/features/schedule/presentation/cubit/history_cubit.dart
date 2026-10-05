import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../models/history_summary.dart';
import '../../usecases/get_schedule_history.dart';
import 'history_state.dart';

/// Tab-scoped: provided by the Schedule tab route and kept alive while the
/// user switches between Upcoming and History. Follows `SampleListCubit`:
///
/// - [fetch] / [retry]: full reload with skeletons.
/// - [refresh]: silent reload of page 1, list stays visible.
/// - [loadMore]: next page appended; the summary from page 1 is kept.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getHistory) : super(const HistoryState.initial());

  final GetScheduleHistory _getHistory;

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a fetch/refresh started after it) is discarded.
  int _sequence = 0;

  Future<void> fetch() => _loadFirstPage(showLoading: true);

  Future<void> retry() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! HistoryLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! HistoryLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final sequence = _sequence;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getHistory(
      GetScheduleHistoryParams(page: current.page + 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          current.copyWith(
            items: [...current.items, ...value.data],
            page: value.currentPage,
            hasReachedMax: !value.hasMore || value.isEmpty,
            isLoadingMore: false,
          ),
        );
      case Failed(:final message):
        // Transient: surface the message, keep the list usable.
        emit(HistoryState.error(message: message, items: current.items));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final sequence = ++_sequence;
    final previous = state;
    if (showLoading) emit(const HistoryState.loading());

    final result = await _getHistory(const GetScheduleHistoryParams(page: 1));
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          HistoryState.loaded(
            items: value.data,
            summary: HistorySummary.fromMeta(value.meta),
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
          ),
        );
      case Failed(:final message):
        if (previous is HistoryLoaded && !showLoading) {
          // Silent refresh failed: toast, then restore what was on screen.
          emit(HistoryState.error(message: message, items: previous.items));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(HistoryState.error(message: message));
        }
    }
  }
}
