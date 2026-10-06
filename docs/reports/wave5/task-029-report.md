# TASK-029 — Router refreshing on every AuthCubit emission

Branch `wave5/task-029` (fix(router): refresh only when the session changes).

## What changed
- `lib/core/router/router_refresh.dart`: takes the session stream plus `SessionInfo`; notifies only when the fields the guards read (resolving, authenticated, verified, permissions) change. Profile-only `updateUser` no longer rebuilds routes, so the `context.pop()` on E2 / Change photo / A7 Submit again is no longer lost.
- `lib/app.dart`: passes `sl<AuthCubit>().stream` and the cubit as `SessionInfo`.
- `test/core/router/router_refresh_test.dart`: no notify on user-only update; notifies on sign-out/in and on verification/permission change.

## Verification
- make analyze: No issues found. Full `flutter test`: 466 passed.
- Not run on a simulator: cause was confirmed by code reading (listener fires on every emission; guards read only the four session fields), not by a logged device repro.

## Risks / follow-ups
- Device check of E2 Save, Change photo and A7 Submit again is still worth doing at review. Step 3 (pop independent of refresh) was not needed.
