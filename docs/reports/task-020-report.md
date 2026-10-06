# TASK-020 — Visual QA report (mock app vs prototype)

## Summary

1. All 26 prototype screens plus the 4 without a prototype (A2b–A2d forgot/reset, A6a View my data, N1 Notifications) were run on an iPhone 16 Pro simulator with `USE_MOCK=true`; 134 screenshots in `docs/reports/task-020/`.
2. No BLOCKER: every flow in the brief completes (apply → Tracked → withdraw, register → verification, edit profile → header updates, notification tap → event detail), but two only with a workaround (E2 save needs a manual back; C1 search results are hidden until the keyboard closes).
3. Highest-impact ISSUEs: C1 keyboard overflow (double keyboard inset), E2 save not returning (router refresh on every `AuthCubit` emission), sign-in after sign-out landing on the previous user's Profile, E1 sign-out sheet under the floating nav, Home counters not refetching.
4. Most visual deviations come from a few shared widgets: `AppButton` (busy looks disabled; only 56/48 sizes), `TagChip` (stretches full width), `_StateCard` (centred, 24-pt inset), page top offset (+12/16 pt), and the missing logo asset.
5. `foundation_smoke_test` **FAIL** (test bug, not app bug — see below); the three QA drivers `integration_test/visual_qa_group_{a,b,c}_test.dart` pass.

Detail per screen, with measurements, `file:line` and suggested fixes, lives in
`docs/reports/task-020/findings-a.md` (auth + verification),
`findings-b.md` (home + events) and `findings-c.md` (schedule + profile +
notifications). This file lists every finding in one line; counts per group
(including the cross-cutting roll-ups): A 0/20/17, B 0/18/13, C 0/15/7
(BLOCKER/ISSUE/SUGGESTION).

Run environment: simulator `PentaQA-16Pro` (iPhone 16 Pro, 402×874, 3×),
iOS 26.4, Flutter 3.47.6 via fvm, debug `env/dev.json`, branch
`wave4/task-020-visual-qa` from `main` `ead61e8`, 5–6 Oct 2026. Android
emulator not run. States that the default fixtures cannot produce (B3, C7,
C10, D2/D3 empty, N1 empty) were captured with `--dart-define=QA_VARIANT=fixtures`
and temporary fixture edits that were reverted (`mock_data.dart` is unchanged
on this branch).

Severity key: **BLOCKER** stops a flow · **ISSUE** deviates from the
prototype / copy table / project rules · **SUGGESTION** judgement call.

## foundation_smoke_test

**FAIL** (2 of 2 runs) at `integration_test/foundation_smoke_test.dart:61`:
after the second sign-in it expects `FloatingPillNav` and finds none. Cause is
the test, not the app: `enterText` right after the app's `unfocus()` is
dropped on the simulator; the smoke test's `signOut` also looks for an
`OutlinedButton` where A6/A7 render a ghost `TextButton`. Fix: tap + settle
before `enterText`; look for `TextButton` on A6/A7. Details in findings-a.

## A — Auth + verification (findings-a.md)

- **A1** · ISSUE no logo; dev flavour name `Penta Crew Dev` leaks into the splash (`splash_screen.dart:70`).
- **A2/A3** · ISSUE 40-px logo missing · ISSUE `AppButton` busy state looks disabled (`app_button.dart:66`) · ISSUE validator errors stay while typing (`login_screen.dart:77`) · ISSUE (minor) error row indented 20 px · SUGGESTION password cleared on `invalid_credentials` · SUGGESTION bottom spacing.
- **A2b** · ISSUE (minor) empty email message · SUGGESTION two back affordances.
- **A2c** · no findings.
- **A2d** · ISSUE rules card hidden by the keyboard · SUGGESTION empty email on Sign in after success.
- **A4** · SUGGESTION bottom spacing · SUGGESTION `_ContinueButton` bypasses `AppButton`.
- **A5** · ISSUE unthemed Material date dialog · ISSUE picker opens 17 years back on the month grid · SUGGESTION ×4 (min age rule location, picker inset, sheet handle/title, back active while busy).
- **A6** · ISSUE logo missing · ISSUE pull-to-refresh goes through `AuthCubit.checkSession()` · SUGGESTION mock `submitted_at` time.
- **A6a** · ISSUE row order differs from A5 · SUGGESTION duplicate `CircleBackButton`.
- **A7** · ISSUE logo missing · ISSUE (minor) note body 18 vs 17 px · SUGGESTION empty `""` for a null note.

## B — Home + events (findings-b.md)

- **B1** · ISSUE Home does not refetch after apply/withdraw (`home_routes.dart:21-25`) · ISSUE `Waiting` / `View list` go to tab-less `EventsRoutes.root` (`home_screen.dart:195,302`) · ISSUE (minor) `View list` 31 pt hit area · SUGGESTION `Worked` should open D2 history.
- **B2** · no findings.
- **B3** · ISSUE `Waiting 00` / `Worked 00` counters not in the B3 spec (`home_screen.dart:64`).
- **C1** · ISSUE keyboard overflow, results invisible while typing — nested `Scaffold` applies the inset twice (`events_screen.dart:105`) · ISSUE header fixed instead of scrolling with the list · ISSUE position chips stretch (`tag_chip.dart:55-58`) · ISSUE (minor) clear `×` 18 pt · SUGGESTION ×3 (nav over keyboard, skeleton flash per keystroke, no "applied" hint on open cards).
- **C2** · SUGGESTION card shows `CLOSES` 1/3 while C7 shows `CLOSED` 2/3 for the same application.
- **C3** · ISSUE requirement chips stretch · ISSUE (minor) skeleton headline widths · ISSUE (minor) error card shrink-wraps · SUGGESTION `Try again` on a 404 · SUGGESTION action bar 50 vs 34 pt.
- **C4** · SUGGESTION no busy state on the sheet (it pops before the request).
- **C5/C6** · SUGGESTION top toast covers the back button for ~3 s (`app_toast.dart:34-42`).
- **C7, C8, C9** · no findings.
- **C10** · ISSUE empty card centred with 24-pt inset (`state_views.dart:97-99`) · SUGGESTION search no-results reuses the "no open events" copy · SUGGESTION search field shown at 0 events.

## C — Schedule + profile + notifications (findings-c.md)

- **D1** · ISSUE (minor) loading rail centred instead of top-aligned (`schedule_screen.dart:382-399`).
- **D2** · SUGGESTION row titles clamped to one line.
- **D3** · ISSUE `Browse events` goes to tab-less `EventsRoutes.root` (`schedule_screen.dart:241`).
- **E1** · ISSUE sign-out sheet opens under the floating nav, nav still tappable (`confirm_sheet.dart:37`, needs `useRootNavigator`) · ISSUE `Member since` row not in spec · ISSUE (minor) `Sign out` 48/16 vs 52/15 · SUGGESTION no ripple on `GroupedCard` rows.
- **E2** · ISSUE `Save changes` does not return to Profile; the page reloads and stays open (likely router refresh on `AuthCubit` change rebuilding the route's cubit) · ISSUE (minor) header 18 vs 17 px · ISSUE (minor) `Change photo` 48/16 vs 44/14 · SUGGESTION read-only Email looks editable.
- **E3** · ISSUE (minor) `Forgot password?` size, inset and spacing · SUGGESTION rules card hidden while typing the new password.
- **N1** · ISSUE (minor) `Mark all read` 33 pt hit area · SUGGESTION `Just now` not in the copy table · SUGGESTION failed mark-all-read is silent. `Today` group not verifiable with the fixtures.

## Cross-cutting

Ordered by impact; each is one fix ticket candidate.

1. **ISSUE** · Router refreshes on every `AuthCubit` emission, including profile-only `updateUser` → E2 save does not pop (also likely `Change photo`, `Submit again`) · `lib/app.dart:32`, `lib/core/router/router_refresh.dart` · notify only on auth-status changes.
2. **ISSUE** · Nested `Scaffold` on tab screens applies the keyboard inset twice (C1 overflow); tab headers are fixed instead of scrolling (C1, C2, N1) · `events_screen.dart:105-151` · `resizeToAvoidBottomInset: false` + sliver header.
3. **ISSUE** · Sign-in after sign-out lands on the previous user's last tab (`from=/profile`) · `login_screen.dart:131` · drop `from` on sign-out.
4. **ISSUE** · Sheets from tab screens open under the floating nav (E1; `OptionSheet` same shape) · `confirm_sheet.dart:37` · `useRootNavigator: true`.
5. **ISSUE** · Tab-less `EventsRoutes.root` links (B1 `Waiting`, B1 `View list`, D3 `Browse events`) · use `EventsRoutes.tracked` / `.open`.
6. **ISSUE** · Home never refetches after mutations elsewhere (B1) · `home_routes.dart:21-25`.
7. **ISSUE** · `AppButton`: busy state looks disabled (A2, A5, E2, E3, C3); only 56/48 sizes and 16-px label, so 52/44 and 15/14-px buttons are off (E1, E2, E3) · `app_button.dart`.
8. **ISSUE** · `TagChip` stretches to full width in a `Wrap` (C1, C3, D1, E1) · `tag_chip.dart:55-58`.
9. **ISSUE** · `_StateCard` (empty/error) is centred, shrink-wrapped, 24-pt inset (C3, C10, D2, D3, N1) · `state_views.dart:97-103`; together with `AppSize.pagePadding = 24` vs the prototype's 20 (A).
10. **ISSUE** · Logo asset missing (A1, A2, A6, A7; 36-px ink placeholder on B1–B3) — needs the file from design.
11. **ISSUE** (minor) · Page top offset +12/16 pt over the safe area on every tab and detail page; bottom bars and sheets ~14–16 pt higher than the prototype.
12. **ISSUE** · Validator errors don't clear on typing (A2, A2b); field error row indent (A, `labeled_field.dart:270`); unthemed Material date picker (A5, E2).
13. **ISSUE** (minor) · Touch targets under 44 pt: C1 clear `×` (18), B1 `View list` (31), N1 `Mark all read` (33).
14. **ISSUE** (dev only) · Mock sessions don't survive a cold start (A).
15. **SUGGESTION** · Top toast covers the back button on root-level pages (C5, C6, E3).
16. **SUGGESTION** · `GroupedCard` rows give no tap feedback (E1).
17. **SUGGESTION** · Two `CircleBackButton` implementations (auth vs profile); `progress_timeline.dart` uses short identifiers (AGENTS.md §4.1).

## Not flagged (decided)

D-04 `Waiting` counter, D-06 N1 follows C2, D-08 removed warning / E2 info
note, D-09 locked rows in the C4 sheet, D-12 Material icons, D-14 no briefing
line on the Home hero, light-only theme, sign-out confirmation as a bottom
sheet, eyebrows uppercased by the widget from natural-case copy.

## Not covered

- Android emulator (not available in this run).
- `Change photo` and A7 `Submit again` flows (likely share the E2 reload).
- N1 `Today` group (no fixture dated today).
- Status bar and the system keyboard itself are not in the screenshots (Flutter view only); the keyboard inset is.

## How to reproduce

```sh
fvm flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/visual_qa_group_b_test.dart \
  --dart-define-from-file=env/dev.json -d <device-id>
# group a / c: swap the target; QA_VARIANT=fixtures needs the temporary
# fixture edits described in findings-b / findings-c; QA_ONLY=C1,C9 runs
# selected group B sections.
```
