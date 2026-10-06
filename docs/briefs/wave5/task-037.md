# TASK-037 — Fix empty/error _StateCard placement (centred, shrink-wrapped, 24-pt inset) and the pagePadding token

Kanban: TASK-037 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Empty and error cards must be top-aligned under the header/tabs, full width, with the prototype's 20-pt page inset. Today `_StateCard` is vertically centred in the list area, shrink-wraps to its text (C3 `Event not found.` is a 166-pt card mid-screen) and uses the 24-pt `AppSize.pagePadding`. Affects C3 error, C10, D2, D3, N1 empties.

Source: TASK-020 visual QA, cross-cutting #9 (`docs/reports/task-020/findings-b.md` C3/C10, `findings-c.md` D2/D3/N1, `findings-a.md` Cross-cutting).

## Context
- `lib/core/widgets/state_views.dart:97-103` (`Center` + intrinsic width + `AppSize.pagePadding`).
- Prototype: C10 `docs/prototype/screens.html:952` (`margin-top:24px`, 20-pt inset); D3 `:1064` (24 + 18-pt gap).
- `AppSize.pagePadding = 24` in `lib/core/theme/app_tokens.dart` while every screen and the prototype use 20 — decide with the Lead whether to change the token (check all usages) or document it and pass 20 here. Changing the token is the cleaner fix if nothing relies on 24.

## Steps
1. `width: double.infinity` on the card; top-align with the spacing from the prototype; 20-pt inset.
2. Decide/fix the `pagePadding` token (grep usages first; list them in the ticket comment).
3. Widget tests for `EmptyView` / `ErrorView` layout.

## Acceptance criteria
- C10, D2, D3, N1 empties sit just under the tabs, full width, 20-pt inset; C3 error card is full width.
- A screens still measure 20 pt side inset.
- `make analyze` and `make test` clean; one Conventional Commit.
