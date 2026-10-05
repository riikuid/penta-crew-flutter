import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../events/models/application.dart';
import '../../models/month_group.dart';

part 'upcoming_state.freezed.dart';

/// Upcoming tab (D1/D3). Items live inside [MonthGroup]s, already grouped by
/// the cubit; `error` may carry the groups that were on screen when a
/// refresh / load-more failed (toast, list stays). With no groups it is a
/// full-screen error with retry.
@freezed
sealed class UpcomingState with _$UpcomingState {
  const UpcomingState._();

  const factory UpcomingState.initial() = UpcomingInitial;
  const factory UpcomingState.loading() = UpcomingLoading;
  const factory UpcomingState.loaded({
    required List<MonthGroup> groups,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
  }) = UpcomingLoaded;
  const factory UpcomingState.error({
    required String message,
    @Default([]) List<MonthGroup> groups,
  }) = UpcomingError;

  /// The first item overall — the "Next" card on D1 (contract §5.1: the
  /// server sorts by date/time ASC). `null` unless loaded with data.
  Application? get next => switch (this) {
    UpcomingLoaded(:final groups) => groups.firstOrNull?.items.firstOrNull,
    _ => null,
  };
}
