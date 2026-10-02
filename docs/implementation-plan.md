# Penta Crew — Implementation plan v1

Dokumen pusat eksekusi. Dibaca **setiap worker** sebelum mengerjakan ticket.
Keputusan produk ada di [`decisions.md`](decisions.md) (D-xx), bentuk data di
[`api-contract.md`](api-contract.md) (§x.y), layout & copy di
[`prototype/screens.html`](prototype/screens.html) (id screen `A1`…`E3`).
Dokumen ini **tidak mengulang** isi ketiganya — ia menyatakan *bagaimana*
keputusan itu dipetakan ke kode, dan *urutan* pengerjaannya.

Status: 2 Okt 2026 · fondasi theme/widget selesai (D-12) · backend belum ada.

---

## 1. Scope v1

Semua 26 screen prototype + 1 screen tambahan (Notifications, D-06) + 3 screen
forgot/reset password (D-02). Tidak termasuk: "Can't attend", reminder H-1,
dark mode, i18n (lihat §2.1).

| Area | Screen prototype | Feature folder |
|---|---|---|
| Splash, Sign in, Create account 2 langkah, Forgot/Check email/Reset | A1–A5, A2b–A2d (tidak ada di prototype) | `features/auth` |
| Verification pending / not approved, View my data | A6, A7 | `features/verification` |
| Home + loading + empty | B1–B3 | `features/home` |
| Events Open/Tracked, detail 6 state, apply, withdraw, empty | C1–C10 | `features/events` |
| Schedule upcoming/history/empty | D1–D3 | `features/schedule` |
| Profile, Edit profile, Change password, avatar | E1–E3 | `features/profile` |
| Notifications list + badge + push routing | — (ikuti pola C2) | `features/notifications` |

---

## 2. Keputusan teknis yang mengikat (D-13)

### 2.1 Bahasa UI: **English**
Mengikuti prototype. Default bahasa Indonesia di boilerplate (`AppMessages`,
`EmptyView.message`, `ErrorView.retryLabel`, copy di splash/login/forbidden,
`app_router` errorBuilder) diganti English. Tidak ada ARB/i18n di v1 —
string literal di widget, copy diambil **persis** dari `prototype/screens.html`
(cari berdasarkan id screen). Copy untuk state yang tidak ada di prototype
(Notifications, forgot/reset) mengikuti nada yang sama: kalimat pendek,
headline editorial, tanpa tanda seru.

### 2.2 Mock backend dev-only
Backend belum ada. App harus bisa dijalankan dan diverifikasi visual tanpa
backend, dan worker harus bisa menguji flow (apply → muncul di Tracked).

- `lib/core/network/mock/` — `MockInterceptor` (Dio `Interceptor`,
  `onRequest` → `handler.resolve(Response)`) + `MockServer` (state in-memory
  + fixtures sebagai **Dart const**, bukan asset — supaya tree-shaken di
  release). Mengimplementasikan **semua** endpoint §2–§6 kontrak termasuk
  aturan bisnis (`date_conflict`, `deadline_passed`, `already_applied`,
  `not_verified`), paginator, dan `meta.summary` / `meta.unread_count`.
- Dipasang di `buildDio` **hanya** jika `Env.useMock`
  (`bool.fromEnvironment('USE_MOCK')`; `env/dev.json` → `true`,
  `env/prod.example.json` → `false`). Latensi acak 300–800 ms agar skeleton
  terlihat.
- Persona login (password semua `password1`):
  `nadia@example.com` (approved, roles Crew + Event Manager, branch Jakarta,
  punya 1 selected, 2 waiting, 1 not_selected, 6 completed — sesuai angka di
  B1/D2), `pending@example.com` (A6), `rejected@example.com` (A7 dengan
  catatan admin). Email lain / password salah → `401 invalid_credentials`.
- Dataset event mengikuti mock data di `prototype/screens.html` (Arunika
  annual gathering, dll.) supaya screenshot bisa dibandingkan 1:1.

### 2.3 Penempatan model & batas antar-feature
Boilerplate: `core/` tidak mengimpor `features/` (kecuali `locator.dart` dan
`app_router.dart`). Tambahan untuk app ini:

- Model **dimiliki feature pemilik endpoint-nya**: `User`/`Branch`/`CrewRole`
  → `auth/models`; `Event`/`EventPosition`/`EventDetail`/`Application` →
  `events/models`; `AppNotification` → `notifications/models`.
- Feature **boleh** mengimpor feature lain: `models/`, `usecases/`,
  `<feature>_routes.dart` (konstanta path), dan `presentation/widgets/`
  (mis. `EventCard`). Feature **tidak boleh** mengimpor `repositories/` atau
  `presentation/cubit/` feature lain. Satu-satunya cubit lintas-feature
  adalah `AuthCubit` (sumber `User`).
- Home (D-05) memanggil usecase milik `schedule`, `events`, `notifications`
  — bukan repository-nya.

### 2.4 Session, verifikasi, dan guard (D-01)
- `SessionInfo` ditambah `bool get isVerified`
  (`isAuthenticated && user.verificationStatus == approved`).
- `guard({requireAuth = true, requireVerified = true, …})`: authenticated
  tapi `!isVerified` → `AppRoutes.verification`. `guard(requireVerified: false)`
  untuk rute yang boleh diakses saat pending/rejected: `/verification`,
  `/verification/data`, `/profile/edit`. Verified user yang membuka
  `/verification` → `AppRoutes.home`.
- Rute publik tanpa guard sama sekali: `/forgot-password`, `/check-email`,
  `/reset-password` (D-02: boleh dibuka saat login).
- Setelah login/register sukses → `context.go(home)`; guard yang membelokkan
  ke `/verification` bila perlu. Tidak ada percabangan status di `LoginCubit`.

### 2.5 Navigasi & shell
- `StatefulShellRoute.indexedStack` di `core/router/app_shell.dart` dengan 4
  branch: `/home`, `/events`, `/schedule`, `/profile`. `FloatingPillNav`
  di-overlay 20 px dari sisi, di atas safe area bawah (prototype).
- **Hanya 4 tab root yang di dalam shell.** Semua halaman lain (detail event,
  edit profile, change password, notifications, verification, auth) adalah
  rute root-level (`parentNavigatorKey: rootNavigatorKey`) → tampil tanpa
  nav, dengan header back seperti prototype C3/E2.
- Konstanta path: `AppRoutes` (core) hanya menambah `verification`;
  tiap feature mendeklarasikan `abstract final class <Feature>Routes` di
  `<feature>_routes.dart` (`root`, `detail(id)`, …). Lintas-feature
  menavigasi lewat konstanta itu, tidak pernah string literal.

### 2.6 Error bisnis
`Failed` ditambah `String? code` (dari body `code`, kontrak §0). Cubit
mencabangkan pada `code`, bukan pada `message`. `message` dari server
ditampilkan apa adanya.

### 2.7 Pola presentasi (mengikuti `features/sample` + D-05)
- Cubit per halaman, disediakan di route builder via `sl<T>()`; state freezed
  sealed (`initial | loading | loaded | error`). List berhalaman memakai pola
  `SampleListCubit` (loadMore, refresh, error-with-data → toast).
- Multi-seksi (Home): satu cubit, state per seksi `Section<T>`
  (`loading | loaded(T) | error(msg)`), request paralel, skeleton per seksi.
- Loading list = `Skeleton` sesuai bentuk kartu (B2), bukan spinner.
- Aksi mutasi (apply/withdraw/save) = `AppButton(busy: true)` + nonaktifkan
  input; sukses → `showAppToast` + navigasi/refresh; gagal → toast `message`.
- Konfirmasi destruktif (withdraw, sign out) = bottom sheet radius 40 (C6).

### 2.8 Definisi selesai per ticket
1. `fvm flutter analyze` → *No issues found*.
2. `fvm flutter test` hijau; **tiap cubit baru punya bloc_test**, tiap screen
   punya widget test minimal untuk state loading/empty/error/loaded.
3. Dijalankan di simulator dengan `USE_MOCK=true`
   (`make run-dev`), screenshot screen yang dikerjakan dilampirkan ke ticket
   (`kanban_attach_file`) berdampingan dengan id screen prototype.
4. Tidak menyentuh file di luar folder yang dinyatakan ticket, kecuali yang
   disebut eksplisit.
5. Tidak ada `print`, tidak ada dependency baru tanpa persetujuan di ticket.
6. Commit per ticket, pesan Conventional Commits.

---

## 3. Urutan & paralelisme

```
Wave 0 (selesai)  theme/widget, docs, repo
Wave 1            [T1 Foundation] ──┐    [T2 inv: deep link]   [T3 inv: UX gap audit]
                                    │
Wave 2 (paralel)  ┌─────────────────┼──────────────┬──────────────┬─────────────┐
                  [T4 Auth]   [T5 Verif+Profile]  [T6 Events]  [T7 Schedule]  [T8 Home]
                                                                                   │
Wave 3            [T9 Notifications] ◄─────────────────────────────────────────────┘
Wave 4            [T10 inv: visual QA vs prototype] → fix tickets bila perlu
```

**Kenapa T1 tunggal dan besar:** semua yang *dibagi* antar feature
(model, repository, usecase, DI, guard, shell, path, mock) ditulis oleh satu
tangan agar wave 2 tidak saling konflik di `locator.dart`, `app_router.dart`,
`user.dart`, atau model bersama. Setelah T1, tiap ticket wave 2 **hanya
menyentuh folder feature-nya sendiri** (+ `<feature>_di.dart` dan
`<feature>_routes.dart` miliknya).

**Kepemilikan file wave 2** (tidak boleh tumpang tindih):

| Ticket | Folder yang boleh diubah |
|---|---|
| T4 Auth | `features/auth/**` (kecuali `models/`), `ios/Runner/*.entitlements`, `Info.plist`, `AndroidManifest.xml` untuk deep link |
| T5 Verif+Profile | `features/verification/**`, `features/profile/**` |
| T6 Events | `features/events/**` (kecuali `models/`, `repositories/`, `usecases/` — tambah usecase baru boleh) |
| T7 Schedule | `features/schedule/**` |
| T8 Home | `features/home/**` |
| T9 Notifications | `features/notifications/**`, + 1 edit kecil `home_screen.dart` (badge bell) |

Butuh perubahan di luar itu (mis. widget core baru)? Laporkan di ticket,
jangan ubah diam-diam — Lead yang memutuskan.

---

## 4. Rincian ticket

### T1 · Foundation (Wave 1, critical path)
Deliverable, berurutan (sub-task):
1. **English copy + `Failed.code` + `Paginated.meta`** — §2.1, §2.6;
   `Paginated<T>` menyimpan `meta` mentah agar `summary`/`unread_count`
   bisa dibaca feature.
2. **Model** (freezed, snake_case global via `build.yaml`):
   `User` diperluas sesuai kontrak §1 (`VerificationStatus`, `Gender` enum,
   `Branch`, `List<CrewRole>`, tanggal via `DateOnlyConverter`);
   `Event`, `EventPosition`, `EventDetail` (kelas terpisah + `toSummary()`),
   `Application` (+`ApplicationStatus`, `ApplicationPosition`),
   `CannotApplyReason`, `AppNotification` (+`NotificationType` dengan
   `unknownEnumValue`). Semua enum punya fallback agar nilai baru dari
   backend tidak men-crash parser.
3. **Repository + usecase + `<feature>_di.dart`** untuk `auth` (§2.2,
   2.5–2.11, 3.1), `events` (§4.1–4.5), `schedule` (§5), `notifications`
   (§6). Pure HTTP, satu method = satu endpoint. Didaftarkan di
   `locator.dart`. Belum ada cubit (wave 2).
4. **Session/guard/shell** — §2.4, §2.5. Placeholder screen untuk
   `/events`, `/schedule`, `/profile`, `/verification` (teks nama screen
   saja) agar app bisa dinavigasi. `AuthCubit.isVerified`.
5. **Mock backend** — §2.2 lengkap.
6. **Widget bersama yang butuh model:** `ProgressTimeline`
   (`core/widgets`, generik: langkah done/current/upcoming — A6, C5) dan
   `EventCard` (`features/events/presentation/widgets`, varian list C1 dan
   compact carousel B1, dari markup prototype).
7. **Tes + README:** model `fromJson` terhadap sampel JSON kontrak,
   repository via `HttpClientAdapter` stub (termasuk `code`), guard
   verifikasi, smoke test `MockInterceptor` (login → me → apply → tracked),
   README "Running without a backend".

### T2 · Investigasi: deep link reset password (Wave 1, paralel)
Hasil: isi persis `Runner.entitlements` (`applinks:`),
`Info.plist` (`FlutterDeepLinkingEnabled`), `intent-filter`
`autoVerify`, kedua file `.well-known` dengan placeholder (Team ID,
`applicationId`, SHA-256) + cara mendapatkannya, perilaku go_router pada
cold/warm start, dan perintah uji (`xcrun simctl openurl`, `adb shell am
start`). Dipakai sebagai lampiran T4 dan jawaban §7.1 kontrak.

### T3 · Investigasi: audit gap widget & copy vs prototype (Wave 1, paralel)
UI/UX Reviewer membandingkan `core/theme` + `core/widgets` dengan
`prototype/screens.html` (ukuran, radius, spacing, warna, tipografi,
touch target) dan menyusun **tabel copy English** per screen (headline,
body, CTA, empty/error) agar 5 worker wave 2 memakai copy yang sama.
Temuan BLOCKER masuk T1 bila masih berjalan, sisanya dilampirkan ke ticket
feature terkait.

### T4 · Auth screens (Wave 2)
Sub-task: (a) Sign in rebuild A2/A3 di atas widget baru, error inline, email
dipertahankan; (b) Create account A4→A5 (`RegisterCubit` 2 langkah, validasi
per langkah, `GET /branches` dropdown, 422 `errors` → field, sukses →
`AuthCubit.setAuthenticated` → `go(home)`); (c) Forgot/Check email/Reset
(D-02) + wiring deep link dari T2 (`APP_DOMAIN` dari `Env`). Splash A1
disesuaikan visualnya.

### T5 · Verification + Profile (Wave 2)
Sub-task: (a) A6 pending (timeline `ProgressTimeline`, "View my data",
Sign out), A7 rejected (catatan admin, "Edit profile" → `/profile/edit`,
"Submit again" = 2.7 lalu 3.1); (b) E1 Profile read-only (dari
`AuthCubit.user`, badge Verified), E2 Edit profile (D-08: tanpa peringatan
re-review; `updateUser` setelah sukses), E3 Change password (rule live), avatar
`POST /me/avatar` (`image_picker` **sudah/belum** ada? — kalau belum, ini
dependency baru → tanyakan Lead sebelum menambah), Sign out dengan konfirmasi.

### T6 · Events (Wave 2, long pole)
Sub-task: (a) C1 Open (header "N open · Branch" dari `meta.total`, sort
deadline, chip posisi match, pill urgent, search), C2 Tracked (semua status
aktif, timeline Applied → Closes → Result), C10 empty, `SegmentedTabs`;
(b) C3–C9 detail 6 state dari `EventDetail.status` + `my_application` +
`can_apply`/`cannot_apply_reason`, C4 pilih posisi (bottom sheet, posisi tak
match terkunci), C6 withdraw confirm, C8 "Notes from admin" + briefing.
Setelah apply/withdraw: refresh detail dan kirim sinyal agar Tracked/Home
refresh saat kembali (cukup `refresh()` di `didPopNext`/on return — tidak
perlu event bus).

### T7 · Schedule (Wave 2)
D1 Upcoming (grup per bulan di client, item pertama "Next"), D2 History
(counter "06 events worked since Jul 2026" dari `meta.summary`, label
Completed/Not selected dari D-07), D3 empty dengan copy yang mengarahkan ke
Events › Tracked. Tap item → `EventsRoutes.detail(id)`.

### T8 · Home (Wave 2)
B1 dengan `HomeCubit` per-seksi (D-05): greeting + roles dari `AuthCubit`;
next shift; counter WAITING (D-04, copy final diputuskan di sini dan dicatat
ke D-04); counter worked; carousel Open for you (`EventCard` compact). B2
skeleton per seksi, B3 empty. Bell icon → `NotificationsRoutes.root`
(badge ditambahkan T9). Pull-to-refresh menembak ulang semua seksi.

### T9 · Notifications (Wave 3, blocked by T1 + T8)
List berhalaman (pola C2, grup Today/Earlier, dot unread), tap → mark read →
navigasi sesuai `type` (D-06 tabel), read-all, badge unread di bell Home
(`GET /notifications/unread-count` saat Home tampil/resume), routing tap push
dari `PushService.onMessageOpened` dan `getInitialMessage` memakai handler
yang sama, `onTokenRefresh` → `PUT /me/device-token`.

### T10 · Investigasi: visual QA (Wave 4)
UI/UX Reviewer menjalankan app mock di simulator, screenshot 26+4 screen,
bandingkan dengan prototype, laporkan BLOCKER/ISSUE/SUGGESTION per screen →
Lead membuka fix ticket.

---

## 5. Risiko yang diketahui

- **Kontrak belum dikonfirmasi backend.** Semua parsing lewat model freezed +
  enum fallback, jadi perubahan nama field = perubahan 1 file model + fixture.
- **Font runtime-fetch** (D-12): offline pertama kali → fallback font sistem.
  Keputusan bundling TTF ditunda sampai QA visual.
- **`image_picker`** untuk avatar belum ada di `pubspec.yaml` → keputusan
  dependency saat T5.
- **D-08 REVISIT** tetap terbuka; tidak menghambat v1.
