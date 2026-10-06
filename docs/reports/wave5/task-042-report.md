# TASK-042 — Fix mock sessions not surviving a cold start

Branch `wave5/task-042` (fix(mock): resume mock sessions after a cold start).

## What changed
- `lib/core/network/mock/mock_server.dart`: `_userForToken` falls back to the id in `mock-token-<id>-…` when the token is not in `_tokens`; a `_signedOut` set (filled on `/logout`, cleared on reset) keeps signed-out tokens at 401 within the process. Unknown shapes still 401.
- `test/core/network/mock/mock_server_session_test.dart`: resume, sign-out, bad-shape tests.

## Verification
- make analyze: clean. Touched tests + existing mock_server_test: 19 passed (`--concurrency=2`).
- Full suite not run to completion per orchestrator (RAM); an aborted run showed load errors in auth tests, likely memory pressure, not related to this change.
- Device check (sign in, kill, relaunch) not run.

## Risks / follow-ups
- Tokens for users registered in a previous process resolve to no user, so 401, as before.
