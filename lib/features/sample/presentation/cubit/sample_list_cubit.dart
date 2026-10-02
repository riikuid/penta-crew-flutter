import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/get_sample_list.dart';
import 'sample_list_state.dart';

/// Page-scoped: provided by the list route, closed when the page is popped.
///
/// - [fetch]: full reload with spinner (first load, search, retry).
/// - [refresh]: silent reload of page 1, list stays visible (pull-to-refresh).
/// - [loadMore]: next page appended; no-op while loading or at the last page.
class SampleListCubit extends Cubit<SampleListState> {
  SampleListCubit(this._getList) : super(const SampleListState.initial());

  final GetSampleList _getList;

  /// Current filter, kept here so [retry] works from any state.
  String? _search;

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a fetch/refresh started after it) is discarded.
  int _seq = 0;

  Future<void> fetch({String? search}) {
    _search = search;
    return _loadFirstPage(showLoading: true);
  }

  Future<void> retry() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! SampleListLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! SampleListLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final seq = _seq;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getList(
      GetSampleListParams(page: current.page + 1, search: _search),
    );
    if (isClosed || seq != _seq) return;

    switch (result) {
      case Success(:final value):
        emit(
          current.copyWith(
            data: [...current.data, ...value.data],
            page: value.currentPage,
            hasReachedMax: !value.hasMore || value.isEmpty,
            isLoadingMore: false,
          ),
        );
      case Failed(:final message):
        // Transient: surface the message, keep the list usable.
        emit(SampleListState.error(message: message, data: current.data));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final seq = ++_seq;
    final previous = state;
    if (showLoading) emit(const SampleListState.loading());

    final result = await _getList(GetSampleListParams(page: 1, search: _search));
    if (isClosed || seq != _seq) return;

    switch (result) {
      case Success(:final value):
        emit(
          SampleListState.loaded(
            data: value.data,
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
            search: _search,
          ),
        );
      case Failed(:final message):
        if (previous is SampleListLoaded && !showLoading) {
          // Silent refresh failed: toast, then restore what was on screen.
          emit(SampleListState.error(message: message, data: previous.data));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(SampleListState.error(message: message));
        }
    }
  }
}
