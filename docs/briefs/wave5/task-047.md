# TASK-047 — Fix round-1 leftovers: Events tab re-tap, Home refetch throttle, A4 trailingIcon

Kanban: TASK-047 · priority low · follow-up to wave 5 round 1 (TASK-033, TASK-034, TASK-035). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Close the three small items the round-1 subagents reported as "found, not fixed". All three are self-contained; one worker, one branch, one Conventional Commit.

## Context
Round 1 is merged on `main` (`3c715d3`). Reports: `docs/reports/wave5/task-033-report.md`, `task-034-report.md`, `task-035-report.md`.

## Steps
1. **Events tab re-tap (from TASK-033)** — `lib/features/events/presentation/screens/events_screen.dart` ~line 80: `didUpdateWidget` switches tab only when `initialTab` differs from the previous widget's `initialTab`. Repro: Home → tap `Waiting` (tracked) → swipe manually to Open → back to Home → tap `Waiting` again → stays on Open. Fix: make a fresh navigation distinguishable from a rebuild (e.g. pass a navigation nonce via `state.extra` or a `ValueKey` on the route, or compare against the *current* tab controller index instead of the previous widget's `initialTab`). Prefer the smallest change that keeps the `EventsRoutes.open/tracked` call sites untouched. Widget test: navigate tracked → switch tab → navigate tracked again → tab is tracked.
2. **Home refetch throttle (from TASK-034)** — `lib/features/home/presentation/screens/home_screen.dart`, `_RefreshOnShow`: the 2 s throttle drops a legitimate refetch when a mutation lands < 2 s after the previous re-show. Fix direction: throttle only *repeated shows without an intervening hide* (reset the timestamp on the visible → hidden transition), so every hidden → visible transition refetches while rapid tab flicker is still coalesced. Update the `refresh on show` test group accordingly.
3. **A4 `_ContinueButton` trailingIcon (from TASK-035)** — add an optional `trailingIcon` to `AppButton` (`lib/core/widgets/app_button.dart`), sized with the existing `AppButtonSize.iconSize`, and use it on the A4 continue button in `register_screen.dart` (see the prototype's arrow). Keep `leadingIcon` behaviour unchanged. Extend `app_button_test.dart`.

## Constraints
- No new dependencies.
- Do not touch `events_screen.dart` beyond the `didUpdateWidget` / tab-sync logic — its sliver layout was just restructured by TASK-030.
- Report to `docs/reports/wave5/task-047-report.md`.

## Acceptance criteria
- Repro in step 1 no longer reproduces (widget test added).
- Home refetches on every hidden → visible transition; the burst-flicker test still passes.
- A4 shows the trailing icon; `AppButton` sizes unchanged.
- `make analyze` clean, `make test` green.
- One Conventional Commit, e.g. `fix(events,home,core): round-1 follow-ups (tab re-tap, refetch throttle, trailingIcon)`.
