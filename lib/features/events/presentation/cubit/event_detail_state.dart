import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/event_detail.dart';

part 'event_detail_state.freezed.dart';

/// Event detail (C3–C9). The screen derives which of the six layouts to draw
/// from [EventDetailLoaded.detail] (see `event_detail_view.dart`).
///
/// [EventDetailLoaded.busy] is true while an apply / withdraw request is in
/// flight — the action button spins and the sheets stay closed. [notice] is a
/// one-shot outcome the screen turns into a toast; it is compared by identity
/// so two identical failures in a row still both surface.
@freezed
sealed class EventDetailState with _$EventDetailState {
  const factory EventDetailState.initial() = EventDetailInitial;
  const factory EventDetailState.loading() = EventDetailLoading;
  const factory EventDetailState.loaded({
    required EventDetail detail,
    @Default(false) bool busy,
    EventDetailNotice? notice,
  }) = EventDetailLoaded;
  const factory EventDetailState.error({required String message}) =
      EventDetailError;
}

/// Outcome of an apply / withdraw, consumed once by the screen's listener.
/// Deliberately without value equality (see [EventDetailState]).
sealed class EventDetailNotice {
  const EventDetailNotice();
}

/// C5 toast: `Application sent` / `Applied as {role} for {title}.`
final class ApplicationSent extends EventDetailNotice {
  const ApplicationSent({required this.roleName, required this.eventTitle});

  final String roleName;
  final String eventTitle;
}

/// C6 toast: `Application withdrawn` / `You can apply again until …`
final class ApplicationWithdrawn extends EventDetailNotice {
  const ApplicationWithdrawn({required this.reapplyUntil});

  final DateTime reapplyUntil;
}

/// Error toast with a message already safe to show (per-code copy or the
/// server's `message`).
final class ActionFailed extends EventDetailNotice {
  const ActionFailed(this.message);

  final String message;
}
