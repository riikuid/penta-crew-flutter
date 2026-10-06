# TASK-043 — Improve top toast placement so it doesn't cover the back button on root-level pages (C5, C6, E3)

Kanban: TASK-043 · priority lowest · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
After apply / withdraw / password change the top toast sits over the back button and the branch eyebrow for ~3 s; a tap there dismisses the toast instead of going back. Make the toast not block the header.

Source: TASK-020 visual QA, cross-cutting #15 (SUGGESTION; `docs/reports/task-020/findings-b.md` C5/C6, `findings-c.md` E3; screenshots `C5-applied-toast.png`, `C6-withdrawn-toast.png`).

## Context
- `lib/core/widgets/app_toast.dart:34-42` — `toastification.showCustom`, top centre, 3 s. Toast lands at top 61 pt (prototype 60), so position is right; the problem is hit-testing/overlap with the 44-px header on root-level pages.

## Steps
1. Pick one: offset the toast below the 44-px header on pages that have a back circle, or let taps outside the toast card pass through (`toastification` option / `IgnorePointer` on the wrapper), or keep placement and shorten the auto-dismiss. Note the choice on the ticket.
2. Apply to all `AppToast` calls (shared widget, no per-feature code).
3. Widget test: a tap on the back button while a toast is visible pops the page.

## Acceptance criteria
- Back works while the toast is visible on C5/C6/E3; toast still matches the copy table text and timing.
- `make analyze` and `make test` clean; one Conventional Commit.
