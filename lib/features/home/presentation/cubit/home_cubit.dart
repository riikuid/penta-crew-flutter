import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../events/models/application.dart';
import '../../../events/models/event.dart';
import '../../../events/usecases/get_applications.dart';
import '../../../events/usecases/get_open_events.dart';
import '../../../schedule/models/history_summary.dart';
import '../../../schedule/usecases/get_schedule_history.dart';
import '../../../schedule/usecases/get_upcoming_schedule.dart';
import 'home_state.dart';
import 'section.dart';

/// The blocks of B1 that load on their own (D-05 table).
enum HomeSection { nextShift, waitingCount, worked, openEvents }

/// Page-scoped: provided by the Home tab route. Fires the four requests at
/// once and emits per section as each one completes — no section waits for
/// another.
///
/// - [load]: first load, every section shows its skeleton.
/// - [refresh]: pull-to-refresh. A section that already had data keeps it
///   when its request fails; the first such failure surfaces once through
///   `HomeState.refreshError` for a toast.
/// - [retry]: re-fires one section from its inline error.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this._getUpcomingSchedule,
    required this._getApplications,
    required this._getScheduleHistory,
    required this._getOpenEvents,
  }) : super(const HomeState());

  final GetUpcomingSchedule _getUpcomingSchedule;
  final GetApplications _getApplications;
  final GetScheduleHistory _getScheduleHistory;
  final GetOpenEvents _getOpenEvents;

  /// The user's branch (D-10), fixed by [load]; open events are filtered by it.
  late int _branchId;

  Future<void> load({required int branchId}) {
    _branchId = branchId;
    emit(const HomeState());
    return _loadAll(showLoading: true);
  }

  Future<void> refresh() => _loadAll(showLoading: false);

  Future<void> retry(HomeSection section) =>
      _loadSection(section, showLoading: true);

  Future<void> _loadAll({required bool showLoading}) async {
    final refreshFailures = await Future.wait(
      HomeSection.values.map(
        (section) => _loadSection(section, showLoading: showLoading),
      ),
    );
    final message = refreshFailures.nonNulls.firstOrNull;
    if (message == null || isClosed) return;
    // One toast per refresh, then clear so the next failure re-triggers it.
    emit(state.copyWith(refreshError: message));
    emit(state.copyWith(refreshError: null));
  }

  /// Returns the failure message when the section kept its data instead of
  /// showing an error (silent refresh), otherwise `null`.
  Future<String?> _loadSection(
    HomeSection section, {
    required bool showLoading,
  }) => switch (section) {
    HomeSection.nextShift => _run<Application?>(
      previous: state.nextShift,
      showLoading: showLoading,
      fetch: () async =>
          (await _getUpcomingSchedule(GetUpcomingScheduleParams.next))
              .map((page) => page.data.firstOrNull),
      apply: (result) => state.copyWith(nextShift: result),
    ),
    HomeSection.waitingCount => _run<int>(
      previous: state.waitingCount,
      showLoading: showLoading,
      fetch: () async =>
          (await _getApplications(GetApplicationsParams.waitingCount))
              .map((page) => page.total),
      apply: (result) => state.copyWith(waitingCount: result),
    ),
    HomeSection.worked => _run<HistorySummary>(
      previous: state.worked,
      showLoading: showLoading,
      fetch: () async =>
          (await _getScheduleHistory(GetScheduleHistoryParams.summaryOnly))
              .map((page) => HistorySummary.fromMeta(page.meta)),
      apply: (result) => state.copyWith(worked: result),
    ),
    HomeSection.openEvents => _run<List<Event>>(
      previous: state.openEvents,
      showLoading: showLoading,
      fetch: () async => (await _getOpenEvents(
        GetOpenEventsParams(branchId: _branchId, page: 1, perPage: 5),
      )).map((page) => page.data),
      apply: (result) => state.copyWith(openEvents: result),
    ),
  };

  /// One section's lifecycle. [apply] reads `state` when called, so sections
  /// completing in any order never overwrite each other.
  Future<String?> _run<T>({
    required Section<T> previous,
    required bool showLoading,
    required Future<Result<T>> Function() fetch,
    required HomeState Function(Section<T> section) apply,
  }) async {
    if (showLoading) emit(apply(Section<T>.loading()));

    final result = await fetch();
    if (isClosed) return null;

    switch (result) {
      case Success(:final value):
        emit(apply(Section.loaded(value)));
      case Failed(:final message):
        if (!showLoading && previous is SectionLoaded<T>) return message;
        emit(apply(Section.error(message)));
    }
    return null;
  }
}
