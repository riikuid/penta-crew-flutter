# TASK-039 — Fix page top offset (+12/16 pt over the safe area) and bottom bar/sheet spacing vs the prototype

Kanban: TASK-039 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Align vertical page geometry with the prototype: content on every tab and detail page starts 12–16 pt lower than the prototype, and bottom action bars / sheets sit 14–16 pt higher (extra padding added on top of the home-indicator inset).

Source: TASK-020 visual QA, cross-cutting #11 (`docs/reports/task-020/findings-b.md` Cross-cutting, `findings-a.md` A2/A4, `findings-c.md`).

## Context
Top offset (prototype 60/62 pt = status bar + nothing extra, `docs/prototype/screens.html:506,628,712`):
- `home_screen.dart:56` (`top: 12`), `events_screen.dart:112` and `event_detail_screen.dart:119` (`16`), `schedule_screen.dart:123` (`padding.top + 16`), `profile_screen.dart:44` (14), `notifications_screen.dart:240` (16).

Bottom spacing (prototype 34–40 pt total incl. home indicator):
- A2 `auth_page.dart:37` (24 + 34 = 58 vs 40) → `SafeArea(minimum: bottom 40)` like `VerificationScreen`.
- A4 `register_screen.dart:406-410` (12 + 34 = 46 vs 36).
- C3/C5/C9 action bar `event_detail_screen.dart:498` (16 + 34 = 50 vs 34, prototype `:750`); C4/C6 sheets ~50 vs 36 (`:769`).

**Decision needed first:** confirm with the Lead that the prototype's 60/62 means "status bar only" (the QA reading) rather than "below the safe area". Ask on this ticket before changing the top offsets; do the bottom spacing regardless.

## Steps
1. Bottom: use `SafeArea(minimum: …)` with the prototype value and drop the inner padding on the files above.
2. Top: once confirmed, remove the extra 12/16 pt so content starts at the safe-area edge.
3. Re-measure against the TASK-020 screenshots (3× PNG ÷ 3).

## Acceptance criteria
- Headers start at ≈60–62 pt on B1, C1, C3, D1, E1, N1; A2/A4/C3 bottom spacing matches the prototype (40/36/34).
- `make analyze` and `make test` clean; one Conventional Commit.
