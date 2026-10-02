# Penta Crew — Catatan keputusan produk & arsitektur

Sumber: prototype v2 (`Crew App Screens`, 27 screen A–E) + diskusi 2 Okt 2026.
Setiap keputusan diberi nomor supaya bisa dirujuk dari ticket/PR. Status
`REVISIT` = sudah diputuskan untuk v1, tapi sengaja ditandai untuk ditinjau lagi.

Kontrak endpoint yang mengikuti keputusan ini ada di [`api-contract.md`](api-contract.md).

---

## D-01 · Register langsung login, dibatasi `verification_status`

- `POST /register` mengembalikan `{ token, user }` seperti login.
- `user.verification_status` ∈ `pending | approved | rejected`.
- Router (`route_guard`): session ada **dan** status ≠ `approved` → selalu ke
  `/verification` (A6/A7). Home/Events/Schedule/Profile tidak bisa diakses.
  Dari sana user hanya bisa *View my data* (read-only), *Edit profile* (jika
  `rejected`), dan *Sign out*.
- Role crew **tidak dipilih user**; admin yang menetapkan saat review.

## D-02 · Forgot password masuk v1, via link email → deep link ke app

Flow:

1. **A2b Forgot password** — input email → `POST /forgot-password`. Respons
   selalu sukses (tidak membocorkan apakah email terdaftar).
2. **A2c Check your email** — konfirmasi, tombol "Back to sign in" dan
   "Resend" (cooldown 60 dtk di client).
3. Email berisi link `https://<APP_DOMAIN>/reset-password?token=…&email=…`
   (format bawaan Laravel password broker).
4. Tap link → OS membuka app → go_router me-route ke **A2d Reset password**
   (new password + confirm, rule yang sama dengan E3: ≥ 8 karakter, ada angka,
   match) → `POST /reset-password`.
5. Sukses → toast → kembali ke Sign in. Token kadaluarsa/invalid → pesan
   "Link sudah tidak berlaku" + tombol minta link baru.

Mekanisme deep link: **HTTPS Universal Links (iOS) + App Links (Android)**,
bukan custom scheme. Alasan: email client (Gmail, Mail) tidak reliably membuka
`pentacrew://…`, dan link HTTPS tetap bisa dibuka di browser jika app belum
terpasang. Konsekuensi untuk backend/infra (lihat kontrak §0):

- host `/.well-known/apple-app-site-association` dan
  `/.well-known/assetlinks.json` di `APP_DOMAIN`;
- halaman web fallback di `/reset-password` untuk device tanpa app.

Rute `/reset-password` harus bisa diakses **tanpa** session; jika user sedang
login dan membuka link, tetap tampilkan A2d (kasus langka, tidak perlu
diblokir).

## D-03 · `User` flat, sub-modul sebagai model terpisah

Backend **belum ada**, jadi kita yang mengusulkan bentuknya.

- Satu objek `User` dari `/me` berisi data akun + profil crew + field
  verifikasi (flat).
- Yang berdiri sendiri sebagai model: `Branch`, `CrewRole`
  (keduanya nested di `User`, dan `Branch` juga dipakai form register),
  `Event`, `EventPosition`, `Application`, `Notification`.
- `AuthCubit` yang ada tetap pemilik `User`; field baru ditambahkan ke model
  `User` yang sudah ada (bukan model `CrewProfile` terpisah).

## D-04 · Definisi "Tracked" dan nasib application yang di-withdraw

- Tab **Tracked** (C2) = semua application aktif: `waiting | selected |
  not_selected`.
- Counter di **Home** (B1) = hanya `waiting`. Copywriting diganti supaya tidak
  bentrok dengan nama tab: label eyebrow `WAITING` (bukan `TRACKED`),
  sub-copy tetap "waiting for selection". Final copy dikunci saat implementasi
  Home.
- Application yang **di-withdraw tidak muncul** di Tracked, tidak dihitung di
  counter, dan tidak muncul di History.
- Default yang diusulkan (belum dikonfirmasi eksplisit, tandai jika keberatan):
  withdraw = backend set `status = withdrawn` (soft, untuk audit), dan user
  **boleh apply ulang** ke event yang sama selama deadline belum lewat.

## D-05 · Home dirakit client dari beberapa endpoint, paralel per-seksi

- Tidak ada endpoint agregat `/home`.
- Home menembak request secara bersamaan; setiap seksi punya state
  loading/loaded/error sendiri sehingga shimmer hilang per-seksi begitu
  responsnya datang (bukan menunggu semua).
- Seksi & sumbernya:
  | Seksi | Sumber |
  |---|---|
  | Greeting, roles (B3) | `AuthCubit.user` — tanpa request |
  | Next shift | `GET /schedule/upcoming?per_page=1` |
  | Waiting counter | `GET /applications?status=waiting&per_page=1` → `meta.total` |
  | Worked counter + since | `GET /schedule/history?per_page=1` → `meta.summary` |
  | Open for you | `GET /events?branch_id=&status=open&per_page=5` |
- Implementasi: satu `HomeCubit` dengan state per-seksi (`Section<T>`), bukan
  4 cubit; pola error "data tetap tampil, toast untuk kegagalan refresh" mengikuti
  `SampleListCubit`.

## D-06 · Notifikasi: ada halaman list sendiri + push

- Ikon bell di Home membuka **halaman Notifications** (screen baru, tidak ada
  di prototype — ikuti pola list C2: card per item, unread ditandai dot ink,
  grup "Today / Earlier"). Badge unread di ikon bell.
- Setiap kejadian di bawah membuat **record in-app** dan **push** sekaligus:

  | `type` | Trigger | Tap → |
  |---|---|---|
  | `verification.approved` | admin approve | Home |
  | `verification.rejected` | admin reject (+ catatan) | Verification (A7) |
  | `event.published` | event baru di branch user yang punya posisi match role | Event detail (C3) |
  | `application.submitted` | user berhasil apply | Event detail (C5) |
  | `application.selected` | admin pilih user | Event detail (C8) |
  | `application.not_selected` | admin tutup seleksi, user tidak terpilih | Event detail (C9) |

  Reminder H-1 sebelum event **tidak** masuk v1 (catat sebagai kandidat v1.1).
- Payload push `data` selalu memuat `type`, `notification_id`, dan
  `event_id`/`application_id` bila relevan — navigasi dari push dan dari list
  memakai handler yang sama.
- Device token: dikirim saat login (sudah ada), **ditambah** `PUT
  /me/device-token` untuk `onTokenRefresh`, dan backend menghapus token saat
  `/logout`.

## D-07 · "Completed" = selected dan tanggal event sudah lewat

- Tidak ada status kehadiran (attended / no-show) di v1.
- History (D2) = `selected` dengan `event.date < today` (label *Completed*)
  ∪ `not_selected` (label *Not selected*). Upcoming (D1) = `selected` dengan
  `event.date ≥ today`.
- `worked_count` = jumlah *Completed*; `worked_since` = tanggal event
  *Completed* pertama. Keduanya dihitung backend (`meta.summary`).

## D-08 · Edit profile bebas, tidak memicu re-review — `REVISIT`

- `PUT /me/profile` boleh mengubah semua field (termasuk nama, DOB, branch)
  tanpa mengubah `verification_status`; user tetap bisa apply event.
- Catatan prototype E2 *"Changing your name, date of birth or branch sends
  your profile back to admin review"* **dihapus** dari UI.
- **Kenapa ditandai REVISIT:** user yang sudah diverifikasi admin branch A
  bisa pindah sendiri ke branch B dan langsung melihat/apply event di sana,
  dan nama/DOB yang sudah dicek bisa berubah tanpa jejak. Kandidat
  pengetatan nanti: (a) branch hanya bisa diubah admin, (b) perubahan field
  identitas dicatat di activity log admin, atau (c) kembali ke aturan
  re-review seperti prototype. Keputusan ini sengaja dilonggarkan untuk v1
  agar onboarding tidak terhambat.

## D-09 · Role, posisi, dan aturan apply

- User bisa punya **lebih dari satu** `CrewRole`.
- Saat apply, user memilih **tepat satu posisi** dari posisi yang match
  role-nya (C4). Posisi yang tidak match ditampilkan terkunci.
- **Admin yang menentukan penempatan akhir** saat seleksi; boleh berbeda dari
  posisi yang di-apply. Karena itu `Application` punya dua field:
  `applied_position` (pilihan user) dan `assigned_position` (ditetapkan admin,
  `null` sebelum selected). UI "Selected as …" (C8/D1) memakai
  `assigned_position ?? applied_position`.
  > Ini interpretasi saya atas "keputusan admin untuk menempatkan user ke
  > role mana" — konfirmasi jika yang dimaksud lain.
- **Satu event per tanggal:** user tidak bisa apply ke event lain yang
  tanggalnya sama dengan event yang sudah dia apply (`waiting`) atau
  `selected`. Backend menolak dengan `422 code: date_conflict`; agar UI tidak
  mengandalkan error, `GET /events/{id}` mengembalikan `can_apply` +
  `cannot_apply_reason` sehingga tombol Apply bisa dinonaktifkan dengan pesan
  yang tepat sejak awal.
- Withdraw hanya sebelum `apply_deadline`; sesudahnya `422 code:
  deadline_passed`.

## D-10 · Event hanya dari branch user

- `GET /events` wajib `branch_id`; client mengirim `user.branch.id`. Backend
  tetap memvalidasi bahwa `branch_id` = branch user (bukan trust client).
- Header C1 "3 open · Jakarta" diambil dari `meta.total` + `user.branch.name`.

## D-11 · Scope

- Prototype v2 adalah final; tidak ada dokumen flow lain yang mengikat.
- "Can't attend" (dirujuk sebagai Flow 21 di prototype) **tidak** masuk v1.
- Avatar: E2 punya "Change photo" → `POST /me/avatar` masuk v1 (multipart).

## D-12 · Fondasi theme & widget (diimplementasikan 2 Okt 2026)

- **Light only.** Prototype tidak punya arah dark; `darkTheme` dihapus dan
  `themeMode` dikunci `light`. Dark mode = keputusan baru, bukan tugas theme.
- **Token di luar Material** (`core/theme/app_tokens.dart`, dibaca lewat
  `context.tokens`): 7 warna bernama + gaya editorial (`display`, `numeral`,
  `counter`, `eyebrow`, `caption`). Yang **memetakan** ke Material tetap di
  `ThemeData` (`ColorScheme`, `TextTheme`, button/input/card theme) agar
  widget stok langsung benar tanpa wrapper.
- **Pemetaan ColorScheme:** `primary`=ink, `secondaryContainer`=accent
  (sehingga `FilledButton` = tombol primer ink dan `FilledButton.tonal` =
  tombol sekunder blush tanpa widget khusus), `outline`=line,
  `onSurfaceVariant`=muted, `surfaceTint`=transparan (tidak ada tint M3).
- **Inter via `google_fonts` ^8** (runtime fetch + cache; fallback font sistem
  bila offline saat pertama buka). Dipin <9 karena v9 pindah ke tipe
  `material_ui` yang belum dipakai app ini. Upgrade ke bundling offline tanpa
  ubah kode: taruh TTF Inter di `assets/google_fonts/` dan daftarkan di
  `pubspec.yaml`. File woff2 dari prototype tidak bisa dipakai Flutter.
- **Status pill — koreksi dari analisis awal:** positif (`Selected`,
  `Verified`) = **isi ink + teks putih**, bukan blush. Blush dipakai untuk
  `Waiting`. `Not selected` = outline line + teks muted; `Not approved` =
  outline + teks error; `Completed` = isi background. Diambil langsung dari
  markup prototype (`template.html`), bukan dari ingatan.
- **Ikon:** Material Icons (`check`, `close`, `schedule`, `visibility`) sebagai
  pengganti ikon lucide prototype. Kalau ingin identik, tambah `lucide_icons`
  nanti — keputusan terpisah karena menambah dependency.
- **Inventaris widget inti** (`core/widgets/`): `AppButton`
  (primary/secondary/outlined/danger/ghost, 56/48, busy state),
  `Eyebrow`, `LabeledField` + `AppTextField` + `AppPickerField`,
  `StatusPill` (preset domain), `SegmentedTabs`, `FloatingPillNav`,
  `AppCard` (surface/accent/ink/sunken, radius 32/40), `Skeleton`
  (pulse, tanpa dependency), `EmptyView`/`ErrorView` bergaya kartu.
  Error field hanya lewat `InputDecoration.errorText` supaya error validator
  dan error server dari backend tampak identik.
- **Belum dibuat (menunggu model/feature):** `EventCard`, `ProgressTimeline`,
  shell dengan posisi nav (20px sisi, di atas home indicator).
- **Copy:** `EmptyView`/`ErrorView` masih memakai default bahasa Indonesia
  dari boilerplate, sedangkan prototype berbahasa Inggris. Bahasa UI final
  belum diputuskan → `REVISIT` saat screen pertama dibangun.

## D-13 · Eksekusi: bahasa UI, mock backend, batas antar-feature (2 Okt 2026)

Rincian operasional ada di [`implementation-plan.md`](implementation-plan.md) §2.

- **Bahasa UI: English**, mengikuti prototype; default Indonesia di boilerplate
  diganti. Tidak ada i18n/ARB di v1 (menutup `REVISIT` copy di D-12).
- **Mock backend dev-only** (`USE_MOCK` dart-define, `MockInterceptor` di Dio,
  fixtures sebagai Dart const agar tree-shaken di release) karena backend belum
  ada dan app harus bisa diverifikasi visual + flow-nya diuji. Tiga persona:
  approved / pending / rejected.
- **Model dimiliki feature pemilik endpoint**; feature boleh mengimpor
  `models/`, `usecases/`, `*_routes.dart`, dan `presentation/widgets/` feature
  lain, **tidak** `repositories/` atau `cubit/`-nya.
- **Shell:** hanya 4 tab root di dalam `StatefulShellRoute`; halaman lain
  root-level tanpa nav (sesuai prototype: detail punya header back, bukan nav).
- `Failed` ditambah `code` (kontrak §0) agar cubit mencabang pada kode stabil,
  bukan pada teks `message`.
- **Repo:** history boilerplate dipisah ke `riikuid/boilerplate-flutter-3-47`;
  `riikuid/penta-crew-flutter` dimulai dari satu commit snapshot boilerplate.

---

## Konsekuensi ke boilerplate (untuk dikerjakan saat implementasi, bukan sekarang)

- ~~`core/theme`: tambah `ThemeExtension` …~~ **selesai**, lihat D-12.
- `core/router/route_guard`: tambah cabang `verification_status != approved`
  → `/verification`, dan rute publik `/forgot-password`, `/reset-password`.
- `features/auth/models/user.dart`: tambah field D-03.
- `core/push`: `PushService` perlu callback `onMessageOpened(data)` dan
  `onTokenRefresh` agar D-06 bisa dirutekan tanpa Firebase bocor ke core.
- Feature baru mengikuti template `features/sample`: `events`, `applications`
  (Tracked + apply/withdraw), `schedule`, `notifications`, `profile`,
  `verification`; `home` yang ada diganti isinya.
- Platform: entitlement `applinks:<APP_DOMAIN>` (iOS) dan `intent-filter`
  dengan `android:autoVerify="true"` (Android) untuk D-02.
