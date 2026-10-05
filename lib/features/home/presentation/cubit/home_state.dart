import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../events/models/application.dart';
import '../../../events/models/event.dart';
import '../../../schedule/models/history_summary.dart';
import 'section.dart';

part 'home_state.freezed.dart';

/// The four blocks of B1, each with its own lifecycle (D-05). Greeting and
/// roles come from `AuthCubit` and are not part of this state.
///
/// [refreshError] is a one-shot signal: when a pull-to-refresh fails for a
/// section that already had data, the data stays and this carries the server
/// message for a toast. The cubit emits it and clears it right away, so a
/// listener should react when it is non-null.
@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    /// First item of `GET /schedule/upcoming`; `null` when nothing is
    /// scheduled (B3).
    @Default(Section<Application?>.loading()) Section<Application?> nextShift,

    /// `meta.total` of `GET /applications?status=waiting` (D-04).
    @Default(Section<int>.loading()) Section<int> waitingCount,

    /// `meta.summary` of `GET /schedule/history`.
    @Default(Section<HistorySummary>.loading()) Section<HistorySummary> worked,

    /// First page of open events in the user's branch (carousel).
    @Default(Section<List<Event>>.loading()) Section<List<Event>> openEvents,
    String? refreshError,
  }) = _HomeState;

  /// B2: nothing has answered yet, so even the request-free blocks (bell,
  /// greeting) draw as skeletons to keep the prototype's loading frame.
  bool get isInitialLoading =>
      nextShift is SectionLoading &&
      waitingCount is SectionLoading &&
      worked is SectionLoading &&
      openEvents is SectionLoading;
}
