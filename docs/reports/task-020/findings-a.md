# TASK-020 — Visual QA, group A (auth + verification)

Run environment: simulator `PentaQA-16Pro` (iPhone 16 Pro, 402×874 logical,
3×), iOS 26.4 (23E244), Flutter 3.47.6 via fvm, debug build with
`env/dev.json` (`USE_MOCK=true`), commit `ead61e8` (`main`) on branch
`wave4/task-020-visual-qa`, 5 Oct 2026. Driver:
`integration_test/visual_qa_group_a_test.dart` via `flutter drive`; the app
was uninstalled and the simulator keychain reset before every run. Screenshots
are the Flutter view only (status bar and the system keyboard are not
captured; the keyboard inset is). All PNGs in this folder are from the run in
which every section passed (run 4), plus `A6-refreshing-late.png` from run 5.

Severity key: **BLOCKER** stops a flow · **ISSUE** deviates from the
prototype / copy table / project rules · **SUGGESTION** judgement call.

## foundation_smoke_test

**FAIL** (2 of 2 runs, same spot). `integration_test/foundation_smoke_test.dart:61`
— after the second `signIn('nadia@example.com', 'password1')` the test expects
`FloatingPillNav` and finds none; it stops with only `A2_sign_in.png` and
`A3_sign_in_error.png` written. Not an app bug as far as I can tell: the same
symptom hit my driver and was traced to `tester.enterText` being silently
dropped when it runs right after `FocusScope.unfocus()` (the app's `_submit`
unfocuses; the test then types the password without re-focusing the field, so
the text-input client is not attached yet on this simulator). Tapping the field
and pumping ~350 ms before `enterText` fixed it in my driver. The smoke test's
`signOut` helper would also not find A6/A7's "Sign out" (it looks for an
`OutlinedButton`; A6/A7 render the ghost `TextButton`) — could not verify
because the run stops earlier. Suggested fix: in `foundation_smoke_test.dart`,
tap + settle before `enterText`, and look for `TextButton` on A6/A7.

## A1 — Splash

- **ISSUE** · No logo: the 168-px Pentamoo image is replaced by the text
  `Env.appName`, which in the dev flavour renders as "Penta Crew Dev" (the
  flavour suffix leaks into the UI) · `lib/features/auth/presentation/screens/splash_screen.dart:70`
  · add the logo asset (needs the file from design) and render it 168 wide;
  until then use a fixed brand string, not `Env.appName`.
- Eyebrow `Freelance event crew` 11/600 0.08em uppercase, 28 gap: matches.

Screenshots: `A1-default.png`

## A2 — Sign in (incl. A3 error)

- **ISSUE** · The 40-px logo above the intro (prototype A2/A3/A6/A7) is
  missing; the headline block sits ~26 px higher than the prototype as a result
  · `lib/features/auth/presentation/widgets/auth_page.dart:45-46` reserves 56 px
  where the prototype has logo 40 + 56 · same asset as A1.
- **ISSUE** · Busy state: `AppButton(loading: true)` sets `onPressed: null`,
  so the primary CTA renders in the *disabled* look (line-grey fill, muted
  2-px spinner) while submitting — the ink button visibly greys out and the
  spinner is nearly invisible on line grey (`A2-busy.png`, `A5-busy.png`) ·
  `lib/core/widgets/app_button.dart:66` · keep the enabled colours while
  loading (resolve background/foreground on a `loading` flag or wrap in
  `IgnorePointer` with a non-null `onPressed`) and draw the spinner in the
  label colour.
- **ISSUE** · Validator errors from a failed submit stay while the user types
  a correction (`A2-keyboard.png`: "Enter a valid email address." under a valid
  email); only the `invalid_credentials` error clears on change, so the two
  error kinds behave differently · `lib/features/auth/presentation/screens/login_screen.dart:77`
  (`Form` without `autovalidateMode`) · `AutovalidateMode.onUserInteraction`
  after the first submit, or clear per field like A4's `clearError`.
- **ISSUE** (minor) · Field error row is indented ~20 px (starts under the
  input text); prototype A3 puts the 16-px alert icon flush with the field's
  left edge (`docs/prototype/screens.html:361`) · core:
  `InputDecorationTheme.contentPadding` offsets `errorBuilder` output and
  `AppPickerField` copies the same offset (`lib/core/widgets/labeled_field.dart:270`)
  · pick one; if flush, render the error outside `InputDecoration` (as
  `AppPickerField` already does, without the `left: 20`).
- **SUGGESTION** · On `invalid_credentials` the password is cleared; prototype
  A3 keeps the masked value and only turns the border/error red ("Email is
  kept") · `login_screen.dart:134` · keep the typed password so a retry is one
  tap, or document the clearing as deliberate.
- **SUGGESTION** · Space under "Create account" is ~58 px (24 + home
  indicator 34) vs prototype 40 total · `auth_page.dart:37` ·
  `SafeArea(minimum: bottom 40)` with no extra padding, as
  `VerificationScreen` does (A6 measures ~49).
- Verified OK: copy (eyebrow, headline 44, body 16 muted, labels,
  placeholders, link, both CTAs, all three validation strings, A3 error
  string), eye toggle 20 px, 10 px between CTAs, 16 px between fields,
  email kept after A3, inputs + "Create account" disabled while busy, keyboard
  (page scrolls, CTAs stay above the inset, dismiss on drag). "Forgot
  password?" draws 33 px tall but `MaterialTapTargetSize.padded` extends the
  hit area to 48 — fine.

Screenshots: `A2-default.png`, `A2-validation-empty.png`,
`A2-validation-bad-email.png`, `A2-keyboard.png`, `A2-filled.png`,
`A2-password-visible.png`, `A2-busy.png`, `A2-error-invalid-credentials.png`,
`A2-after-sign-out.png`

## A2b — Forgot password (no prototype)

- **ISSUE** (minor) · Empty email yields `Enter a valid email address.`; A2
  distinguishes empty (`Enter your email.`) · `lib/features/auth/presentation/screens/forgot_password_screen.dart:80`
  · share one email validator (move `LoginScreen._validateEmail` to
  `FormValidators`).
- **SUGGESTION** · Two back affordances do the same thing when opened from A2:
  the circle back button and the ghost "Back to sign in" · `forgot_password_screen.dart:47,54`
  · the copy table lists only the ghost; keep one (the circle is needed for the
  deep-link case on A2d, not here).
- Verified OK: copy table A2b character-exact, email prefilled from A2, busy
  state (same grey-out as A2), layout consistent with A2.

Screenshots: `A2b-default.png`, `A2b-validation.png`, `A2b-filled.png`,
`A2b-busy.png`

## A2c — Check your email (no prototype)

- No findings. Copy character-exact (incl. the email interpolated), primary
  "Back to sign in", ghost `Resend in 60s` counting from 60 immediately (D-02).
  Could not verify: `Resend` ready state and the `Link sent again` toast (60 s
  cooldown not waited out).

Screenshots: `A2c-default.png`

## A2d — Reset password (no prototype)

- **ISSUE** · With the keyboard open (the first field autofocuses) the rules
  card and the "Update password" CTA sit under the keyboard; the live rules
  cannot be seen while typing (`A2d-rules-partial.png`) · `lib/features/auth/presentation/screens/reset_password_screen.dart:93-121`
  with `auth_page.dart` · keep the rules visible: move the rules card above the
  fields, or give the fields a `scrollPadding` tall enough to scroll the card
  into view, or drop `autofocus`. E3 shares the pattern (group E to confirm).
- **SUGGESTION** · After success Sign in opens with an empty email although
  A2d knows it (`widget.email`) · `reset_password_screen.dart:136` · pass it as
  `extra` (LoginScreen would need an `initialEmail`).
- Verified OK: copy (headline, body, labels, hints, three rules, CTA, toast
  title + description, expired headline/body/CTA), CTA disabled until all
  rules pass, rules card 22-px circles, back circle falls back to Sign in when
  nothing is beneath, `token=mock-qa` succeeds, no token → expired view.
  Could not verify: `token_expired` / `token_invalid` after submit (code path
  only).

Screenshots: `A2d-default.png`, `A2d-rules-partial.png`, `A2d-filled.png`,
`A2d-busy.png`, `A2d-success-toast.png`, `A2d-expired.png`

## A4 — Create account (step 1)

- **SUGGESTION** · Space under "Continue" is 12 + 34 = 46 vs prototype 36 ·
  `lib/features/auth/presentation/screens/register_screen.dart:406-410` ·
  `SafeArea(minimum: bottom 36)` without the inner 12.
- **SUGGESTION** · `_ContinueButton` bypasses `AppButton` (duplicated sizing,
  no busy state) because `AppButton` has no trailing icon ·
  `register_screen.dart:420` · add a `trailingIcon` to `AppButton`.
- Verified OK: header (44 circle, 4-px pills gap 6, `01 / 02` not
  uppercased), headline 36 / body 15, 28 to the fields, 14 between fields,
  copy and placeholders (Confirm password has none), all five validation
  strings, errors clear per field on typing, keyboard (list scrolls, bottom
  bar stays above the inset), the 422 round-trip: existing email on step 2
  → back on step 1 with `The email has already been taken.` under Email and
  every value kept (`A4-error-email-taken.png`).

Screenshots: `A4-default.png`, `A4-validation.png`, `A4-keyboard.png`,
`A4-validation-mismatch.png`, `A4-filled.png`, `A4-error-email-taken.png`

## A5 — Complete profile (step 2)

- **ISSUE** · Date of birth opens the stock Material date dialog: background
  is `surfaceContainerHigh` = line grey `#E4E4E3`, M3 header "Select date /
  Mon, Oct 5", muted weekday row — off palette and off type
  (`A5-date-picker.png`) · `register_screen.dart:325` + `lib/core/theme/app_theme.dart`
  (no `datePickerTheme`) · add a `DatePickerThemeData` (white surface, radius
  32, ink selection, Inter) or a custom picker sheet; E2 uses the same picker.
- **ISSUE** · The picker opens on the month grid 17 years back
  (`initialDate = today − 17 y`); a 1990s birthday means paging years of months
  or discovering the year dropdown · `register_screen.dart:327` · open with
  `initialDatePickerMode: DatePickerMode.year` or
  `initialEntryMode: DatePickerEntryMode.input`.
- **SUGGESTION** · `RegisterScreen.minimumAge = 17` is a business rule found
  nowhere in `decisions.md` / `api-contract.md` · `register_screen.dart:26` ·
  confirm with the Lead and record it (or drop the upper bound).
- **SUGGESTION** · Text in `AppPickerField` starts ~4 px left of the text in
  `AppTextField` (`05 / 10 / 2009` vs `Jl. Kemang…` in `A5-filled.png`) ·
  `lib/core/widgets/labeled_field.dart:247` · match `InputDecoration`'s
  effective inset.
- **SUGGESTION** · Gender/Branch sheets have no drag handle and a 20-px title,
  while `ConfirmSheet` has a handle and a 28-px title · `register_screen.dart:550`
  (`_SheetFrame`) · one shared sheet frame in `core/widgets`.
- **SUGGESTION** · Back button stays active while "Submit for review" is busy
  · `register_screen.dart:74` · disable `onBack` while `state.isSubmitting`.
- Verified OK: copy (headline, body, labels, `DD / MM / YYYY`, `Select`,
  Female/Male, `Street, district, city`, info note), Gender + Branch share a
  row, textarea 3 rows, blush note r24 p18/20 with 18-px icon and 14-px text,
  all four validation strings, branch sheet shows skeleton rows then the list
  (no spinner), picked values survive the 422 → step 1 → step 2 round-trip
  (`A5-filled-after-back.png`), register → `/verification` pending
  (`A6-after-register.png`).

Screenshots: `A5-default.png`, `A5-validation.png`, `A5-date-picker.png`,
`A5-gender-sheet.png`, `A5-branch-sheet-loading.png`, `A5-branch-sheet.png`,
`A5-keyboard.png`, `A5-filled.png`, `A5-busy.png`, `A5-filled-after-back.png`,
`A6-after-register.png`

## A6 — Verification · pending

- **ISSUE** · 40-px logo (+32 gap) above the pill missing; content starts
  right under the status bar · `lib/features/verification/presentation/screens/verification_screen.dart:46-50`
  · same asset.
- **ISSUE** · Pull-to-refresh calls `AuthCubit.checkSession()`, which emits
  `AuthUnknown` first; `_resolveSessionFirst` then redirects `/verification`
  to `/splash?from=/verification` until `GET /me` answers, so by code the page
  leaves to the splash and comes back on every refresh · `verification_screen.dart:85`
  + `lib/features/auth/presentation/cubit/auth_cubit.dart:58` +
  `lib/core/router/app_router.dart:49` · add an `AuthCubit.refreshUser()` that
  re-fetches `/me` without leaving `Authenticated` (emit `authenticated(user)`
  on success; 401 → session expired as today). Could not capture the splash
  frame (`A6-refreshing.png` at 150 ms shows the indicator, `A6-refreshing-late.png`
  at 600 ms is already back) — verify by eye with `make run-dev`.
- **SUGGESTION** (mock only) · `submitted_at` renders `28 SEP 2026 · 02:00`:
  the fixture is a day offset with a midnight-UTC time, prototype shows
  `09:40` · `lib/core/network/mock/fixtures/mock_data.dart:57` · give fixture
  timestamps a time of day.
- Verified OK: pill (blush, clock 14, uppercase), headline 40, body 15 muted
  with the branch interpolated, timeline card r40 p24 with 28-px markers,
  labels 15/500, sublabels 11/500 muted (`JAKARTA BRANCH · IN PROGRESS`,
  `NEXT`), "View my data" 56 blush, "Sign out" 48 ghost 15 px, gap 6, bottom
  40, sign-out sheet (`Sign out?` / body / danger `Sign out` / `Stay signed in`)
  → A2. Material `RefreshIndicator` styling noted, not flagged.

Screenshots: `A6-pending.png`, `A6-refreshing.png`, `A6-refreshing-late.png`,
`A6-sign-out-sheet.png`, `A2-after-sign-out.png`

## A6a — View my data (no prototype)

- **ISSUE** · Row order is Full name, Email, **Branch**, Phone, Date of birth,
  Home address; copy table A6a says Full name, Email, Phone, Date of birth,
  Branch, Home address · `lib/features/verification/presentation/screens/verification_data_screen.dart:45-74`
  · reorder.
- **SUGGESTION** · Two `CircleBackButton` widgets exist
  (`features/auth/presentation/widgets/` and `features/profile/presentation/widgets/`);
  this screen imports profile's · move one to `core/widgets` and delete the
  other.
- Verified OK: eyebrow, headline, body copy; E1-style rows (icon, eyebrow,
  value) on a hairline card; back circle returns to A6.

Screenshots: `A6a-view-my-data.png`

## A7 — Verification · not approved

- **ISSUE** · 40-px logo missing (as A6) · `verification_screen.dart:46-50`.
- **ISSUE** (minor) · Note body is 18 px (`titleMedium`), prototype 17 px /
  1.45 · `verification_screen.dart:198` · `fontSize: 17` or a dedicated token.
- **SUGGESTION** · A null `verification_note` renders an empty `""` on the
  blush card · `verification_screen.dart:197` · hide the card when null.
- Verified OK: pill (error outline + x 14), headline, body, `Note from admin`
  ink eyebrow, straight double quotes, meta `JAKARTA BRANCH · 29 SEP 2026`
  11/500 muted, card r40 p24 blush, "Edit profile" 56 ink → E2 with
  `Submit again` CTA (`A7-edit-profile.png`), "Sign out" 48 ghost → sheet →
  A2.

Screenshots: `A7-rejected.png`, `A7-edit-profile.png`, `A7-sign-out-sheet.png`

## Cross-cutting (group A)

- **ISSUE** · Logo asset absent on A1, A2, A6, A7 (prototype shows it on all
  four); one asset + one `BrandMark` widget fixes all.
- **ISSUE** · `AppButton` busy state looks disabled (see A2) — affects every
  mutation CTA in the app.
- **ISSUE** · Validator errors don't clear on typing (A2, A2b) while the
  register cubit clears per field — inconsistent across the auth forms.
- **ISSUE** (dev only) · Mock sessions do not survive a cold start:
  `MockServer._tokens` is in-memory while the keychain keeps the token across
  reinstalls, so every cold start after a sign-in shows "Your session has
  expired. Please sign in again." on A2 (seen in an earlier run; the brief's
  "uninstall before each run" does not clear it — `xcrun simctl keychain <udid> reset`
  does) · `lib/core/network/mock/mock_server.dart:755` · let `_userForToken`
  parse `mock-token-<id>-…` so persisted sessions resume at Home as the brief
  expects.
- **ISSUE** (minor) · Field error row indented 20 px vs prototype flush;
  picker vs text-field text inset differs by ~4 px (core widgets).
- **ISSUE** · Stock Material date picker (A5, and E2) is unthemed.
- **SUGGESTION** · `AppSize.pagePadding = 24` while every A screen (and the
  prototype) uses 20 · `lib/core/theme/app_tokens.dart` · fix the token or
  its doc.
- **SUGGESTION** · §4.1 naming: `lib/core/widgets/progress_timeline.dart:54,169,188`
  use `i` as the loop variable.
- **SUGGESTION** · Two `CircleBackButton` implementations (auth vs profile).
- **SUGGESTION** · Fonts: Inter rendered correctly (google_fonts fetched and
  cached while the simulator was online). Offline-first-launch fallback was
  not exercised; plan §5 leaves TTF bundling to this QA — recommend bundling
  before a release build.
- Quirk (could not reproduce) · Once (run 3) A2 went blank right after
  tapping Email following a sign-out from A6 (page showed only the scaffold
  background); not seen in runs 4–5 with the same steps. Logged here, not
  filed.
- Harness notes: `tester.enterText` straight after `FocusScope.unfocus()` is
  dropped on this simulator (tap + ~350 ms first); Flutter screenshots don't
  include the system keyboard or the status bar, so status-bar icon colour
  could not be verified; the DEBUG banner is on every screenshot (debug
  build).

## Not flagged (decided)

- Material icons instead of lucide (D-12): `schedule`, `close`, `arrow_back`,
  `arrow_forward`, `info_outline`, `visibility_outlined`,
  `calendar_today_outlined`, `expand_more`, `error_outline`.
- Light-only theme (D-12).
- Sign-out confirmation bottom sheet on A6/A7 (plan §2.7, copy table E1).
- E2 re-review warning absent on `A7-edit-profile.png` (D-08).
- Eyebrows uppercased by the widget from natural-case copy
  (`FREELANCE EVENT CREW`, `UNDER REVIEW`, field labels).
- A6 timeline stamp `5 OCT 2026 · 09:47` without zero-pad — copy table
  `d MMM yyyy · HH:mm`.
- Phone shown as stored (`+628111222333`) — copy table E1 "shown as stored
  for v1".
- `Resend in 60s` shown immediately on A2c — D-02 60-s client cooldown.
- A2c/A2d keep the `Crew account` eyebrow — not in the copy table, consistent
  with A2/A2b.
