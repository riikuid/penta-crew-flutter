import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/application.dart';

part 'tracked_state.freezed.dart';

/// C2 Tracked tab — every active application (`waiting | selected |
/// not_selected`, D-04). [total] is `meta.total`: the "4 applications"
/// eyebrow and the `Tracked 04` tab count.
@freezed
sealed class TrackedState with _$TrackedState {
  const factory TrackedState.initial() = TrackedInitial;
  const factory TrackedState.loading() = TrackedLoading;
  const factory TrackedState.loaded({
    required List<Application> data,
    required int total,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
  }) = TrackedLoaded;
  const factory TrackedState.error({
    required String message,
    @Default([]) List<Application> data,
  }) = TrackedError;
}
