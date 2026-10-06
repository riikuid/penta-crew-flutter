# TASK-033 — Fix tab-less EventsRoutes.root links from Home and Schedule (Waiting, View list, Browse events)

Kanban: TASK-033 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Links into Events must land on the tab the copy table / prototype specifies, not on whichever tab Events last showed.

Source: TASK-020 visual QA, cross-cutting #5 (`docs/reports/task-020/findings-b.md` B1, `findings-c.md` D3).

## Context
`EventsRoutes.root` carries no tab, so it opens the last-shown tab (Open by default). `EventsRoutes.open` / `EventsRoutes.tracked` already exist (C9 `Browse open events` and C10 use them correctly).

| Link | File | Should land on |
|---|---|---|
| B1 `Waiting` counter | `lib/features/home/presentation/screens/home_screen.dart:195` | Events › Tracked (prototype `screens.html:534` → `#C2`) |
| B1 `View list` | `home_screen.dart:302` | Events › Open (copy table B1) |
| D3 `Browse events` | `lib/features/schedule/presentation/screens/schedule_screen.dart:241` | Events › Open (copy table D3) |

Optional (SUGGESTION, prototype `screens.html:539`): B1 `Worked` counter → D2 History; this needs a `tab` query on `ScheduleRoutes` like Events has (`home_screen.dart:211`). Include it only if it stays small.

## Steps
1. Replace the three `context.go(EventsRoutes.root)` calls with `.tracked` / `.open`.
2. Grep for any other `EventsRoutes.root` navigation from features and fix the same way.
3. Widget tests asserting the target route (incl. the `tab` query).

## Acceptance criteria
- Visit Events › Tracked, go Home, tap `View list` → Open tab. Tap `Waiting` → Tracked tab. From D3 (`empty@example.com`-style fixture or `QA_VARIANT=fixtures`) `Browse events` → Open tab.
- `make analyze` and `make test` clean; one Conventional Commit.
