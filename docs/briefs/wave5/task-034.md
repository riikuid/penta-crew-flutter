# TASK-034 — Fix Home not refetching after apply/withdraw elsewhere (B1 Waiting counter stale)

Kanban: TASK-034 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Home must reflect mutations made elsewhere: after withdrawing an application in C5/C6 the `Waiting` counter and the `Open for you` carousel must update when the Home tab is shown again, without a manual pull-to-refresh.

Source: TASK-020 visual QA, cross-cutting #6 (`docs/reports/task-020/findings-b.md` B1, screenshots `B1-after-flow.png` vs `B1-after-flow-refreshed.png`).

## Context
- `HomeCubit.load` runs once in the route builder (`lib/features/home/home_routes.dart:21-25`); nothing refetches when the tab is re-selected or when a pushed detail pops.
- `EventsScreen._openDetail` already does a silent refresh after returning from a detail (`events_screen.dart:234-239`) — reuse the pattern. TASK-019 added a refetch-on-show/resume for the unread dot (`UnreadDot`), which is another in-repo reference.
- Keep the skeleton out of it: a silent `refresh()` must keep the current data visible (B2 behaviour: data stays, only the indicator shows).

## Steps
1. Add `HomeCubit.refresh()` (silent, no `loading` emission) if not present.
2. Trigger it when the Home branch becomes visible again (StatefulShellRoute branch switch) and after returning from a pushed detail (`Inspect`, carousel card).
3. Debounce so switching tabs quickly doesn't fire several requests.
4. `bloc_test` for refresh keeping the previous state; widget test for the re-show trigger.

## Acceptance criteria
- Flow B1 → carousel card → apply → back → Home shows `Waiting` +1 and the card gone/updated without pull-to-refresh; withdraw the same way → counter back.
- No skeleton flash on re-show.
- `make analyze` and `make test` clean; one Conventional Commit.
