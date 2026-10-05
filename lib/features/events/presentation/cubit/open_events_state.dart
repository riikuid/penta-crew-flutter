import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/event.dart';

part 'open_events_state.freezed.dart';

/// C1 Open tab. Same shape as `SampleListState`: `error` may carry the data
/// that was on screen when a refresh / load-more failed, in which case the
/// UI keeps the list and only shows a toast.
///
/// [total] is the paginator's `meta.total` — the "3 open" header (D-10) and
/// the `Open 03` tab count.
@freezed
sealed class OpenEventsState with _$OpenEventsState {
  const factory OpenEventsState.initial() = OpenEventsInitial;
  const factory OpenEventsState.loading() = OpenEventsLoading;
  const factory OpenEventsState.loaded({
    required List<Event> data,
    required int total,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
    String? search,
  }) = OpenEventsLoaded;
  const factory OpenEventsState.error({
    required String message,
    @Default([]) List<Event> data,
  }) = OpenEventsError;
}
