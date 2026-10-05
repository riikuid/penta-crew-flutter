# TASK-019 — Notifications: report

Branch `wave3/task-019-notifications` (from `main` `ff43f9f`), worktree
`.claude/worktrees/task-019`. Not pushed; merge pending the Lead's approval.

## What changed

Delivered in four units, following the brief's Steps 1–4:

1. **List** — `NotificationsCubit` (paginated, `SampleListCubit` pattern:
   sequence guard, refresh-with-restore) and `NotificationsScreen` replacing
   the placeholder: N1 copy, `Today` / `Earlier` grouping, unread ink dot,
   `Mark all read` link (hidden at 0), skeleton, empty state, error state,
   pull-to-refresh, infinite scroll. `markRead` / `markAllRead` are
   optimistic; server failure is ignored per the brief.
2. **Routing** — `routeForNotification(type, data)` implements the D-06
   table; `null` = stay for `unknown` and for event-detail types without a
   parseable `event_id`. `openNotificationRoute` centralises `go` (Home tab
   root) vs `push` (root-level page). `notificationTypeFromWire` maps push
   payload strings to `NotificationType`. Row tap → optimistic mark-read →
   navigate.
3. **Unread badge** — `UnreadCountCubit` (`Cubit<int>`, lazy singleton in
   `notifications_di.dart`) fetched when Home first shows and on
   `AppLifecycleState.resumed`; `NotificationsCubit` syncs it (`set` from
   `meta.unread_count`, `decrement` on mark-read of an unread row, `clear` on
   mark-all). `UnreadDot` wraps Home's `_BellButton` with an 8 px ink dot and
   2 px surface ring (B1: dot, not a count).
4. **Push routing** — `PushNotificationListener` subscribes to
   `PushService.onMessageOpened` → `notificationTypeFromWire` →
   `routeForNotification` → `openNotificationRoute` on the root router; while
   `SessionInfo.isResolving` the latest path is held and flushed on the first
   session change after resolve. `onTokenRefresh` → `UpdateDeviceToken` only
   when authenticated; failures go to Talker only. Wired in `lib/app.dart`
   (+12 lines: field, construct + `start()` in `initState`, `dispose()`).

## Files touched

Inside the ticket's folders (`lib/features/notifications/**`,
`test/features/notifications/**`):

- `notification_routing.dart`, `push_notification_listener.dart` (new, feature
  level so bootstrap can import them)
- `presentation/cubit/notifications_cubit.dart`, `notifications_state.dart`
  (+ `.freezed.dart`), `unread_count_cubit.dart` (new)
- `presentation/notification_formats.dart`, `presentation/widgets/unread_dot.dart`
  (new)
- `presentation/screens/notifications_screen.dart` (placeholder replaced)
- `notifications_di.dart`, `notifications_routes.dart`
- `models/app_notification.dart` — private `_intOf` became the public
  `tolerantInt` so routing can reuse the string→int parse (no behaviour change)
- tests: `fixtures.dart`, `notification_routing_test.dart`,
  `push_notification_listener_test.dart`, `presentation/cubit/*_test.dart`,
  `presentation/notification_formats_test.dart`,
  `presentation/screens/notifications_screen_test.dart`,
  `presentation/widgets/unread_dot_test.dart`

Allowed by the brief, outside those folders:

- `lib/features/home/presentation/screens/home_screen.dart` — import +
  `_BellButton` wrapped in `UnreadDot`
- `lib/app.dart` — push listener wiring (reported above)
- `test/features/home/presentation/screens/home_screen_test.dart` — registers
  a mock `UnreadCountCubit` in `sl`
- `integration_test/notifications_acceptance_test.dart` — the mock
  acceptance run below, as a repeatable `flutter drive` scenario

## Tests run

- `make analyze`: No issues found (after every unit).
- `make test`: **463 passed** — baseline on `main` 393, +70 for this ticket
  (U1 +33, U2 +12, U3 +13, U4 +12). Covers: `NotificationsCubit` bloc_tests
  (load, grouping input, mark read, mark all, refresh failure, loadMore
  guard), `UnreadCountCubit` bloc_tests, `routeForNotification` for all six
  types + unknown + missing `event_id`, `openNotificationRoute` go vs push,
  `PushNotificationListener` (deferred until resolved, latest-wins, token
  refresh signed in / signed out, handler throwing), widget tests for list
  loaded / empty / error / skeleton, row tap navigation, `UnreadDot`.
- **Mock acceptance** (`USE_MOCK=true`, persona `nadia@example.com` /
  `password1`), run as `integration_test/notifications_acceptance_test.dart`
  via `flutter drive` on an iPhone 16 Pro simulator (iOS 26.4), **passed**:
  Home bell shows the dot → list shows `3 UNREAD` → tapping the newest
  `You're selected` row opens the event detail (C2 "selected" variant for
  Mahesa Group town hall) → back on the list the count is `2` → `Mark all
  read` → `ALL CAUGHT UP`, link gone → back on Home the dot is gone.
  Screenshots in `docs/reports/task-019/`:
  `B1_home_bell_unread.png`, `N1_list_unread.png`,
  `C2_event_detail_from_notification.png`, `N1_list_read.png`,
  `B1_home_bell_cleared.png`.

  To repeat:

  ```sh
  xcrun simctl uninstall <udid> com.pentacrew.pentaCrew   # reset the saved session
  fvm flutter drive --driver=test_driver/integration_test.dart \
    --target=integration_test/notifications_acceptance_test.dart \
    --dart-define-from-file=env/dev.json -d <udid>
  ```

  Use a simulator with no Apple Account signed in: a system
  "Apple Account Verification" alert over the app makes `takeScreenshot`
  return blank images.

## Deviations from the brief

- State field names follow `SampleListCubit` (`data`, `hasReachedMax`) rather
  than the brief's `items` / `hasMore`; method names are as specified.
- `Mark all read` sits at the right end of the headline row, bottom-aligned
  (the brief says "action link" without a position).
- Relative time under one hour renders `Just now` (copy table only defines
  `{n} h ago` / `Yesterday` / `{d MMM}`).
- The back circle on the list screen is a copy of the private `_Header` in
  `events/`; a shared `core/widgets` back header is a reasonable follow-up.
- No refetch of the unread count after popping the list; the badge relies on
  local sync + the fetch on first show + app resume. A push arriving while
  the app is foregrounded on Home shows the dot only after the next resume
  or list load (brief decision 5).
- `UpdateDeviceToken` is a `registerFactory`; `App` resolves it once at
  startup. Harmless (stateless), noted in case per-call freshness was meant.

## Open questions for the Lead

1. `< 1 h` copy: keep `Just now` or add `{m} min ago`?
2. Error-state eyebrow has no copy; left empty.
3. Should `Mark all read` hide when the list is empty but `unread_count > 0`
   (server/client drift)? Currently shows whenever `unreadCount > 0`.
4. Empty-state icon unspecified; used `Icons.notifications_none_outlined`.
5. Keep `integration_test/notifications_acceptance_test.dart` in the repo as
   the acceptance scenario, or drop it after merge?

## Quirks worth knowing

- `test/features/notifications/app_notification_model_test.dart` and
  `lib/app.dart` are not `dart format`-clean on `main`; a folder-wide format
  reflows them. Both were restored by hand to keep the diff surgical.
- `prefer_initializing_formals` makes private named initializing formals
  (`required this._field`) the effective project style.
- Bare `dart` is not on PATH; use `fvm dart`.
