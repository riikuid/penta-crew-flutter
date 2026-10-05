# TASK-019 — Implement Notifications

Kanban: TASK-019 · priority low · blocked by TASK-004, TASK-018 (both Done) · blocks TASK-020.
Plan reference: `docs/implementation-plan.md` §4 T9 (Wave 3).

## Goal

The in-app Notifications screen (no prototype — follow the C2 list pattern), the
unread badge on Home's bell, and routing from a tapped push/notification to the
right screen (D-06).

## Read first

- `AGENTS.md` (naming, member order, import rules, mock backend, definition of done).
- `docs/implementation-plan.md` §2 (all), §2.8, §4 T9; `docs/decisions.md` D-06
  (type → target table, payload keys, device token), D-13, D-14;
  `docs/api-contract.md` §6 and the `Notification` model, §2.10.
- `docs/copy-table.md` → section **N1 Notifications** (all copy is `proposed`)
  and **B1 Home** (bell badge).
- Foundation already in `main`:
  - `lib/features/notifications/` — `notifications_di.dart`, `notifications_routes.dart`
    (`NotificationsRoutes.root = '/notifications'`, root-level route, no pill nav),
    `models/app_notification.dart`, `repositories/notifications_repository.dart`,
    `usecases/` (`GetNotifications`, `GetUnreadCount`, `MarkNotificationRead`,
    `MarkAllNotificationsRead`), `presentation/screens/notifications_screen.dart` (placeholder).
  - `lib/features/auth/usecases/update_device_token.dart`.
  - `lib/core/push/push_service.dart` — `onMessageOpened`, `onTokenRefresh`,
    `PushMessage.data` (values are strings); `noop_push_service.dart`.
  - `lib/integrations/firebase/firebase_push_service.dart` — **do not edit**.
  - `EventsRoutes.detail(id)`, `VerificationRoutes.root`, `AppRoutes.home`,
    `rootNavigatorKey` (`lib/core/router/app_routes.dart:20`).
  - Home's `_BellButton` at `lib/features/home/presentation/screens/home_screen.dart:344`
    (already pushes `NotificationsRoutes.root`).
  - Core widgets from TASK-028: `AppToast.*(title, {description})`, `TagChip`,
    `FieldError`, `Skeleton(color:, borderColor:)`, `EmptyView`, `ErrorView`.
  - Pattern to copy for a paginated list: `SampleListCubit` and the Events
    Tracked tab (`lib/features/events/presentation/`).

## File ownership

- `lib/features/notifications/**`, `test/features/notifications/**`.
- One small edit in `lib/features/home/presentation/screens/home_screen.dart`
  (badge on `_BellButton`).
- Bootstrap wiring in `lib/app.dart` or `lib/main.dart` for the push-tap
  listener if there is no better existing hook — keep it to a few lines and
  report it.
- Nothing else. `core/`, `events/models/`, other features: read-only.

## Steps

1. `NotificationsScreen` + `NotificationsCubit` (paginated, `SampleListCubit`
   pattern): card per item (title, body, relative time), unread marked with an
   ink dot, grouped `Today` / `Earlier` by `created_at`; app bar action
   `Mark all read`; empty state; pull-to-refresh; skeleton.
2. Tap → optimistic mark-read (`MarkNotificationRead`, ignore failure) →
   navigate by `type`: `verification.*` → `VerificationRoutes.root` or Home per
   the D-06 table; `event.published`, `application.*` →
   `EventsRoutes.detail(data.event_id)`; `unknown` → stay. Put the type → route
   mapping in one function `routeForNotification(type, data)` reused by step 4.
3. Unread badge: `UnreadCountCubit` (app-scoped singleton registered in
   `notifications_di.dart`, `fetch()` on Home visible + app resume via
   `WidgetsBindingObserver`, decremented locally on mark-read, zeroed on
   mark-all); render as a small ink dot/count on Home's `_BellButton`.
4. Push routing: on app start subscribe to `PushService.onMessageOpened`
   (covers background tap and cold start via the Firebase implementation) →
   parse `data` (strings → ints) → `routeForNotification` → navigate with
   `rootNavigatorKey`'s router, after the session resolved (if
   `SessionInfo.isResolving`, defer until it is not). Subscribe to
   `onTokenRefresh` → `UpdateDeviceToken(token, platform)`; failures logged via
   Talker only.

## Acceptance criteria

- `bloc_test`s for `NotificationsCubit` (grouping, mark read, mark all) and
  `UnreadCountCubit`; unit tests for `routeForNotification` covering all 6
  types + unknown; widget tests for list loaded / empty.
- `make analyze` clean, `make test` green (baseline on `main`: 393 tests).
- Mock run (`make run-dev`, persona `nadia@example.com` / `password1`): badge
  shows the mock unread count on Home; opening the list and tapping an
  `application.selected` item opens the event detail and the badge decrements;
  `Mark all read` clears it.
- Screenshots of the list (unread + read) and the Home badge saved under
  `docs/reports/task-019/` (the Lead attaches them to the ticket).

## Deliverable

- Branch `wave3/task-019-notifications`, commits per milestone (see AGENTS.md).
- `docs/reports/task-019-report.md`: what changed, files touched, tests run
  (counts), any deviation from this brief, open questions for the Lead.
