# TASK-032 — Bottom sheets from tab screens opening under the floating nav

Branch `wave5/task-032`, commit see final log line (fix(profile): open confirm and option sheets on the root navigator).

## What changed
- `lib/features/profile/presentation/widgets/confirm_sheet.dart`: `useRootNavigator: true` so the E1 sign-out sheet covers the nav. Its `Navigator.of(context).pop` now resolves to the root navigator, which is where the sheet lives.
- `lib/features/profile/presentation/widgets/option_sheet.dart`: same.
- `test/features/profile/root_sheet_test.dart`: sheet opened from a nested navigator leaves the nav not hit-testable; `Stay signed in` closes only the sheet and returns false.

## Verification
- make analyze: No issues found / make test: 464 passed
- device checks: not run (simulator not used; covered by the widget test)

## Risks / follow-ups
- Other `showModalBottomSheet` calls (apply/withdraw on event detail, register gender/branch) are on root-level pages, so left unchanged.
- The disk hit 100% during the run (ENOSPC in flutter test); first full-suite attempts died from that, the final run was clean.
