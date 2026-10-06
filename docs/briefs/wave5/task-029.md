# TASK-029 — Fix router refreshing on every AuthCubit emission so E2 Save changes pops back to Profile

Kanban: TASK-029 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
`Save changes` on E2 Edit profile must return to E1 Profile (with the updated header). Today the toast shows but the page reloads to a blank form with a spinner and stays open; the user has to tap back. `Change photo` and A7 `Submit again` most likely share the bug (both call `AuthCubit.updateUser`).

Source: TASK-020 visual QA, cross-cutting #1 (`docs/reports/task-020/findings-c.md` E2 + Cross-cutting).

## Context
- `RouterRefresh` (`lib/core/router/router_refresh.dart`, wired in `lib/app.dart:32`) notifies go_router on **every** `AuthCubit` emission, including profile-only `updateUser` calls.
- Routes that build their cubit in the route builder (`lib/features/profile/profile_routes.dart:32-35` → `BlocProvider(create: (_) => sl<EditProfileCubit>()..load())`, same pattern on `/notifications`) are rebuilt with a fresh cubit on refresh, so the `context.pop()` issued by the listener in `edit_profile_screen.dart:251-260` is lost.
- Cause is likely, not proven — confirm first with `make run-dev` (`nadia@example.com` / `password1` → Profile → Edit profile → change Full name → Save).

## Steps
1. Reproduce and confirm the cause (add a temporary log on `RouterRefresh.notifyListeners`, remove it afterwards — no `print` left behind).
2. Only refresh the router when the auth **status** changes (unknown / unauthenticated / authenticated / verification status), e.g. map the stream to a status value and `distinct()` before notifying. Profile-only user updates must not trigger a route rebuild.
3. If the pop is still racy, make it independent of the refresh (pop before `updateUser`, or stable page key for the route).
4. Verify E2 save, `Change photo` (pick any image on the simulator) and A7 `Submit again` (`rejected@example.com`) all return where the copy table says and the Profile header shows the new value.
5. Unit test: `RouterRefresh` does not notify on a user-only update, does notify on sign-out / sign-in.

## Acceptance criteria
- E2 Save → toast `Profile updated` → back on E1 with the new name, no manual back.
- `Change photo` and A7 `Submit again` no longer reload their page.
- Session resolution / redirect behaviour on sign-in, sign-out and session expiry unchanged (foundation smoke flow still passes).
- `make analyze` and `make test` clean; one Conventional Commit (`fix(router): …`).
