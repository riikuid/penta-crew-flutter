# TASK-036 — Fix TagChip stretching to full width inside Wrap

Branch `wave5/task-036` (fix(widgets): size TagChip to its content).

## What changed
- `lib/core/widgets/tag_chip.dart`: dropped `Container(alignment: center)` (expanded to max width under loose constraints); label now in `Row(mainAxisSize: min)`.
- `test/core/widgets/foundation_gaps_test.dart`: test that a chip is content-width and two chips share one row in a `Wrap`.

## Verification
- make analyze: clean
- tests run: foundation_gaps_test, schedule_screen_test (touched/related only; full suite left to orchestrator per RAM constraint)
- device checks: none

## Risks / follow-ups
- Call sites (event_card, event_detail, profile, schedule) not visually re-checked on device; chips now content-width everywhere.
