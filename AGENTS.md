# AGENTS.md — penta-crew-flutter

Instructions for any coding agent (Claude Code, Codex, Cursor, Sokudo swarm
workers) working in this repository. There is deliberately no `CLAUDE.md`:
Claude Code ≥ 2.1.277 reads `AGENTS.md` directly when `CLAUDE.md` is absent,
so this is the single file every tool reads. Do not add a `CLAUDE.md`.

Read this first, then the spec it points to. Do not start a feature without
having read `docs/implementation-plan.md` §2.

## 1. What this project is

Flutter mobile app for event crew: browse events, apply for positions, track
applications, schedule, profile + identity verification, notifications.
Built from `boilerplate-flutter-3-47` (Cubit → UseCase → Repository, `sl`
service locator, go_router, freezed + json_serializable). UI copy is English.

Source of truth, in order of authority:

| File | What it decides |
|---|---|
| `docs/implementation-plan.md` | Waves, kanban ticket map, **§2 binding tech decisions**, per-feature file ownership, definition of done (§2.8) |
| `docs/decisions.md` | D-01..D-13 with reasoning. Do not silently contradict one; add a new D-xx instead |
| `docs/api-contract.md` | Every endpoint, body, `code` values, `cannot_apply_reason` precedence. The mock backend implements this exactly |
| `docs/prototype/screens.html` | Visual reference, screen ids A1..E3. Screenshots are compared 1:1 against it |
| `README.md` | Architecture, folder layout, "Adding a feature in 4 steps", conventions |

If this file and `docs/` disagree, `docs/` wins — fix this file.

## 2. Commands

Flutter is pinned via fvm (`.fvmrc`: 3.47.6). The Makefile picks `fvm flutter`
automatically when fvm is installed.

```sh
make get        # pub get
make gen        # build_runner build (freezed / json_serializable)
make watch      # build_runner watch
make analyze    # flutter analyze — must print "No issues found"
make test       # flutter test
make run-dev    # run with env/dev.json (USE_MOCK=true)
./tool/run.sh dev -d <device-id>   # pick a simulator/device
```

Simulator smoke test with screenshots (saved to `build/screenshots/`, gitignored):

```sh
fvm flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/foundation_smoke_test.dart \
  --dart-define-from-file=env/dev.json -d <device-id>
```

Do not drive the simulator with AppleScript/System Events (hangs on the
Accessibility prompt) or `simctl io screenshot` into a sandboxed temp dir.
Use `integration_test` + `flutter drive`. In those tests, find inactive
`FloatingPillNav` tabs by icon — inactive tabs render no text label.

## 3. Working principles (adapted from Karpathy guidelines)

Condensed from https://github.com/multica-ai/andrej-karpathy-skills (MIT),
adjusted for a project that is mostly executed by headless workers from
kanban tickets. The bias is toward caution over speed; for a trivial fix,
use judgment.

### 3.1 Think before coding
- Make assumptions explicit. If the ticket, `docs/`, or the API contract
  already settle a question, **do not ask** — cite the source and proceed.
- If a request is genuinely ambiguous and the choice has architectural, UX,
  or contract impact, stop and ask (or pause the worker) *before*
  implementing. Offer the interpretations you see; do not pick one silently.
- If you see a simpler approach than the one requested, say so.
- Something confusing in the codebase? Name it, do not paper over it.

### 3.2 Simplicity first
- Write the minimum code that solves the ticket. No speculative features,
  no configurability nobody asked for, no abstraction for a one-off, no
  handling of errors that cannot happen.
- Test: would a senior Flutter engineer call this overcomplicated? Then
  simplify.

### 3.3 Surgical changes
- Touch only what the ticket names. Do not reformat, rename, or "improve"
  neighbouring code. Match the existing style of the file you are in.
- Clean up only what *your* change orphaned (imports, variables, helpers).
  Pre-existing dead code: flag it in the ticket comment, do not delete it.
- Every changed line should trace directly back to the request.
- Stay inside the folders your ticket owns (implementation-plan §4 lists
  them). Touching another feature's files is a review blocker unless the
  ticket says so.

### 3.4 Goal-driven execution
- Turn the ticket into checkable goals before coding. A bug fix = a test
  that reproduces it, then passes. A refactor = tests green before and
  after. A screen = analyze clean, tests for loading/empty/error/loaded,
  screenshot next to the prototype id.
- For multi-step work, write a short numbered plan with a verification per
  step, then loop until every check passes. Definition of done is §2.8 of
  the implementation plan — all six points, not the first two.

## 4. Code style — this project's rules

These sit on top of `analysis_options.yaml` (`flutter_lints` + extras:
single quotes, const constructors, trailing commas, declared return types,
`directives_ordering`). `make analyze` must be clean.

### 4.1 Naming: full words, never 1–2 letter identifiers

Variables, parameters, fields, and local functions are named with the actual
word for the thing. No single/double-letter identifiers, no abbreviations.

```dart
// good
for (final user in users) { … }
users.map((user) => user.name)
itemBuilder: (context, index) => …
} on DioException catch (error, stackTrace) {
final controller = TextEditingController();
final emailController = TextEditingController();

// bad
for (final u in users) { … }
users.map((e) => e.name)
(ctx, i) => …
} catch (e, s) {
final ctrl = TextEditingController();
```

Allowed exceptions, and only these:
- `id` (it is the word; matches the API contract: `event_id`, `position_id`).
- Generic type parameters (`T`, `E`, `K`, `V`) and the freezed/json
  generated code, which is never edited.
- Well-known Flutter parameter names in overrides (`context`, `child`,
  `index`) — these are already full words.

### 4.2 Member order inside a widget / page file

Both `StatelessWidget` and the `State` of a `StatefulWidget`, top to bottom:

1. **Fields** — `final` constructor params, controllers, keys, `late` vars,
   local state.
2. **Constructor** (for widgets).
3. **Framework lifecycle overrides** — `initState`, `didChangeDependencies`,
   `didUpdateWidget`, `dispose`, in that order.
4. **`build(BuildContext context)`.**
5. **Everything build uses, below it** — private widget builders
   (`Widget _buildHeader(…)`), event handlers (`void _onSubmit()`),
   small helpers, in roughly the order `build` calls them.
6. Private sub-widget classes (`class _EventTile extends StatelessWidget`)
   go after the main class, at the bottom of the file, each following the
   same order internally.

The point: a reader opens the file, sees state, sees lifecycle, sees the
tree, then scrolls down for details. `build` is never the last member.

Scope: applies to **all new files** and to any file you are already editing
substantially for your ticket. Do not reorder untouched legacy files
(`features/sample`, `login_screen.dart`) just to satisfy this — that is a
drive-by refactor (§3.3). Reorder them when a ticket actually works on them.

### 4.3 Project conventions (summary — README "Conventions" is authoritative)
- Cubit → UseCase → Repository. Cubits never call Dio; repositories never
  touch storage or UI. Nothing constructs its own dependency: `= XRepository()`
  is a review blocker, everything comes from `sl`.
- No `print` / `dev.log`; use `sl<Talker>()`.
- `core/` never imports `features/` (except `locator.dart`, `app_router.dart`).
- Cross-feature imports: a feature may import another feature's `models/`,
  `usecases/`, `<feature>_routes.dart`, `presentation/widgets/`. It may
  **not** import another feature's `repositories/` or `presentation/cubit/`.
  The only cross-feature cubit is `AuthCubit`. (implementation-plan §2.3)
- Model ownership follows endpoint ownership: `User/Branch/CrewRole` →
  `auth/models`; `Event/EventPosition/EventDetail/Application` →
  `events/models`; `AppNotification` → `notifications/models`.
- Navigation only via route constants (`AppRoutes`, `<Feature>Routes`);
  never string literals. Only the 4 tab roots live inside the shell; every
  other page is root-level with a back header (§2.5).
- Business errors branch on `Failed.code`, never on `message`; server
  `message` is shown as-is (§2.6).
- Presentation patterns (§2.7): cubit per page provided in the route
  builder; freezed sealed state `initial | loading | loaded | error`; list
  loading = `Skeleton` shaped like the card, not a spinner; mutations =
  `AppButton(busy: true)` + disabled inputs + `showAppToast`; destructive
  confirmation = bottom sheet radius 40.
- Design system: `core/theme` (`context.tokens`, 7 flat colours in
  `app_colors.dart`, light only — D-12) and `core/widgets`. Selected pills
  are ink, not blush. Do not hardcode colours or font sizes in features.
- Tests: `test/` mirrors `lib/`. Every new cubit has a `bloc_test`; every
  screen has widget tests for loading / empty / error / loaded.
- Generated `*.g.dart` / `*.freezed.dart` are committed and never hand-edited.
- No new dependency without approval recorded on the ticket.
- Commits: Conventional Commits, one commit per ticket.

## 5. Mock backend (`USE_MOCK`)

There is no real backend yet. `lib/core/network/mock/` holds `MockInterceptor`
+ `MockServer`: an in-memory implementation of the whole API contract,
installed in `buildDio` only when `Env.useMock` (`env/dev.json` → true,
`env/prod.example.json` → false). Fixtures are Dart consts so release builds
tree-shake them. Random 300–800 ms latency so skeletons are visible.

Gotchas that have already bitten:
- **Seed maps must go through a JSON round-trip** (`jsonEncode`/`jsonDecode`
  in `MockServer._reset()`). Nested const map literals are
  `Map<dynamic, dynamic>` and `.cast<Map<String, dynamic>>()` / `fromJson`
  fail at runtime without it.
- `cannot_apply_reason` is evaluated in the contract's order (`closed`
  before `already_applied`, …). The Mahesa town hall fixture is deliberately
  on the same date (18 Oct) as the Kirana event so `date_conflict` is
  visible. Both are D-13 — keep them when editing fixtures.
- Personas (password `password1`): `nadia@example.com` (approved; counts
  match prototype B1/D2), `pending@example.com` (A6),
  `rejected@example.com` (A7). Anything else → `401 invalid_credentials`.

## 6. Kanban / worker etiquette

- The ticket is your entire brief. Its description, `docs/`, and the API
  contract outrank anything you infer from code comments.
- Done per ticket = implementation-plan §2.8: analyze clean, tests green
  (cubit bloc_test + screen widget tests), run on simulator with
  `USE_MOCK=true`, screenshot attached to the ticket next to the prototype
  screen id, no files outside the ticket's folders, no `print`, no new deps,
  one Conventional Commit.
- Never merge `task-*` branches yourself; the user approves each worker
  result from its card.
- Do not push crew-app commits to the `boilerplate` remote
  (`riikuid/boilerplate-flutter-3-47`); `origin` is `riikuid/penta-crew-flutter`.
