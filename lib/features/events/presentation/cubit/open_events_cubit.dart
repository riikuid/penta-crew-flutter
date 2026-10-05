import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/get_open_events.dart';
import 'open_events_state.dart';

/// C1 Open tab — open events of the user's branch, sorted by deadline as the
/// backend returns them. Follows `SampleListCubit`:
///
/// - [fetch]: full reload with skeletons (first load, search, retry).
/// - [refresh]: silent reload of page 1, list stays visible.
/// - [loadMore]: next page appended; no-op while loading or at the last page.
///
/// [branchId] is fixed per instance (D-10: `GET /events` is always scoped to
/// the signed-in user's branch), so the route builder passes it from
/// `AuthCubit` once.
class OpenEventsCubit extends Cubit<OpenEventsState> {
  OpenEventsCubit(this._getOpenEvents, {required this.branchId})
    : super(const OpenEventsState.initial());

  final GetOpenEvents _getOpenEvents;
  final int branchId;

  /// Current search filter, kept so [retry] / [refresh] reuse it.
  String? _search;

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a fetch/refresh started after it) is discarded.
  int _sequence = 0;

  Future<void> fetch({String? search}) {
    _search = search;
    return _loadFirstPage(showLoading: true);
  }

  Future<void> retry() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! OpenEventsLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! OpenEventsLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final sequence = _sequence;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getOpenEvents(
      GetOpenEventsParams(
        branchId: branchId,
        page: current.page + 1,
        search: _search,
      ),
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
        // Transient: surface the message, keep the list usable.
        emit(OpenEventsState.error(message: message, data: current.data));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final sequence = ++_sequence;
    final previous = state;
    if (showLoading) emit(const OpenEventsState.loading());

    final result = await _getOpenEvents(
      GetOpenEventsParams(branchId: branchId, page: 1, search: _search),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          OpenEventsState.loaded(
            data: value.data,
            total: value.total,
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
            search: _search,
          ),
        );
      case Failed(:final message):
        if (previous is OpenEventsLoaded && !showLoading) {
          // Silent refresh failed: toast, then restore what was on screen.
          emit(OpenEventsState.error(message: message, data: previous.data));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(OpenEventsState.error(message: message));
        }
    }
  }
}
