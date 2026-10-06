# TASK-044 — Add tap feedback to GroupedCard rows

Branch `wave5/task-044`, commit `926749c` (fix(profile): show ink ripple on GroupedCard action rows).

## What changed
- `lib/features/profile/presentation/widgets/grouped_card.dart`: `DecoratedBox` -> `Material` (surface colour, card radius, hairline border via shape, `Clip.antiAlias`) so `ActionRow` ink is no longer hidden. Same widget is used by A6a View my data (InfoRow only, no visual change at rest).
- `test/features/profile/grouped_card_test.dart`: ink circle is painted on the card's own Material on tap (fails before the fix, passes after).

## Verification
- make analyze: clean / make test: 464 passed
- device checks: none run

## Risks / follow-ups
- Ripple is bounded by the row (inside the 20 px horizontal padding), clipped by the card; not full-bleed.
