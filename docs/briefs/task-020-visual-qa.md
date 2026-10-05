# TASK-020 — Investigate: visual QA of the complete mock app against the prototype

Kanban: TASK-020 · priority low · blocked by TASK-014..019 · **report only, no code changes**.
Plan reference: `docs/implementation-plan.md` §4 T10 (Wave 4). Run only after
TASK-019 has been merged to `main`.

## Goal

Run the finished app against the mock backend, capture every screen, compare
with `docs/prototype/screens.html` (A1–E3) and the screens without a prototype
(Forgot / Check email / Reset password, View my data, Notifications), and report
BLOCKER / ISSUE / SUGGESTION per screen. The Lead opens fix tickets from it.

## Read first

- `AGENTS.md`; `docs/implementation-plan.md` §1 (screen list + states), §2.7.
- `docs/decisions.md` D-01..D-14 — do **not** flag as issues: D-08's removed
  warning, D-12's Material icons, light-only theme, D-14 (no briefing line on
  the Home hero), sign-out confirmation sheet (decided, see copy table E1).
- `docs/copy-table.md` — the character-exact wording per screen. Any deviation
  in wording, casing, en dash (`–`) or middle dot (`·`) is an ISSUE.
- TASK-006 gap audit was closed by TASK-028 (`git show 1fc75d9 --stat`); re-check
  those items visually rather than re-deriving them.

## How

- `make run-dev` (Flutter via fvm, `USE_MOCK=true` set in `env/dev.json`) on an
  iOS simulator (iPhone 15/16 class) and, if available, an Android emulator.
- Personas (password `password1`): `nadia@example.com` (approved),
  `pending@example.com`, `rejected@example.com`. Mock data lives in
  `lib/core/network/mock/fixtures/mock_data.dart`; `MockServer._reset()` does a
  JSON round-trip, so edits there show up on restart.
- Screenshot every state listed in plan §1 (`xcrun simctl io booted screenshot`
  works without AppleScript) and compare side by side with the prototype screen
  of the same id. Check: layout, spacing, type scale, colours, copy, state
  handling (loading skeletons, empty, error), keyboard behaviour on forms,
  bottom safe area vs the floating nav, back navigation, touch targets ≥ 44,
  and the flows apply → Tracked → withdraw, register → verification,
  edit profile → header updates, notification tap → event detail.
- Also run `integration_test/foundation_smoke_test.dart` via `flutter drive`
  (command in README) and report pass/fail.

## Deliver

- `docs/reports/task-020-report.md`: 5-line summary, then one section per
  screen id with findings (severity · what · where in code if obvious ·
  suggested fix), then a final list of cross-cutting issues.
- Screenshots under `docs/reports/task-020/<screen-id>-<state>.png`.
- No source changes. If something blocks the run (build error, crash), report
  it as the first BLOCKER and stop rather than fixing it.
