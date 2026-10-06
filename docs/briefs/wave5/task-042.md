# TASK-042 — Fix mock sessions not surviving a cold start (dev only)

Kanban: TASK-042 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
With `USE_MOCK=true`, a signed-in session must resume at Home after a cold start, as the TASK-020 brief and the smoke test expect. Today every cold start after a sign-in shows `Your session has expired. Please sign in again.` on A2.

Source: TASK-020 visual QA, cross-cutting #14 (`docs/reports/task-020/findings-a.md` Cross-cutting).

## Context
- `MockServer._tokens` is in-memory (`lib/core/network/mock/mock_server.dart:755`) while the keychain keeps the token across restarts and even reinstalls (only `xcrun simctl keychain <udid> reset` clears it).
- Tokens have the shape `mock-token-<id>-…`.

## Steps
1. Let `_userForToken` parse the user id from a `mock-token-<id>-…` token when it is not in `_tokens`, and resume that persona.
2. Keep the explicit sign-out / expired paths: a token that was signed out must still 401 within the same process; an unknown shape → 401.
3. Unit test in `test/core/network/mock/`.

## Acceptance criteria
- `make run-dev`, sign in as `nadia@example.com`, kill the app, relaunch → B1 Home.
- `make analyze` and `make test` clean; one Conventional Commit (`fix(mock): …`).
