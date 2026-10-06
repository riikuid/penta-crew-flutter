# Wave 5 — common brief for every fix subagent

You are one subagent fixing ONE ticket from the TASK-020 visual QA
(`docs/reports/task-020-report.md`). Your ticket brief is
`docs/briefs/wave5/task-NNN.md`. This file is the rules that apply to all of
them. The kanban is not reachable from this session — the brief files are the
ticket; the report file you write is how the result gets back to the board.

## Read first

1. `AGENTS.md` (all of it — naming §4.1, member order §4.2, commit format).
2. Your ticket brief, then the findings section it cites under
   `docs/reports/task-020/findings-{a,b,c}.md` (file:line + screenshots).
3. `docs/copy-table.md` for any wording you touch; `docs/decisions.md` before
   changing anything a D-xx decides.

## Where you work

- Only inside the git worktree you were given (`.claude/worktrees/task-NNN`,
  branch `wave5/task-NNN`, created from `main` by the orchestrator). Never
  `cd` to the main checkout, never touch another worktree.
- Flutter via fvm: `make analyze`, `make test`, `make run-dev` (see AGENTS.md
  §2). Run `make get` once in the worktree before anything else (build
  artefacts are not shared between worktrees); run `make gen` only if you
  change a freezed/json model.
- Simulator work (`make run-dev`, `flutter drive`) is only required where the
  brief says to reproduce or verify on device. Only one simulator is available
  — if `flutter drive` fails because the device is busy, retry after a short
  wait rather than booting another one.

## Commit discipline — non-negotiable

- **Commit after every milestone that compiles** (a widget, a cubit, a test
  file) as `wip(scope): …`. Never leave work uncommitted; the session that
  spawned you can be killed at any time and uncommitted work is lost.
- When the ticket is done, squash your wip commits into **one Conventional
  Commit** with the type/scope the brief names (`fix(router): …`,
  `refactor(core): …`), body explaining what and why, ending with the
  `Co-Authored-By:` trailer the orchestrator gave you. `git rebase -i` is not
  available non-interactively — use `git reset --soft $(git merge-base main HEAD)`
  then one `git commit`.
- Never push. Never merge into `main`. Never rebase onto a moved `main` —
  the Lead resolves conflicts at review time.

## Scope

- Change only what the ticket needs. Files the brief lists are the expected
  footprint; touching another file is fine when the fix requires it, but list
  it in the report with the reason.
- No new dependencies (pubspec) without the brief saying so. No `print`
  left behind. No TODOs. No commented-out code.
- If the brief says "decide with the Lead" / "ask on this ticket": do the parts
  that do not depend on the decision, write the question and the options in
  your report under `## Open question`, and stop. Do not guess.
- If you find the cause is different from what the brief assumes, fix the
  real cause and say so in the report. If it is genuinely out of scope,
  report it under `## Found, not fixed`.

## Definition of done

- Acceptance criteria in the brief met; `make analyze` prints
  `No issues found`; `make test` passes (full suite, not only your tests).
- Tests the brief asks for are added next to the existing ones
  (`test/<feature>/…`), following the existing test style.
- No visual regression: compare with the TASK-020 screenshots the brief
  cites. Where the brief asks for device verification, say what you ran and
  what you saw.

## Report — `docs/reports/wave5/task-NNN-report.md`, committed on your branch

Keep it short; the Lead pastes it to the kanban:

```
# TASK-NNN — <title>

Branch `wave5/task-NNN`, commit `<sha>` (<Conventional Commit subject>).

## What changed
- one bullet per file, what and why

## Verification
- make analyze: clean / make test: N passed
- device checks (if any): what was run, what was observed
- tests added: paths

## Risks / follow-ups
- anything the Lead should know at review; "none" if none

## Open question        (only if the brief required a decision)
## Found, not fixed     (only if applicable)
```

Finish by printing the branch name, the final commit sha, and the report
path as the last lines of your output.
