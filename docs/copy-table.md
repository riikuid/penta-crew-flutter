# Copy table — every screen, character-exact

Source: TASK-006 investigation (findings parts 3–5), read character-exact from
`docs/prototype/screens.html` markup + JS mock data. Dynamic parts use contract
field names from `docs/api-contract.md`. `proposed` = not in the prototype,
written in the same voice (short, editorial, no exclamation marks). Eyebrows are
written in natural case — `Eyebrow` / `StatusPill` uppercase them.

Decisions applied after the audit: D-14 (no briefing line on the Home hero),
sign-out confirmation = bottom sheet (plan §2.7 wins over prototype C6 note).
Time ranges always use an en dash with no spaces: `14:00–20:00`.

## Shared chrome (every tab screen)

| element | copy | notes |
|---|---|---|
| nav label | `Home` / `Events` / `Schedule` / `Profile` | `app_shell.dart` |
| system messages | `The connection is taking too long. Check your network and try again.` / `Can't reach the server. Check your internet connection.` / `Something went wrong. Please try again.` / `Your session has expired. Please sign in again.` / `You don't have access to this page.` / `The request was cancelled.` | `AppMessages` (D-13). Server `message` is shown as-is (contract §0) |
| retry button | `Try again` | `ErrorView.retryLabel` default |
| generic empty | `Nothing here yet.` | `EmptyView.message` default; screens below override |
| password eye tooltip | `Show password` / `Hide password` | |

## A1 Splash

| element | copy | notes |
|---|---|---|
| logo | — | image 168 wide |
| eyebrow | `Freelance event crew` | 11/600, 0.08em |

## A2 Sign in

| element | copy | notes |
|---|---|---|
| eyebrow | `Crew account` | |
| headline | `Welcome back.` | 44 px (`displayLarge`) |
| body | `Sign in with the email you registered with.` | 16 px muted |
| field label | `Email` | placeholder `name@email.com` |
| field label | `Password` | placeholder `Enter password`; eye toggle |
| link | `Forgot password?` | 14/500, right-aligned **below** the password field |
| CTA primary | `Sign in` | 56 ink |
| CTA secondary | `Create account` | 56 blush |
| validation (empty email) | `Enter your email.` | `proposed` |
| validation (bad email) | `Enter a valid email address.` | `proposed` |
| validation (empty password) | `Enter your password.` | `proposed` |

## A3 Sign in · error

| element | copy | notes |
|---|---|---|
| inline error | `Email or password is incorrect.` | Under the **password** field, red, alert icon 16; from server `message` for `401 invalid_credentials` — `errorText`, not toast |

## A4 Create account (step 1)

| element | copy | notes |
|---|---|---|
| step counter | `01 / 02` | 11/600 muted, not uppercase-transformed |
| headline | `Tell us who you are.` | 36 px |
| body | `Account details. You'll add your crew profile next.` | 15 muted |
| field label | `Full name` | placeholder `As on your ID` |
| field label | `Email` | placeholder `name@email.com` |
| field label | `Phone number` | placeholder `0812 3456 7890` |
| field label | `Password` | placeholder `At least 8 characters` |
| field label | `Confirm password` | no placeholder |
| CTA | `Continue` | 56 ink, trailing arrow-right 18 |
| validation | `Enter your full name.` / `Enter a valid email address.` / `Enter your phone number.` / `Use at least 8 characters with a number.` / `Passwords don't match.` | all `proposed`; 422 `errors` shown per field as-is |

## A5 Complete profile (step 2)

| element | copy | notes |
|---|---|---|
| step counter | `02 / 02` | |
| headline | `Your crew profile.` | 36 px |
| body | `An admin reviews this before your first event.` | |
| field label | `Date of birth` | picker displaying `dd / MM / yyyy` |
| field label | `Gender` | picker placeholder `Select`; options `Female` / `Male` |
| field label | `Branch` | picker; value e.g. `Jakarta` |
| field label | `Home address` | textarea 3 rows, placeholder `Street, district, city` |
| info note | `Your crew roles and tags are set by an admin after they review your profile.` | blush note, info icon |
| CTA | `Submit for review` | 56 ink |
| validation | `Enter your date of birth.` / `Select your gender.` / `Select your branch.` / `Enter your home address.` | `proposed` |

## A6 Verification · pending

| element | copy | notes |
|---|---|---|
| pill | `Under review` | blush, clock 14 |
| headline | `We're reviewing your profile.` | 40 px |
| body | `An admin from the {branch.name} branch will check your data and assign your crew roles. We'll notify you when it's done.` | |
| timeline 1 | `Profile submitted` · sub `{submitted_at:d MMM yyyy · HH:mm}` uppercased | state done |
| timeline 2 | `Admin review` · sub `{BRANCH} BRANCH · IN PROGRESS` | state current |
| timeline 3 | `Roles assigned` · sub `NEXT` | state upcoming |
| CTA secondary | `View my data` | 56 blush |
| CTA ghost | `Sign out` | 48, 15 px |

## A6a View my data (no prototype — `proposed`)

| element | copy | notes |
|---|---|---|
| eyebrow | `Crew account` | reuse E1 layout read-only |
| headline | `My data` | |
| body | `This is what the admin will review. You can edit it if changes are requested.` | D-01 |
| rows | `Full name`, `Email`, `Phone`, `Date of birth`, `Branch`, `Home address` | no roles block while pending |

## A7 Verification · not approved

| element | copy | notes |
|---|---|---|
| pill | `Not approved` | |
| headline | `Your profile needs changes.` | 40 px |
| body | `Update the details below and submit again. Your account stays inactive until it's approved.` | |
| note eyebrow | `Note from admin` | ink |
| note body | `"{verification_note}"` | 17 px, straight double quotes |
| note meta | `{BRANCH} BRANCH · {reviewed_at:d MMM yyyy}` uppercased | |
| CTA primary | `Edit profile` | 56 ink → `/profile/edit` |
| CTA ghost | `Sign out` | 48 |
| E2 CTA in rejected context | `Submit again` | `proposed` |

## B1 Home

| element | copy | notes |
|---|---|---|
| bell | — | 44 circle; unread dot when `unread_count > 0` (TASK-019) |
| greeting | `Greetings, {first_name}!` | 17 px muted; the exclamation mark **is** in the prototype |
| headline (has next shift) | `Your next shift is in {days} days.` | 40 px |
| headline variants | `Your next shift is tomorrow.` / `Your next shift is today.` / `Nothing scheduled yet.` | `proposed` |
| hero pill | `Selected` | ink pill |
| hero eyebrow | `As {position.role.name}` | `position = assigned ?? applied` (D-09) |
| hero date | `{dd}` + `{MMM}` / `{EEE}` | 88 px + 12/600 |
| hero title | `{event.title}` | 22/500 |
| hero meta | `{start}–{end} · {VENUE_NAME}` | 11/500 0.04em uppercase |
| ~~hero briefing~~ | ~~`Briefing {briefing_time}`~~ | **removed by D-14** — do not render |
| hero button | `Inspect` | 44 ink pill, 14/500, arrow-up-right 16 |
| counter 1 eyebrow | `Waiting` | D-04 (not `Tracked`) |
| counter 1 numeral | `{waiting_count:02}` | 44/400 |
| counter 1 sub | `applications pending` | |
| counter 2 eyebrow | `Worked` | |
| counter 2 numeral | `{worked_count:02}` | |
| counter 2 sub | `since {worked_since:MMM yyyy}` | null → `no events yet` `proposed` |
| section title | `Open for you` | 22/500 |
| section link | `View list` | 14/500 → Events › Open |
| carousel card | `{EEE dd MMM}` · `{title}` · `{start}–{end} · {venue_name}` · `{deadline}` | `EventCard.compact` |
| deadline chip rules | `{n} days left` / `1 day left` / `Last day` / `Apply by {d MMM}` | `AppDates.deadline` |
| refresh error toast | server `message` | data stays |

## B2 Home · loading

No text. Skeletons: 44 circle (bell), 130×16 pill, 300×36 r12, 190×36 r12, hero 290 r40 blush .7, two 132 r32 white + line border.

## B3 Home · empty

| element | copy | notes |
|---|---|---|
| greeting | `Greetings, {first_name}!` | |
| headline | `You're verified and ready.` | |
| roles card title | `Roles assigned` | 15/500, 40 ink circle + check |
| roles card sub | `{ROLE} · {ROLE} · {BRANCH}` | 11/500 0.04em |
| empty eyebrow | `Open for you · 00` | ink |
| empty headline | `No open events yet.` | 28/500 |
| empty body | `When an admin publishes an event that matches your roles, it shows up here and you'll get a notification.` | 15 ink on blush |

## C1 Events · open

| element | copy | notes |
|---|---|---|
| eyebrow | `{meta.total} open · {branch.name}` | D-10 |
| headline | `Events` | 40 px |
| search placeholder | `Search events or venues` | 52 pill |
| tab | `Open` + count `{open_total:02}` | `Open 03` |
| tab | `Tracked` + count `{tracked_total:02}` | `Tracked 04` |
| card date | `{EEE dd MMM}` | ink eyebrow |
| card deadline (urgent) | `{deadline}` | blush small pill + clock |
| card deadline (calm) | `{deadline}` | outlined small pill |
| card title | `{title}` | 22/500 |
| card meta | `{start}–{end} · {venue_name}` | 14 px |
| position chips | `{role.name}` | only `matches_my_role` |

## C2 Events · tracked

| element | copy | notes |
|---|---|---|
| eyebrow | `{meta.total} applications` | singular `1 application` `proposed` |
| intro | `Monitor your applications and selection results.` | 15 muted |
| card title | `{event.title}` | 17/500 |
| card meta | `{EEE dd MMM} · AS {POSITION}` | 11/500 uppercase |
| pill | `Waiting` / `Selected` / `Not selected` | small pills |
| bar labels | `Applied` · `Closes {d MMM}` · `Result` | filled: waiting = 1, decided = 3 |
| empty headline | `You haven't applied to any events.` | `proposed` |
| empty body | `Applications you send will appear here with their status.` | `proposed` |
| empty action | `Browse open events` | `proposed` → Open tab |

## C3 Event detail · open

| element | copy | notes |
|---|---|---|
| header eyebrow | `{branch.name} branch` | |
| headline | `{title}` | 36 px |
| date hero | `{dd}` + `{MMM yyyy}` / `{EEEE}` | |
| time row | `{start}–{end} · {duration_hours} hours` | singular `1 hour` `proposed` |
| venue row | `{venue_name}` / `{venue_address}` | |
| deadline card title | `Apply by {EEE, d MMM} · {HH:mm}` | hourglass icon |
| deadline card sub | `{N} DAYS LEFT` | `1 DAY LEFT` / `LAST DAY` `proposed` |
| section | `Positions` | 20/500 |
| position row | `{role.name}` / `Matches your role` / `{needed:02} NEEDED` | |
| position row (locked) | `{role.name}` with lock 14 / `Not one of your roles` / `{needed:02} NEEDED` | row muted |
| section | `Requirements` | |
| requirement chips | `{requirements[]}` | |
| description | `{description}` | |
| CTA | `Apply` | 56 ink |
| footnote | `Can't make it? You don't need to do anything.` | 13 muted centred |
| footnote `date_conflict` | `You're already booked on this date.` | `proposed`; button disabled |
| footnote `no_matching_role` | `None of these positions match your roles.` | `proposed`; button disabled |

## C4 Apply · choose position (bottom sheet)

| element | copy | notes |
|---|---|---|
| sheet eyebrow | `{EEE dd MMM} · {start}–{end}` | |
| sheet title | `Apply as` | 28/500 |
| option | `{role.name}` / `{needed:02} NEEDED` | |
| note | `You can withdraw until {EEE, d MMM} · {HH:mm}.` | 13 muted |
| CTA | `Send application` | 56 ink |
| single-position variant | title `Apply as {role.name}` | `proposed` |

## C5 Event detail · applied

| element | copy | notes |
|---|---|---|
| status pill | `Waiting for selection` | white pill on blush |
| status title | `Applied as {applied_position.role.name}` | 20/500 |
| bar labels | `{applied_at:d MMM HH:mm}` · `Closes {closes_at:d MMM}` · `Result` | 1 of 3 filled |
| status body | `You'll get a notification when the admin picks the crew.` | 14 px ink |
| date row | `{EEEE, d MMMM yyyy}` / `{start}–{end} · {duration_hours} hours` | |
| CTA | `Withdraw application` | 56, ink outline (`outlinedInk`) |
| toast | `Application sent` / `Applied as {role.name} for {event.title}.` | title + description |

## C6 Withdraw · confirm (bottom sheet)

| element | copy | notes |
|---|---|---|
| title | `Withdraw application?` | 28/500 |
| body | `You can apply again until {EEE, d MMM} · {HH:mm}.` | |
| CTA primary | `Withdraw` | 56 ink |
| CTA ghost | `Keep application` | 48 |
| success toast | `Application withdrawn` / `You can apply again until {EEE, d MMM} · {HH:mm}.` | `proposed` |

## C7 Event detail · closed, waiting

| element | copy | notes |
|---|---|---|
| status pill | `Waiting for selection` | blush on white |
| bar labels | `{applied_at:d MMM HH:mm}` · `Closed {closes_at:d MMM}` · `Result` | past tense; 2 of 3 filled |
| lock note | `Applications closed. This can't be changed now.` | lock 16, 14 muted |
| action | — | none |

## C8 Event detail · selected

| element | copy | notes |
|---|---|---|
| hero pill | `Selected` | |
| hero headline | `You're on the crew.` | 36 px |
| hero body | `Confirmed as {position.role.name} for {event.title}. It's now in your schedule.` | |
| date row | `{EEEE, d MMMM yyyy}` / `{start}–{end} · BRIEFING {briefing_time}` | omit ` · BRIEFING …` when null |
| notes eyebrow | `Notes from admin` | hide block when `admin_note` null |
| notes body | `{admin_note}` | |

## C9 Event detail · not selected

| element | copy | notes |
|---|---|---|
| pill | `Not selected` | outlined 28 |
| body | `All positions for this event have been filled. Thanks for applying as {applied_position.role.name}.` | 16 px ink |
| date row | `{EEEE, d MMMM yyyy}` / `{start}–{end}` | no duration |
| CTA | `Browse open events` | 56 blush → Events › Open |

## C10 Events · empty

| element | copy | notes |
|---|---|---|
| eyebrow | `0 open · {branch.name}` | |
| empty headline | `No open events right now.` | 28/500; compass icon |
| empty body | `New events for your roles will show up here. You'll also get a notification.` | 15 muted |
| action | — | none |

## D1 Schedule · upcoming

| element | copy | notes |
|---|---|---|
| eyebrow | `Confirmed shifts` | |
| headline | `Schedule` | |
| tabs | `Upcoming` / `History` | |
| month header | `{MMMM yyyy} · {n} events` | `1 event` `proposed` |
| rail | `{dd}` / `{EEE}` | 36/500 + 11/600 |
| next card eyebrow | `Next · in {days} days` | `Next · tomorrow` / `Next · today` `proposed` |
| later card eyebrow | `Confirmed` | muted |
| card title | `{event.title}` | 18/500 |
| card meta | `{start}–{end} · {venue_name}` | |
| position chip | `as {position.role.name}` | natural case, 26 h |

## D2 Schedule · history

| element | copy | notes |
|---|---|---|
| counter numeral | `{worked_count:02}` | 64/400 |
| counter text | `events worked` ⏎ `since {worked_since:MMM yyyy}` | null → `events worked` only |
| row title | `{event.title}` | 15/500 |
| row meta | `{EEE dd MMM} · {POSITION}` | no "AS" here |
| pill | `Completed` / `Not selected` | small |
| empty headline | `No history yet.` | `proposed` |
| empty body | `Completed shifts and past applications will appear here.` | `proposed` |

## D3 Schedule · empty

| element | copy | notes |
|---|---|---|
| empty headline | `No confirmed events.` | 28/500; calendar-check icon |
| empty body | `Events you're selected for will appear here. Pending applications stay in Events › Tracked.` | `›` U+203A |
| action | `Browse events` | 48 blush → Events › Open |

## E1 Profile

| element | copy | notes |
|---|---|---|
| eyebrow | `Crew account` | |
| headline | `Profile` | |
| avatar | `{initials}` | image when `avatar_url` set |
| name / email | `{name}` / `{email}` | 22/500 / 14 muted |
| badge | `Verified` | |
| badge | `{branch.name} branch` | sunken 28 pill, uppercase |
| roles eyebrow | `Roles · set by admin` | |
| role chips | `{roles[].name}` | blush 30 h natural case |
| row | `Phone` / `{phone}` | shown as stored for v1 |
| row | `Date of birth` / `{d MMMM yyyy} · {Gender}` | |
| row | `Home address` / `{address}` | |
| action row | `Edit profile` / `Change password` | chevron-right |
| button | `Sign out` | 52, white, line border, error-red text, log-out icon 18 |
| sign-out sheet | `Sign out?` / `You'll need your email and password to sign back in.` / `Sign out` / `Stay signed in` | **confirmed** — bottom sheet (plan §2.7) |

## E2 Edit profile

| element | copy | notes |
|---|---|---|
| header title | `Edit profile` | 17/500 next to back circle |
| avatar | `{initials}` | 72 blush |
| button | `Change photo` | 44 outlined, camera 16 |
| fields | `Full name` · `Email` (read-only) · `Phone` · `Date of birth` · `Gender` · `Branch` · `Home address` | |
| ~~info note~~ | — | removed by D-08 |
| CTA | `Save changes` | 56 ink; rejected flow: `Submit again` |
| success toast | `Profile updated` / `Your changes are saved.` | `proposed` |

## E3 Change password

| element | copy | notes |
|---|---|---|
| headline | `Change password.` | 36 px |
| body | `You'll stay signed in on this phone.` | |
| field | `Current password` | placeholder `Enter current password` |
| link | `Forgot password?` | 14/500 right-aligned |
| field | `New password` | placeholder `At least 8 characters` |
| field | `Confirm new password` | placeholder `Type it again` |
| rules | `At least 8 characters` / `Contains a number` / `Both new passwords match` | live, 22 px check circles |
| CTA | `Update password` | disabled until all rules pass |
| success toast | `Password updated` / `You're still signed in on this phone.` | `proposed` |

## A2b Forgot password (no prototype — `proposed`)

| element | copy |
|---|---|
| eyebrow | `Crew account` |
| headline | `Reset your password.` |
| body | `Enter the email you registered with and we'll send you a link.` |
| field | `Email` — placeholder `name@email.com` |
| CTA | `Send link` |
| CTA ghost | `Back to sign in` |

## A2c Check your email (no prototype — `proposed`)

| element | copy |
|---|---|
| headline | `Check your email.` |
| body | `If {email} is registered, we've sent a link to reset your password. The link works for 60 minutes.` |
| CTA primary | `Back to sign in` |
| CTA ghost | `Resend` → `Resend in {seconds}s` (60 s cooldown, D-02) |
| resend toast | `Link sent again` |

## A2d Reset password (no prototype — `proposed`)

| element | copy |
|---|---|
| headline | `Choose a new password.` |
| body | `Use it to sign in on every device.` |
| fields | `New password` / `Confirm new password` + rules card as E3 |
| CTA | `Update password` |
| success toast | `Password updated` / `Sign in with your new password.` |
| expired headline | `This link has expired.` |
| expired body | `Reset links work for 60 minutes. Request a new one to continue.` |
| expired CTA | `Request new link` |

## N1 Notifications (no prototype — `proposed`, C2 list pattern per D-06)

| element | copy | notes |
|---|---|---|
| back | — | circle back (root-level route, no nav) |
| eyebrow | `{unread_count} unread` / `All caught up` | |
| headline | `Notifications` | 40 px |
| action link | `Mark all read` | 14/500, hidden when 0 unread |
| group header | `Today` / `Earlier` | eyebrows |
| row title | `{title}` | server-provided (`You're selected`, `New event for you`, `Application sent`, `Not selected this time` in mock); 17/500; unread = ink dot 8 |
| row body | `{body}` | e.g. `Arunika annual gathering · 5 Oct · Crew` |
| row time | `{created_at}` relative | `2 h ago` / `Yesterday` / `{d MMM}` |
| empty headline | `No notifications yet.` | |
| empty body | `Selection results and new events for your roles will show up here.` | |
