# TASK-035 — AppButton busy state and 52/44 sizes

Branch `wave5/task-035`, commit see `git log -1` (fix(core): keep AppButton enabled look while loading, add tall/small sizes).

## What changed
- `lib/core/widgets/app_button.dart`: `loading` now passes a no-op callback (enabled colours) inside `IgnorePointer`, so the spinner (label colour via IconTheme) is visible. `AppButtonSize` gains `height/fontSize/iconSize`: large 56/16/20, tall 52/15/18, medium 48/16/20, small 44/14/16. New optional `padding` override. `tapTargetSize: shrinkWrap` so 44 stays 44.
- `profile_screen.dart`: Sign out uses `tall`.
- `edit_profile_screen.dart`: Change photo uses `small`.
- `change_password_screen.dart`: Forgot password? uses `small`, zero padding (flush right), gaps 14 -> 4 (44 + 8 + label ~ prototype 53).
- `test/core/widgets/app_button_test.dart`: loading test updated; sizes test added.

## Verification
- make analyze: clean / make test: all passed
- device checks: none run (widget tests only)

## Risks / follow-ups
- Optional `trailingIcon` for A4 `_ContinueButton` not done.
- Busy + null `onPressed` now looks enabled (callers like Change photo pass null while busy); intended per ticket.
