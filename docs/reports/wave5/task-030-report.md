# TASK-030 — Fix double keyboard inset on tab screens and make tab headers scroll with the list (C1, C2, N1)

Branch `wave5/task-030`, commit see `git log -1` (fix(events): single keyboard inset and scrolling headers on C1/C2/N1).

## What changed
- `lib/features/events/presentation/screens/events_screen.dart`: inner Scaffold gets `resizeToAvoidBottomInset: false` (shell already insets). Each tab is one `CustomScrollView` (`_ScrollList`) with the header (eyebrow, headline, search on Open, tabs) as the first sliver; body slivers switch per state (skeleton / error / empty / list). Same scroll-view structure in every state so the search field keeps focus while results reload. `_Refreshable` removed (pull-to-refresh now wraps the whole scroll view).
- `lib/features/notifications/presentation/screens/notifications_screen.dart`: same pattern; back circle, eyebrow and headline scroll with the list.
- Tests: `test/features/events/events_screen_test.dart` (header scrolls away; no overflow with 300 px inset), `test/features/notifications/presentation/screens/notifications_screen_test.dart` (header scrolls away; pull-to-refresh finder now `CustomScrollView`).

## Verification
- make analyze: clean / full `flutter test`: 466 passed
- device checks: not run (no simulator session); widget tests only.

## Risks / follow-ups
- Error/empty states now sit below the header inside the scroll view (`SliverFillRemaining`), and pull-to-refresh also works on the error state. Not compared against screenshots on device.
- Skeleton lists are now scrollable (were `NeverScrollable`).
