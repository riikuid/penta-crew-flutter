# TASK-032 — Fix bottom sheets from tab screens opening under the floating nav (E1 sign-out)

Kanban: TASK-032 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
The sign-out confirmation sheet on E1 Profile (and any sheet opened from a tab screen) must cover the `FloatingPillNav`: nav dimmed by the scrim, not tappable, sheet bottom edge not covered.

Source: TASK-020 visual QA, cross-cutting #4 (`docs/reports/task-020/findings-c.md` E1, screenshot `E1-sign-out-sheet.png`).

## Context
- `ConfirmSheet.show` calls `showModalBottomSheet` without `useRootNavigator` (`lib/features/profile/presentation/widgets/confirm_sheet.dart:37`), so the sheet opens on the shell navigator under the nav.
- `OptionSheet.show` (`option_sheet.dart`) has the same call shape; A5 Gender/Branch sheets use `_SheetFrame` in `register_screen.dart:550` (root-level page, so not affected, but check).
- A6/A7 and C4/C6 are root-level pages and already look right.

## Steps
1. `useRootNavigator: true` in `ConfirmSheet.show` and `OptionSheet.show` (and any other `showModalBottomSheet` call reachable from a tab screen — grep for it).
2. Make sure `context.pop()` inside the sheets still closes the sheet, not the page.
3. Widget test: sheet opened from inside the shell renders above the nav.

## Acceptance criteria
- E1 → Sign out: nav is under the scrim and not tappable; `Stay signed in` and `Sign out` behave as before.
- C4/C6 and A6/A7 sheets unchanged.
- `make analyze` and `make test` clean; one Conventional Commit.
