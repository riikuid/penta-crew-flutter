# TASK-034 — Fix Home not refetching after apply/withdraw elsewhere

Branch `wave5/task-034`, commit this one (fix(home): refetch Home silently when its tab is shown again).

## What changed
- `lib/features/home/presentation/screens/home_screen.dart`: new private `_RefreshOnShow` wrapper around the Scaffold. It watches `TickerMode` (go_router's indexed stack disables it for hidden branches, and Navigator disables it for a route covered by a pushed page) and calls the existing silent `HomeCubit.refresh()` on a hidden-to-visible transition. Throttled to one refetch per 2 s so quick tab switching does not stack requests. One mechanism therefore covers both tab re-show and returning from a pushed detail (`Inspect`, carousel card), so no per-call-site code was added.
- `test/features/home/presentation/screens/home_screen_test.dart`: two widget tests (re-show trigger incl. burst throttle and no skeleton; refetch after a pushed route pops).
- `HomeCubit.refresh()` already existed, is silent, and is already covered by bloc_tests ("does not put loaded sections back into loading", keeps data on failure), so no cubit change.

## Verification
- make analyze: No issues found / make test: 465 passed (full suite)
- device checks: not run (simulator flow B1 -> apply -> back not exercised); behaviour verified with widget tests only.
- tests added: `test/features/home/presentation/screens/home_screen_test.dart` (group `refresh on show`)

## Risks / follow-ups
- The 2 s throttle drops a legitimate refetch if a mutation happens within 2 s of the previous re-show; pull-to-refresh is unaffected.
- Worth one manual pass on a simulator for the apply -> back -> Home counter flow.
