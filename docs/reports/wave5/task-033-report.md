# TASK-033 — Fix tab-less EventsRoutes.root links from Home and Schedule

Branch `wave5/task-034` (stacked on TASK-034), commit this one (fix(router): link Home and Schedule to the right Events tab).

## What changed
- `lib/features/home/presentation/screens/home_screen.dart`: `Waiting` counter now `EventsRoutes.tracked`, `View list` now `EventsRoutes.open`.
- `lib/features/schedule/presentation/screens/schedule_screen.dart`: D3 `Browse events` now `EventsRoutes.open`.
- `test/features/home/presentation/screens/home_screen_test.dart`: GoRouter-based tests asserting path and `tab` query for both Home links.
- `test/features/schedule/schedule_screen_test.dart`: D3 test now also asserts `tab=open`.
- Grep for other `EventsRoutes.root` navigations: only `event_detail_screen.dart:146` (back fallback with nothing underneath, deep link / push); left as is, not in the ticket and no tab is specified for it.
- Optional `Worked` -> D2 History: skipped, needs a `tab` query and handling in `ScheduleScreen`, not small.

## Verification
- make analyze: No issues found / make test: touched files only (home + schedule_screen, 37 passed, --concurrency=2); full suite left to the orchestrator
- device checks: not run; routes asserted in widget tests only.

## Risks / follow-ups
- none

## Found, not fixed
- `EventsScreen.didUpdateWidget` only switches tab when `initialTab` differs from the previous widget's `initialTab`. Reading the code: Home `Waiting` (tracked), user switches manually to Open, Home `Waiting` again -> `initialTab` is tracked both times, so it likely stays on Open. Not reproduced on device. Fix would need a way to tell a fresh navigation from a rebuild (e.g. a navigation counter in the route's `state.extra`/key).
