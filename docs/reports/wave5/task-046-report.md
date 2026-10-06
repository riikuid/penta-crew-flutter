# TASK-046 — Fix foundation_smoke_test

Branch `wave5/task-046` (test(smoke): fix sign-in typing and sign-out lookup).

## What changed
- `integration_test/foundation_smoke_test.dart`: sign-in taps each field and waits 1 s before `enterText`, then unfocuses; `signOut` matches on the `Sign out` label (A6/A7 are a ghost TextButton, E1 an icon OutlinedButton whose runtime type is private, so type finders miss it), scrolls it into view on E1 (lazy list, below the fold), confirm is the last label while the sheet is open.

## Verification
- make analyze: see commit run / make test: no lib changes
- device: iPhone 16 Pro sim (PentaQA-16Pro), USE_MOCK=true, `flutter drive` twice, each "All tests passed!" (+2). Keychain reset before each run (`xcrun simctl keychain <udid> reset`); without it a persisted session skips the sign-in screen and the first signIn fails.
- Screenshots in `build/screenshots/` (gitignored).

## Risks / follow-ups
- Disk was ~100% full during the work (build dir had to be deleted to resolve SPM packages).
- Mock-session persistence still requires the keychain reset between runs.
