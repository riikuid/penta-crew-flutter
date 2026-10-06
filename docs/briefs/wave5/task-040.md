# TASK-040 — Fix form polish: validator errors not clearing on typing, error row indent, unthemed date picker

Kanban: TASK-040 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Three form-level deviations found across the auth and profile forms:
1. Validator errors from a failed submit stay while the user types a correction on A2 and A2b (only `invalid_credentials` clears); A4 clears per field — make the forms consistent.
2. Field error row is indented ~20 px; prototype A3 puts the 16-px alert icon flush with the field's left edge (`docs/prototype/screens.html:361`).
3. The Date of birth picker (A5, E2) is the stock Material dialog: line-grey surface, M3 header, off palette and type; it also opens on the month grid 17 years back.

Source: TASK-020 visual QA, cross-cutting #12 (`docs/reports/task-020/findings-a.md` A2/A2b/A5, `findings-c.md` E2).

## Context
- `lib/features/auth/presentation/screens/login_screen.dart:77` (`Form` without `autovalidateMode`); `forgot_password_screen.dart:80` also returns `Enter a valid email address.` for an empty email where A2 says `Enter your email.` → share one email validator in `FormValidators`.
- Error row: `InputDecorationTheme.contentPadding` offsets `errorBuilder`; `AppPickerField` copies the offset in `lib/core/widgets/labeled_field.dart:270` (`left: 20`). Also picker text sits ~4 px left of text-field text (`labeled_field.dart:247`).
- Date picker: `register_screen.dart:325-327`, `edit_profile_screen.dart`; `lib/core/theme/app_theme.dart` has no `datePickerTheme`. Add a `DatePickerThemeData` (white surface, radius 32, ink selection, Inter) and open with `initialDatePickerMode: DatePickerMode.year`. A custom picker sheet is out of scope unless the theme cannot get close.

## Steps
1. `AutovalidateMode.onUserInteraction` after the first submit (or per-field clear like A4) on A2/A2b/E3 where applicable; shared email validator.
2. Error row flush left for both `AppTextField` and `AppPickerField`; align picker text inset with the text field.
3. `datePickerTheme` in `app_theme.dart`; year mode first on A5 and E2.
4. Widget tests for the validator clearing and the shared validator.

## Acceptance criteria
- A2: submit with a bad email, type a valid one → error disappears while typing. A2b empty email → `Enter your email.`
- Error icon flush with the field edge on A3/A4/E2.
- A5/E2 picker on-palette, opens in year selection.
- `make analyze` and `make test` clean; one Conventional Commit.
