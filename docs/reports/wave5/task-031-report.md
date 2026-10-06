# TASK-031 — Sign-in after sign-out lands on previous tab

Branch `wave5/task-031`, squashed (fix(router): drop `from` on explicit sign-out).

## What changed
- `lib/core/session/session_info.dart`: new `signedOutByUser` getter.
- `lib/features/auth/presentation/cubit/auth_cubit.dart`: flag set in `logout()`, cleared in `setAuthenticated`. Session-expired path (401) leaves it false, so `from` is kept.
- `lib/core/router/route_guard.dart`: `guard()` and `unverifiedOnly()` share `_loginRedirect`, which omits `?from=` when `signedOutByUser`.
- Tests: fakes in `route_guard_test.dart`, `auth_routes_test.dart`, `push_notification_listener_test.dart` gained the getter.

## Verification
- make analyze: No issues found
- make test: 465 passed
- tests added: `test/core/router/route_guard_test.dart` (signed out -> `/login` with no from; existing test covers the `from` path), `test/features/auth/auth_cubit_test.dart` (flag set/cleared)
- device checks: not run (guard logic covered by widget tests)

## Risks / follow-ups
- Flag is in memory only; after a cold start it is false, which is correct (no signed-out user then).
