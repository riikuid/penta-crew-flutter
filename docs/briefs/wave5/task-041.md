# TASK-041 — Fix touch targets under 44 pt (C1 search clear, B1 View list, N1 Mark all read)

Kanban: TASK-041 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Every tappable control must have at least a 44-pt hit area without changing its visual size.

Source: TASK-020 visual QA, cross-cutting #13 (`docs/reports/task-020/findings-b.md` B1/C1, `findings-c.md` N1).

## Context
| Control | File | Today |
|---|---|---|
| C1 search clear `×` | `lib/features/events/presentation/screens/events_screen.dart:292-297` | bare 18×18 `GestureDetector` |
| B1 `View list` | `lib/features/home/presentation/screens/home_screen.dart:300-311` | ~31 × 60 pt bare `GestureDetector` |
| N1 `Mark all read` | `lib/features/notifications/presentation/screens/notifications_screen.dart:270-287` | ~33 pt tall bare `GestureDetector` |

## Steps
1. Use a 44-pt `IconButton` (with `visualDensity`/padding so the glyph stays 18 px) for the clear button; `ConstrainedBox(minHeight: 44)` or a padded `TextButton` for the two text actions (keep 14/500 text and alignment).
2. Grep for other bare `GestureDetector`s on small text/icon controls and fix any under 44 pt.
3. Widget tests asserting the hit box size (`tester.getSize`).

## Acceptance criteria
- The three controls measure ≥ 44 pt in both axes; the visible layout matches the TASK-020 screenshots.
- `make analyze` and `make test` clean; one Conventional Commit.
