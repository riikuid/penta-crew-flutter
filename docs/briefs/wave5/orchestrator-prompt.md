# Wave 5 orchestrator prompt (paste into a plain `claude` terminal session)

Start the session from the repo root (`cd ~/localstr/penta-crew-flutter && claude`),
then paste everything below the line. Run one ROUND per session (or `/clear`
between rounds) so the context stays small; the Lead (Sokudo) merges between
rounds, so each round starts from a fresh `main`.

---

You are the orchestrator for Wave 5: the fix tickets from the TASK-020 visual
QA. Read `AGENTS.md` and `docs/briefs/wave5/common-brief.md` first. The kanban
is not reachable from here — `docs/briefs/wave5/task-NNN.md` are the tickets,
`docs/reports/wave5/task-NNN-report.md` are the results.

Run ROUND <N> (see the round table below). For every ticket in the round:

1. Create a worktree from the current `main`:
   `git worktree add .claude/worktrees/task-NNN -b wave5/task-NNN main`
   (if the worktree already exists, check `git -C <wt> status` and `git log
   main..wave5/task-NNN` first — commit any leftover work there as
   `wip(...)` and tell the subagent to continue from it instead of restarting).
2. Spawn ONE Agent-tool subagent per ticket, `subagent_type: general-purpose`,
   `model: sonnet`, running in the background, all tickets of the round in
   the same message so they run concurrently. The prompt is:
   "Work in the git worktree `<abs path>` on branch `wave5/task-NNN`. Read
   `docs/briefs/wave5/common-brief.md` and then `docs/briefs/wave5/task-NNN.md`
   and do that ticket. Co-Authored-By trailer for commits:
   `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`."
   Nothing else — the briefs carry the full context.
3. Do not touch the worktrees yourself while subagents run. Do not merge
   anything into `main`, do not push. Do not re-do a subagent's work.
4. When a subagent finishes, verify its claim from the main checkout without
   entering its worktree: `git log --oneline main..wave5/task-NNN` shows
   exactly one commit; `git show --stat wave5/task-NNN` touches the expected
   files; `git -C .claude/worktrees/task-NNN status --short` is empty; the
   report file exists on the branch. If a subagent failed or left the
   worktree dirty, re-spawn it ONCE with the same prompt plus "continue from
   the existing commits/working tree, do not start over"; if it fails again,
   re-spawn with `model: opus` once; after that, stop and report.
5. When the round is complete, print one table — ticket, branch, commit sha,
   files changed, analyze/test result from the report, open questions — and
   stop. The Lead reviews and merges from the Sokudo side.

Rules of thumb: at most 5 subagents running at once (queue the rest and start
them as slots free up); start TASK-046 first in round 1 because it is short
and needs the simulator exclusively for `flutter drive`.

## Round table

Grouped so that no two tickets in the same round edit the same file. Round
N+1 only starts after round N is merged to `main` (the Lead does that).

### Round 1 — 11 tickets, 10 subagents — **DONE, merged to `main` at `3c715d3`**

| Ticket | Model | Files (expected) |
|---|---|---|
| TASK-046 smoke test | sonnet | `integration_test/foundation_smoke_test.dart` — start first, simulator |
| TASK-029 router refresh | sonnet | `core/router/router_refresh.dart`, `app.dart`, `profile/.../edit_profile_screen.dart` |
| TASK-030 keyboard inset + scrolling headers | sonnet | `events/.../events_screen.dart`, `notifications/.../notifications_screen.dart` |
| TASK-031 sign-in lands on previous tab | sonnet | `auth/.../login_screen.dart`, sign-out path |
| TASK-032 sheets under the nav | sonnet | `profile/.../confirm_sheet.dart`, `option_sheet.dart` |
| TASK-034 **then** TASK-033 — ONE subagent, two commits, worktree `task-034` | sonnet | `home/home_routes.dart`, Home cubit, `home_screen.dart`, `schedule_screen.dart` |
| TASK-035 AppButton | sonnet | `core/widgets/app_button.dart`, `core/theme/app_theme.dart` (button text only), `register_screen.dart` `_ContinueButton` (optional) |
| TASK-036 TagChip | sonnet | `core/widgets/tag_chip.dart` |
| TASK-042 mock sessions | sonnet | `core/network/mock/mock_server.dart` |
| TASK-043 toast | sonnet | `core/widgets/app_toast.dart` |
| TASK-044 GroupedCard ripple | sonnet | `profile/.../grouped_card.dart` |

For the 034+033 subagent the prompt names both briefs: do TASK-034 first,
squash to its own commit, then TASK-033 on top, its own commit; one report
file per ticket.

### Round 2 — 3 tickets, 3 subagents (round 1 is on `main`; start from `3c715d3` or later)

Run all three concurrently (max 3 at once). TASK-041's `View list` line in
`home_screen.dart` and the C1/C2/N1 headers now look as round 1 left them —
read the merged code, not the TASK-020 screenshots, for the current layout.

| Ticket | Why it waits | Files |
|---|---|---|
| TASK-040 form polish | edits `login_screen.dart` (031), `app_theme.dart` (035), `register_screen.dart` (035), `edit_profile_screen.dart` (029) | + `forgot_password_screen.dart`, `core/widgets/labeled_field.dart` |
| TASK-041 touch targets | edits the `events_screen.dart` / `notifications_screen.dart` headers (030) and `home_screen.dart:300` `View list` (033 changes the same lines) | |
| TASK-037 state cards + `pagePadding` | lives in lists that 030 restructures; token is used only in `state_views.dart` | `core/widgets/state_views.dart`, `core/theme/app_tokens.dart` |

### Round 3 — after round 2, each needs something first

| Ticket | Gate | Files |
|---|---|---|
| TASK-045 CircleBackButton + naming | after 040 (both edit `forgot_password_screen.dart`, `edit_profile_screen.dart`) | auth + profile widgets, `verification_data_screen.dart`, `change_password_screen.dart`, `progress_timeline.dart` |
| TASK-047 round-1 leftovers | after 040 (`register_screen.dart`) and 041 (`events_screen.dart`, `home_screen.dart`) | `events_screen.dart` (tab sync only), `home_screen.dart` `_RefreshOnShow`, `core/widgets/app_button.dart`, `register_screen.dart` A4 |
| TASK-039 page geometry | **user decision** on the 60/62-pt reading (brief says ask first); touches 8 screens, so always last and alone among screen tickets | `home/events/event_detail/schedule/profile/notifications` screens, `auth_page.dart`, `register_screen.dart` |
| TASK-038 logo + BrandMark | **blocked on the logo asset** from design (put it under `assets/` and name it in the brief before spawning) | `splash_screen.dart`, `auth_page.dart`, `verification_screen.dart`, `home_screen.dart` |

045 and 047 edit disjoint files, so they run concurrently as soon as round 2
is merged. 039 runs alone after them (it touches `home`, `events` and
`register` screens that 047 also edits); 038 whenever the asset lands.
