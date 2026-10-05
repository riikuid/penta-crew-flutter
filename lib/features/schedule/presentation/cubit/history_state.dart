import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../events/models/application.dart';
import '../../models/history_summary.dart';

part 'history_state.freezed.dart';

/// History tab (D2). [HistoryLoaded.summary] is `meta.summary` of the first
/// page (contract §5.2) and drives the "06 events worked since Jul 2026"
/// counter. `error` may carry the rows that were on screen when a refresh /
/// load-more failed (toast, list stays); with no rows it is a full-screen
/// error with retry.
@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = HistoryInitial;
  const factory HistoryState.loading() = HistoryLoading;
  const factory HistoryState.loaded({
    required List<Application> items,
    required HistorySummary summary,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
  }) = HistoryLoaded;
  const factory HistoryState.error({
    required String message,
    @Default([]) List<Application> items,
  }) = HistoryError;
}
