# TASK-036 — Fix TagChip stretching to full width inside Wrap (C1, C3, D1, E1)

Kanban: TASK-036 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
`TagChip` must size to its content (30/32-pt pills wrapping in one row like the prototype). Today each chip expands to the full available width and chips stack: C1 position chips (`Crew`, `Event Manager` ~258 pt), C3 requirement chips (~362 pt), D1 `as Crew` chip, E1 role chips.

Source: TASK-020 visual QA, cross-cutting #8 (`docs/reports/task-020/findings-b.md` C1/C3, `findings-c.md` D1/E1).

## Context
- Root cause: `Container(alignment: Alignment.center)` in `lib/core/widgets/tag_chip.dart:55-58` expands to the max width under loose constraints.
- Prototype: C1 `docs/prototype/screens.html:650-651` (30-px content-width pills), C3 `:742-746` (32-px white outlined pills).

## Steps
1. Drop `alignment` and centre with `Row(mainAxisSize: MainAxisSize.min)` (or `Align(widthFactor: 1)`).
2. Check every `TagChip` call site still looks right (grep): C1, C3, D1, E1, A6 pills if shared.
3. Widget test: chip width equals its content inside a wide parent; several chips in a `Wrap` share one row.

## Acceptance criteria
- C1/C3/D1/E1 chips are content-width and wrap inline, matching the prototype.
- `make analyze` and `make test` clean; one Conventional Commit.
