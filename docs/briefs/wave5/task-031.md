# TASK-031 — Fix sign-in after sign-out landing on the previous user's last tab

Kanban: TASK-031 · priority high · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
After signing out from Profile, the next sign-in (even as a different user) must land on Home, not on the previous user's Profile.

Source: TASK-020 visual QA, cross-cutting #3 (`docs/reports/task-020/findings-b.md` Cross-cutting, evidence `docs/reports/task-020/A2-sign-in-lands-on-profile.png`).

## Context
- On sign-out the guard redirects to login with `from=/profile`; `LoginScreen` then does `context.go(widget.from ?? AppRoutes.home)` (`lib/features/auth/presentation/screens/login_screen.dart:131`).
- `from` is legitimate for the session-expired case (resume where the user was) and for deep links (A2d reset), so do not remove the mechanism — only the sign-out path must not carry it.

## Steps
1. On an explicit sign-out (`AuthCubit.signOut` → unauthenticated), navigate to `/login` without `from`, or clear `from` in the guard when the previous state was an explicit sign-out.
2. Keep `from` for session-expired redirects (A2 shows `Your session has expired…` and returns to the previous page after sign-in).
3. Unit/widget test for both paths.

## Acceptance criteria
- Sign out from E1 as `nadia@example.com`, sign in as `nadia@example.com` → lands on B1 Home.
- Session-expired redirect still returns to the page the user was on.
- `make analyze` and `make test` clean; one Conventional Commit.
