# TASK-035 — Fix AppButton busy state looking disabled and add 52/44 sizes with 15/14-px labels

Kanban: TASK-035 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
1. While `loading: true`, `AppButton` must keep its enabled colours and show a visible spinner in the label colour (today it renders in the disabled look: line-grey fill, nearly invisible spinner). Affects every mutation CTA: A2, A5, E2, E3, C3 apply, C5 withdraw.
2. Add the missing sizes so E1 `Sign out` (52 pt, 15/500, 18-px icon), E2 `Change photo` (44 pt, 14/500, 16-px icon) and E3 `Forgot password?` (14/500) can match the copy table instead of using `medium` = 48 / 16 px.

Source: TASK-020 visual QA, cross-cutting #7 (`docs/reports/task-020/findings-a.md` A2, `findings-c.md` E1/E2/E3 + Cross-cutting; screenshots `A2-busy.png`, `A5-busy.png`, `E2-busy.png`).

## Context
- `lib/core/widgets/app_button.dart:66`: `loading: true` sets `onPressed: null`, which resolves the disabled style.
- `AppButtonSize` has only 56/48; theme `buttonText` is 16 px (`lib/core/theme/app_theme.dart`). Do not hardcode sizes in features (AGENTS.md §4).
- Optional, same widget: a `trailingIcon` so A4's `_ContinueButton` (`register_screen.dart:420`) can stop bypassing `AppButton`.

## Steps
1. Resolve background/foreground on a `loading` flag (or wrap in `IgnorePointer` with a non-null `onPressed`); spinner drawn in the label colour, inputs still disabled by the callers.
2. Add a `small` (44) size and a 52 variant (or a `height`/`labelSize` override — keep it minimal), with 15/14-px label options and icon size per size.
3. Apply on E1 `Sign out` (`profile_screen.dart:95-101`), E2 `Change photo` (`edit_profile_screen.dart:129-139`), E3 `Forgot password?` (`change_password_screen.dart:70-82`, also zero horizontal padding so it sits flush right and tighten the 14-pt gaps).
4. Widget tests: busy button keeps enabled colours and shows the spinner; each size renders its height/label size.

## Acceptance criteria
- `A2-busy` style screenshots show an ink button with a visible spinner.
- E1 / E2 / E3 button measurements match the copy table (52/15/18, 44/14/16, 14/500 flush right).
- No feature hardcodes a font size or height.
- `make analyze` and `make test` clean; one Conventional Commit.
