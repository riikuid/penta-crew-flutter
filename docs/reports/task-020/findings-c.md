# TASK-020 — Visual QA, group C (schedule + profile + notifications)

Run environment: simulator `PentaQA-16Pro` (iPhone 16 Pro, 402×874 logical,
3×), iOS 26.4, Flutter 3.47.6 via fvm, debug build with `env/dev.json`
(`USE_MOCK=true`), branch `wave4/task-020-visual-qa`, 6 Oct 2026. Driver:
`integration_test/visual_qa_group_c_test.dart` via `flutter drive`; default run
= run 3 (every section passed). Persona `nadia@example.com`. Flow order: D1 →
D2 → D1 card → C8 → N1 (bell → list → tap "You're selected" → event detail →
back → Mark all read → back to Home) → E1 (+ sign-out sheet, "Stay signed in")
→ E2 (Full name → "Nadia Putri Lestari", empty-name validation, save) → E3
(wrong current password, then success; last because it changes the mock
password). Empty states (`D3-empty`, `D3-after-browse-events`,
`D2-history-empty`, `N1-empty`) come from `--dart-define=QA_VARIANT=fixtures`
with a temporary approved Surabaya persona `empty@example.com` (no events,
applications or notifications), reverted afterwards. Screenshots are the
Flutter view only (status bar and system keyboard not captured; the keyboard
inset is). Measurements are taken from the 3× PNGs (px ÷ 3); the prototype
spec is the inline CSS in `docs/prototype/screens.html`. Findings already filed
in groups A and B are referenced, not repeated.

Severity key: **BLOCKER** stops a flow · **ISSUE** deviates from the
prototype / copy table / project rules · **SUGGESTION** judgement call.

## D1 — Schedule · upcoming (incl. loading)

- **ISSUE** (minor) · In the loading skeleton the date-rail placeholder is
  vertically centred against the 164-pt card placeholder (`D1-loading.png`),
  while the loaded rail is top-aligned with an 18-pt inset
  (`screens.html:986`, `align-content:start; padding-top:18px`), so the rail
  jumps when data arrives. The skeleton `Row` has no `crossAxisAlignment` ·
  `lib/features/schedule/presentation/screens/schedule_screen.dart:382-399` ·
  add `crossAxisAlignment: CrossAxisAlignment.start` (the leading
  `SizedBox(height: _gap)` already provides the 18-pt offset).
- `as Crew` / `as Event Manager` chips stretch to the full card width — same
  `TagChip` root cause as B Cross-cutting (`schedule_screen.dart:315-320`).
  Header sits about 16 pt low, as in B Cross-cutting (`schedule_screen.dart:123`,
  `padding.top + 16`).
- Verified OK: copy (`Confirmed shifts`, `Schedule` 40, `Upcoming` / `History`
  44-pt tabs with ink selected, `October 2026 · 2 events`, `Next · tomorrow`
  (proposed form), `Confirmed`, `07:00–15:00 · Plataran Menteng`). 52-wide
  rail, 36/500 day, 11/600 weekday, 16 pt to the card. Next card blush, later
  card white with hairline, both r32 p20. Eyebrows 10/600, title 18/500, meta
  13 muted, 16-px arrow. The header scrolls with the list; the nav clears the
  last card. Card → C8 works (`D1-card-to-C8.png`: `You're on the crew.`,
  Wedding of Laras & Bima, `BRIEFING 06:30`); back returns to Schedule.

Screenshots: `D1-default.png`, `D1-scrolled.png`, `D1-loading.png`,
`D1-card-to-C8.png`

## D2 — Schedule · history (incl. empty)

- **SUGGESTION** · Row titles are clamped to one line with an ellipsis
  (`Rumah Dansa studio op…` next to the wider `NOT SELECTED` pill,
  `D2-history.png`); the prototype row has no clamp (`screens.html:1036`) and
  would wrap · `schedule_screen.dart:589-592` (`maxLines: 1`) · allow 2 lines,
  or Lead confirms the clamp.
- Empty state: card inset 24 pt, about 25 pt below the tabs — same
  `_StateCard` placement as B Cross-cutting.
- Verified OK: counter `06` 64/400 with `events worked` ⏎ `since Jul 2026`
  (14 muted), bottom-aligned, 14-pt gap. White r32 card, `4 20` padding,
  hairline dividers. Rows: 15/500 title, meta `WED 30 SEP · CREW` (11/500, no
  "AS"), `Completed` (check, sunken) and `Not selected` (x, outlined, muted)
  pills at 26 pt. The header scrolls away with the list
  (`D2-history-scrolled.png`); all 8 rows clear the nav. Empty copy `No history
  yet.` / `Completed shifts and past applications will appear here.`, no
  counter (`D2-history-empty.png`).

Screenshots: `D2-history.png`, `D2-history-scrolled.png`,
`D2-history-empty.png`

## D3 — Schedule · empty

- **ISSUE** · `Browse events` calls `context.go(EventsRoutes.root)`; that URL
  has no tab, so it opens whichever tab Events last showed. Copy table: D3 →
  Events › Open. It landed on Open here only because Events had not been
  visited in this session (`D3-after-browse-events.png`) ·
  `schedule_screen.dart:241` · use `EventsRoutes.open` (same pattern as B1
  `View list` in group B).
- Empty card inset 24 pt, about 25 pt below the tabs; the prototype uses 20 pt
  and 42 pt (`screens.html:1064`, `margin-top:24px` + 18-pt gap) — same
  `_StateCard` placement as B Cross-cutting.
- Verified OK: copy character-exact including `›` (U+203A): `No confirmed
  events.` 28/500, `Events you're selected for will appear here. Pending
  applications stay in Events › Tracked.` 15 muted. 52-px blush circle with
  calendar-check. `Browse events` 48 pt blush hugging its label, 20 pt below
  the body. Card r40, 32/24 padding.

Screenshots: `D3-empty.png`, `D3-after-browse-events.png`

## E1 — Profile (incl. sign-out sheet)

- **ISSUE** · The sign-out confirmation sheet opens on the shell navigator, so
  the `FloatingPillNav` draws on top of it: the nav is not dimmed by the scrim,
  covers the sheet's bottom edge and stays tappable while the sheet is open
  (`E1-sign-out-sheet.png`: `Stay signed in` sits just above the nav) ·
  `lib/features/profile/presentation/widgets/confirm_sheet.dart:37`
  (`showModalBottomSheet` without `useRootNavigator`) · pass
  `useRootNavigator: true`. A6/A7 and C6 are root-level pages, so this only
  shows on E1.
- **ISSUE** · A fourth info row `Member since` / `24 Jun 2026` is shown; it is
  not in copy table E1 or prototype E1 (`screens.html:1112-1125` has only
  Phone, Date of birth, Home address). The contract mentions `member_since` for
  Profile, but the copy table does not define the row or its format ·
  `lib/features/profile/presentation/screens/profile_screen.dart:70-75` ·
  remove it, or Lead adds it to copy table E1 with its date format.
- **ISSUE** (minor) · `Sign out` is 48 pt tall with 16-px text and a 20-px
  icon; copy table and prototype say 52 pt, 15/500, 18-px log-out icon
  (`screens.html:1138`) · `profile_screen.dart:95-101`
  (`AppButtonSize.medium` = 48; theme `buttonText` / `iconSize: 20`) · height
  52, 15-px text, 18-px icon for this button.
- **SUGGESTION** · `Edit profile` / `Change password` rows show no ripple or
  pressed state: the `InkWell` in `ActionRow` paints on the Scaffold's
  `Material` underneath, which the white `DecoratedBox` of `GroupedCard` hides
  · `lib/features/profile/presentation/widgets/grouped_card.dart:16-21,96` ·
  use a `Material` (surface colour, rounded shape, `clipBehavior`) instead of
  the `DecoratedBox`, as `AppCard` does.
- Role chips `Crew` / `Event Manager` stretch full width — the `TagChip`
  stretch from B Cross-cutting. Header sits about 14 pt low (B Cross-cutting,
  `profile_screen.dart:44`).
- Verified OK: copy (`Crew account`, `Profile` 40, `Verified` ink pill with
  check, `Jakarta branch` sunken 28 pill, `Roles · set by admin`, `Phone` as
  stored, `12 April 1999 · Female`, `Edit profile` / `Change password` with
  chevrons). Avatar 64 blush `NP` 22, name 22/500, email 14 muted. Cards r40
  p24 and r32 `4 20`; info rows 18-pt padding, 20-px icons; action rows ≥ 60 pt.
  Sign-out sheet copy (`Sign out?` / `You'll need your email and password to
  sign back in.` / `Sign out` red / `Stay signed in`) correct; `Stay signed in`
  dismisses it. E1 has no loading state (it reads the cached user), so
  `E1-loading.png` already shows content. After E2 plus a manual back the
  header reads `Nadia Putri Lestari` (`E1-after-edit.png`, see E2).

Screenshots: `E1-default.png`, `E1-scrolled.png`, `E1-loading.png`,
`E1-sign-out-sheet.png`, `E1-after-edit.png`

## E2 — Edit profile (incl. validation, busy, keyboard, save)

- **ISSUE** · `Save changes` shows the `Profile updated` / `Your changes are
  saved.` toast but does **not** return to Profile: the page reloads to a blank
  form with a spinner under the toast (`E2-save-reloads-instead-of-pop.png`,
  `E2-saved-toast.png`), then stays open with the new value
  (`E2-after-save-still-open.png`); the user has to tap back. After back the
  Profile header does show the new name (`E1-after-edit.png`), so the brief's
  flow "edit profile → header updates" only works with a manual back · the
  listener calls `context.pop()` after the toast
  (`lib/features/profile/presentation/screens/edit_profile_screen.dart:251-260`);
  the route builds `BlocProvider(create: (_) => sl<EditProfileCubit>()..load())`
  (`lib/features/profile/profile_routes.dart:32-35`).
  - Likely cause (not proven): saving calls `AuthCubit.updateUser`
    (`edit_profile_cubit.dart:61`); `RouterRefresh` listens to the `AuthCubit`
    stream (`lib/app.dart:32`, `lib/core/router/router_refresh.dart`) and
    refreshes go_router; the route page is rebuilt with a fresh cubit
    (`..load()` → spinner) and the `pop()` issued from the old context is lost.
  - Fix direction: pop before, or independently of, the auth refresh; or stop
    the cubit being recreated on refresh (stable page key, or provide the cubit
    outside the builder); or don't notify the router for profile-only user
    changes (see Cross-cutting).
  - `Change photo` (`edit_profile_cubit.dart:114`) and the A7 `Submit again`
    path (`:61,69`) also call `updateUser`, so they likely hit the same reload
    (neither was exercised in this run).
- **ISSUE** (minor) · Header title `Edit profile` uses `titleMedium` (18/500);
  copy table E2 and the prototype say 17/500 (`screens.html:1152`) ·
  `edit_profile_screen.dart:110` · size 17.
- **ISSUE** (minor) · `Change photo` is about 47 pt tall with 16-px text; the
  prototype has a 44-pt button, 14/500 text, 16-px camera icon
  (`screens.html:1157`) · `edit_profile_screen.dart:129-139`
  (`AppButtonSize.medium` = 48, theme `buttonText`) · 44 height, 14-px text.
- **SUGGESTION** · The Email field is `enabled: false` but looks identical to
  editable fields (white fill, ink text, line border), so a tap seemingly does
  nothing (`E2-default.png`) · `edit_profile_screen.dart:155-159` · muted text
  or sunken fill for read-only, or a small "can't be changed" hint (needs a
  `proposed` copy row).
- Date / Gender / Branch values sit about 4 pt left of the text-field inset
  (picker-vs-text-field inset, A Cross-cutting); stock Material date picker (A
  Cross-cutting); busy CTA is a grey bar with no visible spinner (`E2-busy.png`,
  `AppButton` busy issue from A). In `E2-busy.png` the Full name border is still
  red while the error row is gone — most likely caught mid-transition (about
  120 ms after submit); not filed.
- Verified OK: header back circle 44 + title; avatar 72 blush, 24 pt to the
  fields. Labels `Full name`, `Email`, `Phone`, `Date of birth`
  (`12 / 04 / 1999` with calendar icon), `Gender` and `Branch` side by side
  with chevrons, `Home address` 3-line. Fields 56 pt, r20, 16-px text. No
  re-review note (D-08). Validation: empty name gives a red 1.5 border and
  `Enter your full name.` (`E2-validation.png`). With the keyboard open the CTA
  bar rides above the keyboard, the focused field has an ink border and the
  form scrolls (`E2-keyboard.png`). Bottom bar: hairline top border, 12/20/36
  padding, 56-pt ink `Save changes`, 36 pt from the bottom as in the prototype
  (`screens.html:1175`). Toast copy `Profile updated` / `Your changes are
  saved.`

Screenshots: `E2-default.png`, `E2-scrolled.png`, `E2-keyboard.png`,
`E2-validation.png`, `E2-busy.png`, `E2-saved-toast.png`,
`E2-save-reloads-instead-of-pop.png`, `E2-after-save-still-open.png`

## E3 — Change password (incl. error, busy, keyboard, success)

- **ISSUE** (minor) · `Forgot password?` is a 48-pt ghost `AppButton`, which
  deviates from the prototype (`screens.html:1199`) three ways: text 15/500
  (copy table 14/500); its 12-pt horizontal padding leaves the text about 13 pt
  short of the field's right edge (prototype flush right, `justify-self:end`);
  with 14-pt gaps on both sides, Current password → New password label measures
  about 79 pt vs the prototype's about 53 ·
  `lib/features/profile/presentation/screens/change_password_screen.dart:70-82`
  · zero horizontal padding (flush right), 14/500 text, keep a 44-pt hit height
  and tighten the 14-pt gaps.
- **SUGGESTION** · With the keyboard open on `New password` the rules card is
  pushed below the fold, so the live rule feedback can't be seen while typing
  (`E3-rules-partial.png`; it only shows once the confirm field is focused,
  `E3-keyboard.png`) · `change_password_screen.dart:83-108` · `scrollPadding`
  on the new-password field large enough to bring the rules card into view, or
  move the card directly under `New password`.
- Busy CTA is a grey bar with no visible spinner (`E3-busy.png`, `AppButton`
  busy issue from A). The success toast animates in over the Profile header
  (top-toast placement, B Cross-cutting).
- Verified OK: copy (`Change password.` 36/500, `You'll stay signed in on this
  phone.` 15 muted, labels and placeholders `Enter current password` / `At
  least 8 characters` / `Type it again`, eye toggles, rules `At least 8
  characters` / `Contains a number` / `Both new passwords match`). Rules card
  r24, 18/20 padding, 22-px circles (empty ring → ink check). `Update password`
  stays disabled until all rules pass, then turns ink. Wrong current password:
  red border + `The current password is incorrect.` inline; other fields keep
  their values (`E3-error-wrong-current.png`); typing clears the error
  (`change_password_cubit.dart:17-23`). Success pops to Profile with `Password
  updated` / `You're still signed in on this phone.` (`E3-success-toast.png`).
  Bottom bar matches E2.

Screenshots: `E3-default.png`, `E3-filled.png`, `E3-rules-partial.png`,
`E3-keyboard.png`, `E3-error-wrong-current.png`, `E3-busy.png`,
`E3-success-toast.png`

## N1 — Notifications (no prototype; C2 list pattern per D-06)

- **ISSUE** (minor) · `Mark all read` hit area is the 14-px label plus 8 pt
  vertical padding on a bare `GestureDetector`, about 33 pt tall, under the
  44-pt minimum ·
  `lib/features/notifications/presentation/screens/notifications_screen.dart:270-287`
  · `ConstrainedBox(minHeight: 44)` or a padded `TextButton` (keep 14/500).
- **SUGGESTION** · Rows less than an hour old read `Just now`; copy table N1
  time formats are only `2 h ago` / `Yesterday` / `{d MMM}` ·
  `lib/features/notifications/presentation/notification_formats.dart:26` ·
  Lead adds `Just now` as a `proposed` row.
- **SUGGESTION** · `markAllRead` is optimistic (the eyebrow flips to `All caught
  up` instantly; `N1-mark-all-busy.png` = `N1-all-read.png`), but the server
  result is discarded: on failure the UI and the bell stay "all read" until the
  next refetch, with no toast ·
  `lib/features/notifications/presentation/cubit/notifications_cubit.dart:102-121`
  · on `Failed`, `AppToast.error` and a silent refresh.
- The header block (back, eyebrow, headline) is fixed and cards clip hard under
  it when scrolled (`N1-unread-scrolled.png`) — same fixed-header pattern as
  C1/C2 in group B. The empty card is centred with a 24-pt inset (`N1-empty.png`,
  `_StateCard`, B Cross-cutting). Header about 16 pt low (B Cross-cutting,
  `notifications_screen.dart:240`).
- Not verifiable with the fixtures: the `Today` group header (no mock
  notification is dated 6 Oct, so only `Earlier` renders).
- Verified OK: eyebrow `3 unread` → `All caught up`; `Notifications` 40;
  `Mark all read` 14/500 bottom-aligned with the headline, hidden at 0 unread
  and while loading. `Earlier` eyebrow; white r32 p20 cards with 17/500 title,
  14 muted body (`Mahesa Group town hall · Event Manager`), 13 muted time
  (`Yesterday`, `4 Oct`, `29 Sep`); 8-px ink dot on unread rows only. Loading:
  eyebrow skeleton + three card skeletons, no spinner (`N1-loading.png`).
  Empty copy `No notifications yet.` / `Selection results and new events for
  your roles will show up here.` Tapping `You're selected` opens C8 for Mahesa
  (`Confirmed as Event Manager…`, `BRIEFING 08:00`,
  `N1-tap-to-event-detail.png`) and marks it read; back returns to the list.
  Back on Home the bell's unread dot is gone (`B1-bell-after-read.png`).

Screenshots: `N1-loading.png`, `N1-unread.png`, `N1-unread-scrolled.png`,
`N1-tap-to-event-detail.png`, `N1-mark-all-busy.png`, `N1-all-read.png`,
`N1-empty.png`, `B1-bell-after-read.png`

## Cross-cutting (group C)

- **ISSUE** · Changing the signed-in user refreshes the whole router:
  `RouterRefresh` notifies go_router on every `AuthCubit` emission, including
  profile-only `updateUser` calls. Root-level routes that build their cubit in
  the route builder (`/profile/edit`, and by the same pattern `/notifications`)
  can be rebuilt with a fresh cubit, which lost E2's `pop()` ·
  `lib/app.dart:32`, `lib/core/router/router_refresh.dart` · only refresh the
  router on auth status changes (signed in / out / verification status), e.g.
  a `distinct` on the status before notifying.
- **ISSUE** · Bottom sheets opened from a tab screen (E1 sign-out) open under the
  floating nav; `ConfirmSheet.show` and `OptionSheet.show` should use the root
  navigator (`confirm_sheet.dart:37`; `option_sheet.dart` has the same call
  shape).
- **ISSUE** (minor) · Sizes not mapped to the spec: E1 `Sign out` (48 vs 52 pt,
  16 vs 15 px), E2 `Change photo` (48 vs 44 pt, 16 vs 14 px), E2 header (18 vs
  17 px), E3 `Forgot password?` (15 vs 14 px). `AppButtonSize` has only 56/48
  and the theme's `buttonText` is 16 px; a `small(44)` size and a 15/14-px label
  option would cover all four.
- **ISSUE** (minor) · Touch target under 44: N1 `Mark all read` (about 33 pt).
- **ISSUE** · Tab-less `EventsRoutes.root` links: D3 `Browse events` (same root
  cause as B1 `View list` / `Waiting` in group B).
- **SUGGESTION** · `GroupedCard` rows give no tap feedback; the ripple paints
  under the `DecoratedBox`.
- Same as A / B, seen here too and not re-filed: `TagChip` stretch (D1 position
  chip, E1 role chips); `_StateCard` centring and 24-pt inset (D2/D3/N1
  empties); top offset 14–16 pt on every page; `AppButton` busy looks disabled
  (E2/E3 CTAs); picker vs text-field inset and the unthemed date picker (E2);
  top toast near the header (E3 success).
- Not exercised: `Change photo`, `Submit again` (rejected persona) — both call
  `updateUser` and likely share E2's reload.
- Not flagged (decided): E2 info note removed (D-08); Material icons (D-12);
  light-only theme; sign-out confirmation as a bottom sheet; N1 has no
  prototype and follows the C2 list pattern (D-06); phone shown as stored (copy
  table E1); eyebrows uppercased by the widget from natural-case copy.
