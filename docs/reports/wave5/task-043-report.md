# TASK-043 — Toast no longer covers the back button

Branch `wave5/task-043` (fix(toast): start toast overlay below the back-circle header).

## What changed
- `lib/core/widgets/app_toast.dart`: new `AppToast.config` (overlay top margin 104). Chosen option: offset below the header. Pass-through/IgnorePointer was tried and does not work: toastification's AnimatedList absorbs all taps over its bounds, including the card's own padding, so the offset has to be the list margin, not card padding. Card top padding removed.
- `lib/app.dart`: `ToastificationWrapper(config: AppToast.config)` (required for the shared config to apply; reason listed per common brief).
- `test/core/widgets/app_toast_test.dart`: tapping back while a toast is visible pops the page (failed before the fix).

## Verification
- make analyze: clean. Tests run (foreground, touched only per orchestrator): app_toast_test + foundation_gaps_test, 10 passed. Full suite not re-run (disk).
- No device check; on-device toast now sits ~104 pt from top instead of ~61 (deviates from prototype C5 by design).

## Risks / follow-ups
- Toast tap-to-dismiss retained. Offset 104 is fixed; not safe-area aware beyond toastification adding viewPadding. Verify on a notched device.
