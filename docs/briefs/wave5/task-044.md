# TASK-044 — Add tap feedback to GroupedCard rows (E1 Edit profile / Change password)

Kanban: TASK-044 · priority lowest · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
`Edit profile` / `Change password` rows on E1 Profile must show a ripple / pressed state.

Source: TASK-020 visual QA, cross-cutting #16 (SUGGESTION; `docs/reports/task-020/findings-c.md` E1).

## Context
- The `InkWell` in `ActionRow` paints on the Scaffold's `Material` underneath, which the white `DecoratedBox` of `GroupedCard` hides (`lib/features/profile/presentation/widgets/grouped_card.dart:16-21,96`).
- `AppCard` in `core/widgets` already uses a `Material` with surface colour, rounded shape and `clipBehavior` — follow that.

## Steps
1. Replace the `DecoratedBox` with a `Material` (surface colour, radius from tokens, `clipBehavior: Clip.antiAlias`), keeping the hairline border.
2. Check A6a View my data (reuses the E1 row style) still renders identically.
3. Widget test: ink splash is found inside the card on tap.

## Acceptance criteria
- Rows ripple inside the card on E1; visual at rest unchanged.
- `make analyze` and `make test` clean; one Conventional Commit.
