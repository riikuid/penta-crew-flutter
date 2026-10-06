# TASK-038 — Add the logo asset and a shared BrandMark widget (A1, A2, A6, A7, Home header)

Kanban: TASK-038 · priority low · fix ticket from TASK-020 (`docs/reports/task-020-report.md`). Read `docs/briefs/wave5/common-brief.md` first.

## Goal
Render the Pentamoo logo where the prototype shows it: A1 splash (168 px wide), A2/A3/A6/A7 (40 px above the intro, +32/56 gap), B1–B3 Home header (36 px, currently an ink-circle placeholder). Also stop the dev flavour name (`Penta Crew Dev`) leaking into the splash.

Source: TASK-020 visual QA, cross-cutting #10 (`docs/reports/task-020/findings-a.md` A1/A2/A6/A7, `findings-b.md` B1).

## Context
- **Blocked on the asset from design** — the Lead/user must attach the logo file (SVG or @1x/@2x/@3x PNG) to this ticket before it starts. If it is not attached, do only step 1 and ask.
- `lib/features/auth/presentation/screens/splash_screen.dart:70` renders `Env.appName`; `auth_page.dart:45-46` reserves 56 px where the prototype has logo 40 + 56; `verification_screen.dart:46-50`; `home_screen.dart:329` placeholder.
- Declare the asset in `pubspec.yaml` under `assets/`; no new package (`flutter_svg` would be a new dependency and needs approval on the ticket — prefer PNG if the file is raster).

## Steps
1. Replace `Env.appName` on the splash with a fixed brand string (until the asset lands) — this part is independent of the asset.
2. Add the asset(s) and a `BrandMark` widget in `lib/core/widgets/` with a `size` parameter.
3. Use it on A1, A2/A3 (`auth_page`), A6/A7, Home header; fix the gaps to the prototype (A2 headline block currently ~26 px too high).
4. Widget test for `BrandMark`; golden not required.

## Acceptance criteria
- Logo visible on A1 (168), A2/A6/A7 (40), B1 (36) matching the prototype positions.
- Splash never shows the flavour suffix.
- `make analyze` and `make test` clean; one Conventional Commit.
