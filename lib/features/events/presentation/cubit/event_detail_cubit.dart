import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../models/event_detail.dart';
import '../../usecases/apply_to_event.dart';
import '../../usecases/get_event_detail.dart';
import '../../usecases/withdraw_application.dart';
import 'event_detail_state.dart';

/// Event detail page (C3–C9): one fetch, then apply / withdraw mutations that
/// refetch the detail so the screen re-derives its layout from the server's
/// truth (`status`, `my_application`, `can_apply`) instead of guessing.
///
/// Error copy: business failures branch on `Failed.code` (§2.6); everything
/// else shows the server's `message` as-is.
class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit({
    required this._getEventDetail,
    required this._applyToEvent,
    required this._withdrawApplication,
  }) : super(const EventDetailState.initial());

  final GetEventDetail _getEventDetail;
  final ApplyToEvent _applyToEvent;
  final WithdrawApplication _withdrawApplication;

  int? _eventId;

  /// Per-code apply copy (ticket T6). `date_conflict` is also pre-empted by
  /// `can_apply` (D-09); it only reaches here when the detail went stale.
  static String applyFailureMessage(String? code, String message) =>
      switch (code) {
        'date_conflict' => 'You already have an event on this date',
        'closed' => 'Applications for this event have closed',
        'already_applied' => "You've already applied to this event",
        _ => message,
      };

  Future<void> fetch(int eventId) async {
    _eventId = eventId;
    emit(const EventDetailState.loading());

    switch (await _getEventDetail(eventId)) {
      case Success(:final value):
        if (!isClosed) emit(EventDetailState.loaded(detail: value));
      case Failed(:final message):
        if (!isClosed) emit(EventDetailState.error(message: message));
    }
  }

  Future<void> retry() {
    final eventId = _eventId;
    return eventId == null ? Future.value() : fetch(eventId);
  }

  /// C4 confirm → `POST /events/{id}/applications`. On success the detail is
  /// refetched (now C5) and an [ApplicationSent] notice is attached.
  Future<void> apply(int positionId) async {
    final current = state;
    if (current is! EventDetailLoaded || current.busy) return;
    emit(current.copyWith(busy: true, notice: null));

    final result = await _applyToEvent(
      ApplyToEventParams(eventId: current.detail.id, positionId: positionId),
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        final detail = await _refetch(fallback: current.detail);
        if (isClosed) return;
        emit(
          EventDetailState.loaded(
            detail: detail,
            notice: ApplicationSent(
              roleName: value.appliedPosition.role.name,
              eventTitle: current.detail.title,
            ),
          ),
        );
      case Failed(:final message, :final code):
        await _fail(
          current.detail,
          message: applyFailureMessage(code, message),
          stale: code != null,
        );
    }
  }

  /// C6 confirm → `DELETE /applications/{id}`. `deadline_passed` means the
  /// detail is stale: after the toast it is refetched and renders as C7.
  Future<void> withdraw() async {
    final current = state;
    if (current is! EventDetailLoaded || current.busy) return;
    final application = current.detail.myApplication;
    if (application == null) return;
    emit(current.copyWith(busy: true, notice: null));

    final result = await _withdrawApplication(
      WithdrawApplicationParams(applicationId: application.id),
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        final detail = await _refetch(fallback: current.detail);
        if (isClosed) return;
        emit(
          EventDetailState.loaded(
            detail: detail,
            notice: ApplicationWithdrawn(reapplyUntil: application.closesAt),
          ),
        );
      case Failed(:final message, :final code):
        await _fail(current.detail, message: message, stale: code != null);
    }
  }

  /// Toast first (busy off, data untouched); a business error (`code` set)
  /// means the server sees a different state than we show, so refetch.
  Future<void> _fail(
    EventDetail previous, {
    required String message,
    required bool stale,
  }) async {
    emit(
      EventDetailState.loaded(detail: previous, notice: ActionFailed(message)),
    );
    if (!stale) return;
    final detail = await _refetch(fallback: previous);
    if (!isClosed) emit(EventDetailState.loaded(detail: detail));
  }

  /// Silent reload after a mutation; keeps [fallback] when it fails so the
  /// outcome toast still has a page to sit on.
  Future<EventDetail> _refetch({required EventDetail fallback}) async {
    final result = await _getEventDetail(fallback.id);
    return result.valueOrNull ?? fallback;
  }
}
