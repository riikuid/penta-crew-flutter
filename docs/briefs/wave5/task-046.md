# TASK-046 — Fix foundation_smoke_test (enterText dropped after unfocus, sign-out button lookup)

Kanban: TASK-046 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
`integration_test/foundation_smoke_test.dart` must pass again on the iOS simulator. It currently FAILs 2/2 at line 61 — a test bug, not an app bug.

Source: TASK-020 visual QA report, section *foundation_smoke_test* (`docs/reports/task-020-report.md`, details in `docs/reports/task-020/findings-a.md`).

## Context
- After the second `signIn('nadia@example.com', 'password1')` the test expects `FloatingPillNav` and finds none. `tester.enterText` is silently dropped when it runs right after the app's `FocusScope.unfocus()` (the app's `_submit` unfocuses; the test types the password without re-focusing, so no text-input client is attached yet). Tapping the field and pumping ~350 ms before `enterText` fixed it in the TASK-020 drivers (`integration_test/visual_qa_group_a_test.dart`, see the focus helper added in commits `0d0c716` / `364c7e3`).
- The `signOut` helper looks for an `OutlinedButton`, but A6/A7 render `Sign out` as a ghost `TextButton`, so it would fail later too.
- Run with: `fvm flutter drive --driver=test_driver/integration_test.dart --target=integration_test/foundation_smoke_test.dart --dart-define-from-file=env/dev.json -d <device-id>`. If a session from a previous run persists in the keychain, reset it with `xcrun simctl keychain <udid> reset` (or wait for the mock-session fix ticket).

## Steps
1. In the sign-in helper: tap the field, `pumpAndSettle`/pump ~350 ms, then `enterText` (reuse the group A driver's helper if it is cleanly extractable into `integration_test/support/`).
2. In `signOut`: find the ghost `TextButton` with text `Sign out` on A6/A7 (and the E1 button where applicable).
3. Run the smoke test twice on the simulator; attach the terminal output and the final screenshots to this ticket.

## Acceptance criteria
- `foundation_smoke_test` passes 2/2 consecutive runs on an iPhone 16-class simulator with `USE_MOCK=true`.
- No `lib/` changes.
- One Conventional Commit (`test(smoke): …`).
