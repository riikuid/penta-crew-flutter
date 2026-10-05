import '../models/application.dart';
import '../models/event_detail.dart';

/// Which prototype layout an `EventDetail` maps to (TASK-016 sub-task 2).
enum EventDetailView {
  /// C3 — no application of mine; Apply when `can_apply`, otherwise the
  /// reason line. Also the closed-with-no-application case (no action).
  open,

  /// C5 — waiting and the event is still open: Withdraw.
  applied,

  /// C7 — waiting but applications closed: read-only, lock note.
  closedWaiting,

  /// C8 — selected: "You're on the crew.", notes from admin.
  selected,

  /// C9 — not selected: thanks + "Browse open events".
  notSelected,
}

extension EventDetailViewX on EventDetail {
  /// Derived from `status` + `my_application.status` (plan §4 T6). The
  /// application wins over `cannot_apply_reason`: a closed event with my
  /// `selected` application is C8, not "closed" (decisions D-13 notes).
  EventDetailView get view => switch (myApplication?.status) {
    ApplicationStatus.waiting =>
      isClosed ? EventDetailView.closedWaiting : EventDetailView.applied,
    ApplicationStatus.selected => EventDetailView.selected,
    ApplicationStatus.notSelected => EventDetailView.notSelected,
    _ => EventDetailView.open,
  };
}
