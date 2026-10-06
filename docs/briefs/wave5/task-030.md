# TASK-030 — Fix double keyboard inset on tab screens and make tab headers scroll with the list (C1, C2, N1)

Kanban: TASK-030 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
On C1 Events › Open, typing in the search field must show results while the keyboard is open. Today the header `Column` overflows ("RenderFlex overflowed by 35/78 px", stripe across the search field) and the list gets ~0 height, so results are invisible until the keyboard closes. Also make the tab headers scroll with the list like the prototype.

Source: TASK-020 visual QA, cross-cutting #2 (`docs/reports/task-020/findings-b.md` C1/C2, `findings-c.md` N1).

## Context
- `EventsScreen` has its own `Scaffold` inside the shell's `Scaffold` (`lib/features/events/presentation/screens/events_screen.dart:105`), so the keyboard inset is applied twice (body ≈ 137 pt instead of ≈ 470).
- The header block (eyebrow, headline, search, tabs, `events_screen.dart:108-151`) is fixed and takes ~282 pt; only ~2 cards are visible and a drag on the header does nothing. Prototype scrolls the whole column (`docs/prototype/screens.html:628`, C2 `:668`). C2 cards clip hard under the tab bar when scrolled.
- N1 `lib/features/notifications/presentation/screens/notifications_screen.dart` has the same fixed-header pattern (cards clip under the header).
- D1/D2 Schedule already scroll the header with the list — use it as the reference implementation.

## Steps
1. `resizeToAvoidBottomInset: false` on the inner Scaffold (or remove the nested Scaffold) so the inset is applied once.
2. Convert C1/C2 to one `CustomScrollView` per tab with the header as a sliver (or the D1 pattern), keeping the pull-to-refresh and the skeletons.
3. Apply the same to N1.
4. Keep the `FloatingPillNav` clearance at the bottom of the lists.
5. Widget tests: header scrolls away with the list; no overflow with a 300-pt bottom inset (`tester.view.viewInsets`).

## Acceptance criteria
- C1: with the keyboard open, search results are visible and no overflow stripe appears.
- C1/C2/N1: dragging anywhere scrolls the header away with the list; no card clips under a fixed header.
- Loading, empty and error states on all three screens unchanged visually (compare with the TASK-020 screenshots).
- `make analyze` and `make test` clean; one Conventional Commit.
