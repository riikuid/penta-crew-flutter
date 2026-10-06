# TASK-045 — Refactor duplicate CircleBackButton into core/widgets and fix short identifiers in progress_timeline

Kanban: TASK-045 · priority lowest · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Small maintainability cleanup from the QA run:
1. Two `CircleBackButton` implementations exist (`lib/features/auth/presentation/widgets/` and `lib/features/profile/presentation/widgets/`); A6a `verification_data_screen.dart` imports profile's across features. Keep one in `lib/core/widgets/` and delete the other.
2. `lib/core/widgets/progress_timeline.dart:54,169,188` use `i` as a loop variable, against AGENTS.md §4.1 naming.

Source: TASK-020 visual QA, cross-cutting #17 (SUGGESTION; `docs/reports/task-020/findings-a.md` A6a + Cross-cutting).

## Steps
1. Move the richer of the two `CircleBackButton`s to `core/widgets/circle_back_button.dart`, reconcile any API difference, update all imports, delete the duplicates.
2. Rename the loop variables to descriptive names.
3. Existing widget tests pass; move/merge any test that lived next to the deleted widget.

## Acceptance criteria
- One `CircleBackButton` in `core/widgets`; no feature imports another feature's widget for it.
- No single-letter identifiers in `progress_timeline.dart`.
- No visual change (compare A2b/A6a/E2 screenshots).
- `make analyze` and `make test` clean; one Conventional Commit (`refactor(core): …`).
