# TASK-020 — Visual QA, group B (home + events)

Run environment: simulator `PentaQA-16Pro` (iPhone 16 Pro, 402×874 logical,
3×), iOS 26.4, Flutter 3.47.6 via fvm, debug build with `env/dev.json`
(`USE_MOCK=true`), branch `wave4/task-020-visual-qa`, 6 Oct 2026. Driver:
`integration_test/visual_qa_group_b_test.dart` via `flutter drive`; default run
= run 7 (every section passed; the only failure the framework reported is the
RenderFlex overflow under C1). Fixture states (`B3-empty`, `C7-closed-waiting`,
`C10-*-empty`, `C2-tracked-with-closed-waiting`) come from
`--dart-define=QA_VARIANT=fixtures` with temporary fixture edits (application
304 → `waiting`; an approved Surabaya persona `empty@example.com` with no
events), reverted afterwards. Screenshots are the Flutter view only (status bar
and the system keyboard are not captured; the keyboard inset is). Measurements
are taken from the 3× PNGs (px ÷ 3); the prototype spec is the inline CSS in
`docs/prototype/screens.html`. Findings already filed in group A are
referenced, not repeated.

Severity key: **BLOCKER** stops a flow · **ISSUE** deviates from the
prototype / copy table / project rules · **SUGGESTION** judgement call.

## B1 — Home

- **ISSUE** · Home goes stale after a mutation elsewhere: after the C3–C6 flow
  withdrew Arunika, Home still shows `Waiting 02`; it only changes to `01` after
  a pull-to-refresh (`B1-after-flow.png` vs `B1-after-flow-refreshed.png`).
  `HomeCubit.load` runs once in the route builder and nothing refetches it when
  the tab is shown again · `lib/features/home/home_routes.dart:21-25` · do a
  silent `refresh()` when the Home tab is re-selected or after returning from a
  pushed detail (as `EventsScreen._openDetail` already does,
  `events_screen.dart:234-239`).
- **ISSUE** · The `Waiting` counter calls `context.go(EventsRoutes.root)`; that
  URL has no tab, so it opens whichever tab Events last showed (Open by
  default). The prototype links the counter to C2 Tracked
  (`docs/prototype/screens.html:534`, `href="#C2"`) ·
  `lib/features/home/presentation/screens/home_screen.dart:195` · use
  `EventsRoutes.tracked`. `View list` has the same problem: it should always
  land on Events › Open (copy table B1) but also uses `EventsRoutes.root`
  (`home_screen.dart:302`) · use `EventsRoutes.open`.
- **ISSUE** (minor) · `View list` hit area is about 31 × 60 pt (14-px text +
  8 px vertical padding on a bare `GestureDetector`), under the 44-pt minimum ·
  `home_screen.dart:300-311` · give it 44 height (`TextButton` or
  `ConstrainedBox(minHeight: 44)`).
- **SUGGESTION** · The `Worked` counter opens Schedule › Upcoming; the prototype
  links it to D2 history (`screens.html:539`, `href="#D2"`) ·
  `home_screen.dart:211` · add a `tab` query to `ScheduleRoutes` like Events
  has and pass `history`.
- Logo is the 36-px ink-circle placeholder (`home_screen.dart:329`), same as
  A1/A2. Header sits 14 pt low (see Cross-cutting).
- Verified OK: copy (`Greetings, Nadia!` 17 muted, `Your next shift is
  tomorrow.` 40, `SELECTED`, `AS CREW`, `07` 88 + `OCT`/`WED`, `07:00–15:00 ·
  PLATARAN MENTENG`, `Inspect ↗` 44, `WAITING` / `applications pending`,
  `WORKED` / `since Jul 2026`, `Open for you`, `View list`). Hero blush r40 p24
  with no briefing line (D-14). Counters split 1.25 : 1, 134 pt tall. Carousel
  cards 250 wide, r32, 28-px date pill, 18/500 title, 26-px blush deadline pill
  (`1 DAY LEFT`, `APPLY BY 11 OCT`). Unread dot on the bell. Nav clears the last
  card by 25 pt.

Screenshots: `B1-default.png`, `B1-scrolled.png`, `B1-after-flow.png`,
`B1-after-flow-refreshed.png`

## B2 — Home · loading

- No findings. Skeletons match the copy-table shapes exactly: 44 circle,
  130×16 pill, 300×36 and 190×36 r12, hero 290 r40 blush, two 130-pt white
  counters with a line border; carousel skeletons sit below the fold.
  Pull-to-refresh keeps the data and shows only the Material
  `RefreshIndicator` (`B2-refreshing.png`; styling not flagged, as in A6).

Screenshots: `B2-loading.png`, `B2-refreshing.png`

## B3 — Home · empty

- **ISSUE** · The `WAITING 00` / `WORKED 00 · no events yet` counters render
  between the roles card and the empty block. Prototype B3
  (`screens.html:593-610`) and copy table B3 show only greeting → roles card →
  `Open for you · 00` block · `home_screen.dart:64` (`_buildCounters` runs
  unconditionally) · hide the counters in the B3 state (no next shift and no
  open events), or have the Lead add them to the B3 spec.
- Verified OK: copy character-exact (`You're verified and ready.`, `Roles
  assigned`, `CREW · SURABAYA`, `OPEN FOR YOU · 00` in ink, `No open events
  yet.` 28, body 15 ink on blush). Roles circle 40 ink with check. Empty block
  r40 with 28/24 padding.

Screenshots: `B3-empty.png`

## C1 — Events · open

- **ISSUE** (highest priority in this group) · With the keyboard open, the
  header `Column` overflows ("A RenderFlex overflowed by 35/78 pixels on the
  bottom"; yellow-black stripe across the search field at y ≈ 150 pt) and the
  `Expanded` list gets about 0 height, so search results are invisible while
  typing even though the eyebrow already says `1 OPEN · JAKARTA`
  (`C1-search-keyboard.png`, `C1-search-results-hidden-keyboard.png`). Cause:
  `EventsScreen` has its own `Scaffold` inside the shell's `Scaffold`, so the
  keyboard inset is applied twice (body ≈ 137 pt instead of ≈ 470) ·
  `lib/features/events/presentation/screens/events_screen.dart:105`
  (Scaffold) / `:108` (Column) · `resizeToAvoidBottomInset: false` on the
  inner Scaffold (or the shell), and make the header scroll with the list
  (next finding). Not a BLOCKER: the keyboard's Search key submits and
  dismisses, after which the results show (`C1-search-results.png`).
- **SUGGESTION** · The `FloatingPillNav` rides up above the keyboard and covers
  the area where results would appear (`C1-search-keyboard.png`) · hide the nav
  while `viewInsets.bottom > 0`.
- **ISSUE** · The header (eyebrow, headline, search, tabs) is fixed and only the
  list scrolls; the fixed block takes about 282 pt, leaving about 2 cards
  visible. The prototype scrolls the whole column (`screens.html:628`,
  `overflow:auto` on the page grid; same for C2 `:668`). A drag on the header
  does nothing (`C1-open-scrolled.png` is identical to the default) ·
  `events_screen.dart:108-151` · one `CustomScrollView` per tab with the header
  as a sliver (also removes the overflow above).
- **ISSUE** · Position chips stretch to the full width of the chip column and
  stack (`Crew` and `Event Manager` are each about 258 pt wide); the prototype
  uses content-width 30-px pills wrapping in one row (`screens.html:650-651`).
  Root cause: `TagChip`'s `Container(alignment: Alignment.center)` expands to
  the max width under loose constraints · `lib/core/widgets/tag_chip.dart:55-58`
  · drop `alignment` and centre with `Row(mainAxisSize: MainAxisSize.min)`, or
  `widthFactor: 1`. The same bug hits C3 requirement chips and the E1 role chip
  (see Cross-cutting).
- **ISSUE** (minor) · The search clear `×` is a bare 18×18 `GestureDetector`, so
  its hit area is 18 pt · `events_screen.dart:292-297` · 44-pt `IconButton` or
  pad the detector.
- **SUGGESTION** · Every search keystroke (after the debounce) runs a full
  `fetch` that emits `loading`: the eyebrow turns into a skeleton, the `Open`
  count disappears and the list flashes skeletons (`C1-search-keyboard.png`) ·
  `lib/features/events/presentation/cubit/open_events_cubit.dart:31,82` · keep
  the previous eyebrow and count while a search is in flight.
- **SUGGESTION** · Open cards (C1 and the B1 carousel) give no hint that you
  already applied: Arunika is listed with `1 DAY LEFT` while it is `Waiting` in
  Tracked. The contract allows it, but a small `Applied` pill would save a tap.
- Verified OK: copy (`3 OPEN · JAKARTA`, `Events` 40, `Search events or
  venues`, `Open 03` / `Tracked 12` with 11-px counts). Search 52 pill, 18-px
  muted icon. Tabs 44 pills, selected in ink. Cards r40 p24: `FRI 09 OCT` ink
  eyebrow, urgent blush pill with clock / calm outlined pill, title 22/500, meta
  14 muted, hairline divider, 44 ink arrow. Loading shows white r40 card
  skeletons with a skeleton eyebrow. Clearing the search restores all three
  (`C1-search-cleared.png`).

Screenshots: `C1-loading.png`, `C1-open-default.png`, `C1-open-scrolled.png`,
`C1-search-keyboard.png`, `C1-search-results-hidden-keyboard.png`,
`C1-search-results.png`, `C1-search-cleared.png`

## C2 — Events · tracked

- **SUGGESTION** · A waiting application whose deadline has passed (Mahesa
  fixture) shows `CLOSES 4 OCT` with 1/3 filled on the card, while its C7
  detail shows `CLOSED 4 OCT` with 2/3 filled
  (`C2-tracked-with-closed-waiting.png` vs `C7-closed-waiting.png`). Copy table
  C2 only defines waiting = 1, so this follows the spec, but the two screens
  disagree about the same application ·
  `lib/features/events/presentation/widgets/tracked_card.dart`,
  `event_formats.dart:17` · Lead to extend the C2 row with the C7 rule (past
  tense, 2 filled).
- Once scrolled, cards clip hard under the tab bar (`C2-tracked-scrolled.png`),
  a consequence of the fixed header (C1).
- Verified OK: copy (`12 APPLICATIONS`, intro 15 muted, `FRI 09 OCT · AS CREW`,
  `WAITING` / `SELECTED` / `NOT SELECTED` 26-px pills with icons, `APPLIED ·
  CLOSES 7 OCT · RESULT` 10/600). Cards r32 p20, 17/500 title, 4-px bars,
  waiting = 1 / decided = 3. No search on this tab. After apply the list shows
  `AS EVENT MANAGER` (`C2-tracked-after-apply.png`); after withdraw the eyebrow
  reads `11 APPLICATIONS` and Arunika is gone (`C2-tracked-after-withdraw.png`).

Screenshots: `C2-tracked.png`, `C2-tracked-scrolled.png`,
`C2-tracked-with-closed-waiting.png`, `C2-tracked-after-apply.png`,
`C2-tracked-after-withdraw.png`

## C3 — Event detail · open (incl. loading, error, date_conflict)

- **ISSUE** · Requirement chips stretch full width and stack (`Usher`,
  `Registration desk`, `Any gender` each 362 pt wide); the prototype uses inline
  32-px white outlined pills (`screens.html:742-746`). Same `TagChip` root cause
  as C1 · `tag_chip.dart:55-58`.
- **ISSUE** (minor) · On the loading skeleton both headline lines render at the
  full 362-pt width instead of 300 / 190, because `ListView` stretches its
  children (`C3-loading.png`) ·
  `lib/features/events/presentation/screens/event_detail_screen.dart:163,165`
  · wrap them in `Align(alignment: Alignment.centerLeft)`.
- **ISSUE** (minor) · The error card shrink-wraps to its text: `Event not
  found.` gives a 166-pt-wide card centred mid-screen
  (`C3-error-not-found.png`), while the same `_StateCard` is full width on C10
  · `lib/core/widgets/state_views.dart:97-103` (`Center` + intrinsic width) ·
  `width: double.infinity` on the card (placement: see C10).
- **SUGGESTION** · On a 404 the server `message` (`Event not found.`) is shown
  as-is (correct), but `Try again` only reloads the skeleton into the same 404
  (`C3-error-retrying.png` → same card) · `event_detail_screen.dart:52-56` · on
  `code == not_found` drop the retry or swap it for `Back to events`. Back from
  the error works and returns to the caller.
- **SUGGESTION** · Action bar: 16 + 34 (home indicator) = 50 pt below the
  footnote vs the prototype's 34 (`screens.html:750`, `padding:12px 20px 34px`)
  · `event_detail_screen.dart:498` · `SafeArea(minimum: bottom 34)` without the
  extra 16. Same pattern as group A's A2/A4 bottom spacing.
- Verified OK: header (44 back circle, 20-px arrow, `JAKARTA BRANCH`), headline
  36. Hero r40 blush, 80-px `09`, `OCT 2026` / `FRIDAY`, soft divider,
  `14:00–20:00 · 6 hours`, venue + address rows. Deadline card r24, 40-px ink
  hourglass, `Apply by Wed, 7 Oct · 23:59`, `1 DAY LEFT`. `Positions` 20/500;
  rows `Matches your role` / `10 NEEDED`; Trainee muted with lock 14 and `Not
  one of your roles`. Description 15 muted. CTA `Apply` 56 ink; footnote `Can't
  make it? You don't need to do anything.` 13 muted. `date_conflict`: disabled
  Apply + `You're already booked on this date.` (Kirana,
  `C3-date-conflict*.png`). Single-position event renders correctly
  (`C3-open-single-position.png`).

Screenshots: `C3-loading.png`, `C3-open-default.png`, `C3-open-scrolled.png`,
`C3-open-single-position.png`, `C3-date-conflict.png`,
`C3-date-conflict-scrolled.png`, `C3-error-not-found.png`,
`C3-error-retrying.png`, `C3-apply-busy.png`

## C4 — Apply · choose position (sheet)

- **SUGGESTION** · No busy state is visible on the sheet: `Send application`
  pops the sheet first (`apply_sheet.dart:92`) and the request runs afterwards
  behind the page's action bar; `C3-apply-busy.png` (120 ms) only catches the
  sheet closing with a ripple. The bar's busy look could not be verified (same
  `AppButton` busy issue as A2).
- Space under `Send application` is about 50 pt vs the prototype's 36
  (`screens.html:769`), same bottom-spacing pattern as C3 and A4.
- Verified OK: handle 40×4, sheet r40 top, ink scrim, eyebrow `FRI 09 OCT ·
  14:00–20:00`, `Apply as` 28. Selected option blush with 2-px ink border and a
  28-px ink check; unselected 1-px line with an empty ring. The locked Trainee
  row (lock, muted) is listed but not selectable (D-09); tapping it keeps Event
  Manager selected. Note `You can withdraw until Wed, 7 Oct · 23:59.`, CTA 56.
  Single variant: `Apply as Crew` with no options (`C4-apply-sheet-single.png`).

Screenshots: `C4-apply-sheet.png`, `C4-apply-sheet-event-manager.png`,
`C4-apply-sheet-single.png`

## C5 — Event detail · applied

- **SUGGESTION** · After applying (and after withdrawing, C6) the top toast sits
  over the back button and the branch eyebrow for about 3 s; a tap there hits
  the toast (which dismisses on tap) instead of going back. The driver saw this
  as a hit-test miss on the back icon. Both toast screenshots, about 400 ms
  after the toast appeared, show it still half-transparent over the header
  (`C5-applied-toast.png`, `C6-withdrawn-toast.png`) ·
  `lib/core/widgets/app_toast.dart:34-42` (`toastification.showCustom`, top
  centre, 3 s) · on root-level pages position the toast below the 44-px header,
  or let taps outside the card pass through.
- Verified OK: pill `WAITING FOR SELECTION` (white on blush, clock 14),
  `Applied as Crew` 20/500, bar 1/3 with `29 SEP 09:00 · CLOSES 7 OCT ·
  RESULT`, body `You'll get a notification when the admin picks the crew.` 14
  ink, rows `Friday, 9 October 2026` / `14:00–20:00 · 6 hours` + venue with a
  4-px inset, `Withdraw application` 56 ink outline. Toast `Application sent` /
  `Applied as Event Manager for Arunika annual gathering.` at top 61 pt
  (prototype 60). Opening from the Home carousel gives the same page
  (`C5-applied-from-home.png`).

Screenshots: `C5-applied.png`, `C5-applied-from-home.png`,
`C5-applied-toast.png`, `C5-applied-event-manager.png`, `C5-withdraw-busy.png`

## C6 — Withdraw · confirm (sheet)

- No findings beyond C5's toast and the shared `AppButton` busy issue
  (`C5-withdraw-busy.png` at 120 ms shows the sheet still up; the busy bar
  could not be captured).
- Verified OK: handle, `Withdraw application?` 28, `You can apply again until
  Wed, 7 Oct · 23:59.` 15 muted, `Withdraw` 56 ink, `Keep application` 48
  ghost. Keep returns to C5 unchanged. Withdraw returns to C3 with toast
  `Application withdrawn` / `You can apply again until Wed, 7 Oct · 23:59.`
  The Event Manager variant gives the same sheet.

Screenshots: `C6-withdraw-sheet.png`, `C6-withdraw-sheet-event-manager.png`,
`C6-withdrawn-toast.png`

## C7 — Event detail · closed, waiting

- No findings. White r40 card, blush `WAITING FOR SELECTION` pill, `Applied as
  Event Manager`, bar 2/3 with `27 SEP 09:00 · CLOSED 4 OCT · RESULT`, lock
  note r20 (lock 16, 14 muted, `Applications closed. This can't be changed
  now.`), date and venue rows, no action bar.

Screenshots: `C7-closed-waiting.png`

## C8 — Event detail · selected

- No findings. Blush r40 hero, 28/24 padding: `SELECTED` ink pill, `You're on
  the crew.` 36, `Confirmed as Crew for Wedding of Laras & Bima. It's now in
  your schedule.` 15. White r32 rows card: `Wednesday, 7 October 2026` /
  `07:00–15:00 · BRIEFING 06:30` 11/500. `NOTES FROM ADMIN` + note 15. Mahesa
  (closed event, `assigned_position` Event Manager): `Confirmed as Event
  Manager…` / `BRIEFING 08:00`. Reached from B1 `Inspect` (C3 skeleton first)
  and from Tracked.

Screenshots: `C8-selected.png`, `C8-selected-mahesa.png`

## C9 — Event detail · not selected

- No findings. White r40 card, outlined `NOT SELECTED` pill (x 14), `All
  positions for this event have been filled. Thanks for applying as Crew.` 16
  ink. Rows `Wednesday, 30 September 2026` / `10:00–16:00` (no duration).
  `Browse open events` 56 blush → Events › Open
  (`C9-after-browse-open-events.png`).

Screenshots: `C9-not-selected.png`, `C9-after-browse-open-events.png`

## C10 — Events · empty

- **ISSUE** · The empty card is vertically centred in the list area (top about
  170 pt below the tabs) with a 24-pt side inset; the prototype places it 24
  below the tabs with the 20-pt page inset (`screens.html:952`,
  `margin-top:24px`) · `state_views.dart:97-99` (`Center` +
  `AppSize.pagePadding` = 24) · top-align list empties with a 20-pt inset
  (also fixes the narrow C3 error card).
- **SUGGESTION** · A search with no matches (`zzz`) reuses `No open events right
  now.` / `New events for your roles will show up here…`, which is misleading
  for a search (`C10-search-no-results.png`) · `events_screen.dart:334-336` ·
  add a `proposed` copy row, e.g. `No events match "zzz".` with a `Clear
  search` action.
- **SUGGESTION** · Prototype C10 has no search field (`screens.html:943-951`)
  but the app keeps it at 0 open events · hide it when `total == 0` and the
  query is empty, or Lead confirms the field stays.
- Verified OK: `0 OPEN · SURABAYA`, no counts on empty tabs, 52-px blush compass
  circle, `No open events right now.` 28, body 15 muted, no action. Tracked
  empty: `0 APPLICATIONS`, `You haven't applied to any events.`, `Applications
  you send will appear here with their status.`, `Browse open events` → Open
  tab (`C10-tracked-empty-after-browse.png`).

Screenshots: `C10-open-empty.png`, `C10-tracked-empty.png`,
`C10-tracked-empty-after-browse.png`, `C10-search-no-results.png`

## Cross-cutting (group B)

- **ISSUE** · Sign-out from Profile followed by sign-in (even as a different
  user) lands on Profile, not Home: the guard sends the user to login with
  `from=/profile`, and `LoginScreen` does `context.go(widget.from ??
  AppRoutes.home)` · `lib/features/auth/presentation/screens/login_screen.dart:131`
  · evidence `A2-sign-in-lands-on-profile.png` (Dewi Lestari's Profile right
  after sign-in) · navigate to login without `from` on sign-out, or clear
  `from` when the session ends.
- **ISSUE** · `TagChip` stretches to the full available width inside `Wrap`
  (C1 position chips, C3 requirements, the E1 `Crew` role chip in
  `A2-sign-in-lands-on-profile.png`) · `lib/core/widgets/tag_chip.dart:55-58`.
- **ISSUE** (minor) · Top offset: every tab and detail page adds padding on top
  of the 62-pt safe area. Home header starts at 74 pt (prototype 60,
  `screens.html:506`); Events/detail headers at 78 pt (prototype 62, `:628`,
  `:712`) · `home_screen.dart:56` (`top: 12`), `events_screen.dart:112` and
  `event_detail_screen.dart:119` (`16`) · drop the extra 12/16 so content
  starts at about 60–62 pt (or Lead decides the prototype's 60/62 means "below
  the safe area").
- **ISSUE** · Home does not refetch after apply/withdraw elsewhere (B1).
- **ISSUE** · `_StateCard` (EmptyView/ErrorView) is centred, shrink-wrapped and
  uses the 24-pt `pagePadding` (C3 error, C10) ·
  `lib/core/widgets/state_views.dart:97-103`; the token itself is group A's
  `AppSize.pagePadding` finding.
- **ISSUE** (minor) · Touch targets under 44: search clear `×` 18 pt (C1),
  `View list` about 31 pt tall (B1).
- **SUGGESTION** · The top toast covers the back button on root-level pages
  (C5/C6).
- **SUGGESTION** · Bottom action bars and sheets sit about 14–16 pt higher than
  the prototype (C3/C5/C9 bar, C4/C6 sheets), same as group A's A2/A4 spacing.
- Same as group A: logo placeholder (B1/B2/B3 36-px ink circle) and
  `AppButton` busy looks disabled (C3 apply / C5 withdraw; not captured here
  because the sheet pops before the request starts).
- Not flagged (decided or deliberate): no briefing line on the Home hero
  (D-14); `Waiting` counter instead of `Tracked` (D-04); Material icons (D-12);
  light-only theme; locked non-matching rows inside the C4 sheet (D-09);
  Material `RefreshIndicator` on B2. `FloatingPillNav` sits 42 pt from the
  bottom instead of 30 by design (`max(30, inset + 8)`,
  `lib/core/router/app_shell.dart:66`). Eyebrows are uppercased by the widget
  from natural-case copy.
