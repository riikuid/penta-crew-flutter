# Penta Crew — Brief Admin Dashboard

Versi 1.1 · 15 Okt 2026 · Q1–Q8 diputuskan di D-15 · Untuk tim/agent yang mengeksekusi **admin dashboard
(web) + backend** di luar repo ini.

Repo ini adalah **mobile app crew** (Flutter). Backend belum ada; app saat
ini berjalan di atas mock in-memory yang mengimplementasikan kontrak API
secara penuh. Dokumen ini menurunkan **apa yang harus bisa dilakukan admin**
dari kontrak dan keputusan produk yang sudah mengikat di sisi mobile, supaya
dashboard dan backend yang kalian bangun langsung kompatibel dengan app.

## 0. Urutan baca

| File | Isi | Wajib? |
|---|---|---|
| **Dokumen ini** | Fitur admin, state machine, invariant, pertanyaan terbuka | ✓ |
| [`api-contract.md`](api-contract.md) | Model JSON + endpoint **mobile** (`/api/v1`). Backend kalian harus mengimplementasikan ini persis — mock di `lib/core/network/mock/` adalah implementasi referensinya | ✓ |
| [`decisions.md`](decisions.md) | D-01..D-14, alasan di balik aturan bisnis. Jangan kontradiksi diam-diam; usulkan D-xx baru | ✓ |
| `lib/core/network/mock/mock_server.dart` + `fixtures/mock_data.dart` | Aturan bisnis yang sudah dieksekusi (precedence `cannot_apply_reason`, `is_urgent`, `closed`, `meta.summary`) dan dataset yang dipakai QA mobile | Rujukan |
| [`prototype/screens.html`](prototype/screens.html) | Layar mobile A1..E3 — untuk melihat **dampak** aksi admin di sisi crew | Rujukan |
| [`copy-table.md`](copy-table.md) | Copy yang dilihat crew (mis. "An admin will check your data and assign your crew roles.") | Rujukan |

Yang **tidak** mengikat dashboard: design system mobile (D-12), struktur
folder Flutter, aturan AGENTS.md. Dashboard adalah produk terpisah; hanya
**data dan aturan bisnis** yang harus sama.

## 1. Domain dalam satu halaman

Entitas (bentuk JSON lengkap ada di kontrak §1):

- **Branch** `{id, name}` — cabang (Jakarta, Bandung, Surabaya). Semua
  event dan semua user terikat pada satu branch.
- **CrewRole** `{id, name}` — Crew, Event Manager, Trainee. User bisa punya
  lebih dari satu; **hanya admin yang menetapkan** (D-01, D-09).
- **User** (crew) — akun + profil + status verifikasi, flat (D-03).
- **Event** — satu tanggal, satu venue, satu branch, daftar **EventPosition**
  `{role, needed}`, `apply_deadline`, `status open|closed`, `admin_note`.
- **Application** — user ↔ event. `applied_position` (pilihan user) dan
  `assigned_position` (ditetapkan admin saat selected, boleh beda).
- **Notification** — record in-app + push FCM, dibuat backend pada setiap
  pemicu (§4 di bawah).

### 1.1 State machine

**User.verification_status**

```
register ──► pending ──admin approve (+roles ≥1)──► approved
                │
                └──admin reject (+note)──► rejected ──user "Submit again"──► pending
```

- Selama `pending`/`rejected`, app mengurung user di layar Verification
  (A6/A7); user tidak bisa melihat event. Semua endpoint event/schedule/
  notifications mengembalikan `403 not_verified` (kontrak §3).
- `rejected` → crew melihat `verification_note` kalian apa adanya (A7),
  boleh edit profil, lalu resubmit → `pending`, `submitted_at` baru,
  `verification_note` dikosongkan.
- Approve **wajib** menyertakan ≥ 1 role: Home crew menampilkan roles,
  dan tanpa role user tidak bisa apply apa pun (`no_matching_role`).

**Event.status**

```
draft ──publish──► open ──deadline lewat ATAU admin tutup──► closed
```

- App menganggap event **open** hanya jika `status == open` **dan**
  `now < apply_deadline`. Keduanya harus benar; `closed` manual sebelum
  deadline diperbolehkan (lihat pertanyaan terbuka Q5).
- `is_urgent` = `apply_deadline - now < 48 jam`, dihitung backend.
- `draft` hanya ada di dashboard (D-15 Q4); **jangan kembalikan** event
  draft ke endpoint mobile.

**Application.status**

```
apply ──► waiting ──admin select (+assigned_position)──► selected
             │                                              
             ├──admin tutup seleksi──► not_selected
             └──user withdraw (sebelum deadline)──► withdrawn
```

- `withdrawn` adalah soft state untuk audit (D-04). **Tidak pernah**
  dikembalikan ke mobile di `GET /applications`, history, atau counter.
  Di dashboard tampilkan, tapi pisahkan dari pelamar aktif.
- Setelah withdraw, user boleh apply lagi ke event yang sama selama masih
  open (D-04).
- `decided_at` diisi saat `selected` / `not_selected`.
- Label yang dilihat crew diturunkan dari status + tanggal (D-07):
  `selected` dan `event.date < today` → *Completed*; tidak ada status
  kehadiran (attended/no-show) di v1.

## 2. Fitur admin yang diturunkan dari kontrak

Setiap baris di bawah adalah aksi admin yang **secara eksplisit** disebut
kontrak/decisions sebagai pemicu sesuatu di app. Ini scope minimum v1.

| # | Fitur | Aksi | Efek di backend | Efek di app crew |
|---|---|---|---|---|
| F1 | **Antrian verifikasi** | List user `pending` per branch, urut `submitted_at ASC`; detail = semua field profil (nama, email, phone, DOB, gender, alamat, branch, `submitted_at`) | — | — |
| F1a | Approve | pilih ≥ 1 `CrewRole` | `verification_status=approved`, `roles=[…]`, `reviewed_at=now` → notif `verification.approved` | A6 → Home (B1) |
| F1b | Reject | tulis `verification_note` (wajib, kalimat untuk crew) | `verification_status=rejected`, `reviewed_at=now` → notif `verification.rejected` | A7 menampilkan note |
| F1c | Ubah roles user approved | edit roles | ubah `roles` | Home B1 roles, chip "matches your role" di C1 |
| F2 | **Event CRUD** | create/edit field `EventDetail` (§1): title, date, start/end time, venue name + address, branch, apply_deadline, briefing_time?, requirements[] (tag), description?, admin_note?, positions[] `{role, needed?}` (`needed` target, boleh kosong — D-15 Q2) | `duration_hours` dihitung dari start/end | — |
| F2c | Edit setelah publish | ubah tanggal/jam/venue | notif `event.updated` ke pelamar `waiting`/`selected` (D-15 Q6) | Event detail refresh |
| F2a | Publish | buat event terlihat | `status=draft→open` → notif `event.published` ke semua user **approved** di branch event yang punya ≥ 1 role match salah satu posisi | Muncul di C1 + carousel Home |
| F2b | Tutup seleksi / tutup event | tutup lebih awal (D-15 Q5) atau otomatis saat deadline | `status=closed`; semua `waiting` yang tidak dipilih → `not_selected`, `decided_at=now` → notif `application.not_selected` per user | C9 untuk yang tidak terpilih, C6/C7 untuk yang lain |
| F3 | **Pelamar per event** | List application per event, grup per posisi, tampilkan `applied_position`, status, `applied_at`, profil singkat + roles user | — | — |
| F3a | Select | pilih user, tetapkan `assigned_position` (default = `applied_position`, boleh beda, D-09). Tidak dibatasi `needed`; **diblok** bila user sudah `selected` di event lain tanggal sama (D-15 Q2, Q3) | `status=selected`, `assigned_position`, `decided_at` → notif `application.selected` | C8 "Selected as {assigned_position}", muncul di Schedule D1, menerima `admin_note` |
| F3b | Batalkan select (opsional) | kembalikan ke `waiting` | hapus `assigned_position`, `decided_at=null` | kembali ke C5 |
| F4 | **Catatan untuk crew terpilih** | edit `admin_note` event (dress code, titik kumpul, dsb.) | field di event | Hanya tampil di C8 kalau `my_application.status == selected` (kontrak §1). Backend **tidak boleh** mengirim `admin_note` ke user yang bukan selected |
| F5 | **Master data** | CRUD Branch, CrewRole | `GET /branches` publik dipakai form register (A5) | Dropdown branch di A5 |
| F6 | **Daftar user** | semua crew per branch, filter status verifikasi, lihat riwayat application | — | — |

| F7 | **Akun admin** (superadmin) | buat/nonaktifkan admin, tetapkan branch yang boleh diakses (≥ 1) | tabel admin terpisah dari `User` crew (D-15 Q1) | — |

Yang **tidak** ada di v1 (jangan dibangun kecuali diputuskan): kirim notifikasi
manual/broadcast, absensi/kehadiran, reminder H-1, "Can't attend" (D-11),
pemindahan branch oleh admin (tapi lihat D-08 REVISIT — kandidat kuat).

## 3. Invariant yang harus dijaga backend

App mengandalkan ini; kalau dilanggar, UI crew salah tanpa error.

1. **Format wire** persis kontrak §0: envelope `{message, data}`, error
   `{message, code?, errors?}`, `date` = `YYYY-MM-DD`, `*_at` ISO-8601
   dengan offset, jam `HH:mm`, enum snake_case. `code` wajib untuk setiap
   422 bisnis; app mencabang pada `code`, bukan `message`.
2. **`cannot_apply_reason` precedence**: `closed` → `already_applied` →
   `no_matching_role` → `date_conflict` (mock_server `_cannotApplyReason`).
   `not_verified` ditangani sebagai 403, bukan reason.
3. **`date_conflict`**: user yang punya application `waiting`/`selected` pada
   event lain dengan `date` sama tidak bisa apply (D-09). Konsekuensi untuk
   admin: saat **select**, periksa juga konflik tanggal — user bisa `waiting`
   di dua event yang berbeda tanggal tetapi admin tidak boleh membuat satu
   user `selected` pada dua event di tanggal yang sama. Backend **menolak**,
   dashboard menampilkan alasannya (D-15 Q3).
4. **Branch isolation**: `GET /events` hanya event branch user; `GET
   /events/{id}` beda branch → 404. Admin non-super hanya melihat branch
   yang ditetapkan untuknya (D-15 Q1).
5. **`admin_note` hanya untuk selected** — filter di serializer `EventDetail`
   berdasarkan `my_application.status`.
6. **`roles` kosong selama `pending`**; approve tanpa role = bug.
7. **Withdrawn tidak bocor** ke endpoint mobile (list, counter `meta.total`,
   history, `meta.summary.worked_count`).
8. **`closes_at` = `event.apply_deadline`** — kalau admin mengubah deadline
   setelah ada pelamar, timeline C5 crew ikut berubah. Pertimbangkan
   batasan "deadline hanya bisa dimajukan/diundur selama event masih open".
9. **Notifikasi = record + push.** Setiap pemicu di §2 membuat record
   `Notification` (`type`, `title`, `body`, `data`) **dan** push FCM ke
   semua device token user. FCM `data` semua nilai **string**:
   `{type, notification_id, event_id?, application_id?}`. Hapus device
   token saat `/logout`. Simpan record ≥ 90 hari.
10. **`meta.summary`** di `/schedule/history`: `worked_count` = jumlah
    `selected` dengan `event.date < today`; `worked_since` = tanggal event
    completed pertama, `null` jika 0.
11. **Idempoten**: `POST /notifications/{id}/read`, approve/reject ulang
    pada status yang sama → 200/422 jelas, bukan 500.
12. **Jangan hapus event yang punya application.** Tutup (`closed`) saja;
    history crew merujuk event lampau (D2).
13. Password rule sama di semua tempat: min 8 karakter, ≥ 1 angka.

## 4. Pemicu notifikasi (ringkas, dari kontrak §6)

| `type` | Pemicu (admin) | `data` | Penerima |
|---|---|---|---|
| `verification.approved` | F1a | – | user |
| `verification.rejected` | F1b | – | user |
| `event.published` | F2a | `event_id` | semua user `approved` di branch event dengan role match |
| `application.selected` | F3a | `event_id, application_id` | user |
| `application.not_selected` | F2b | `event_id, application_id` | tiap user `waiting` yang tidak terpilih |
| `event.updated` | F2c | `event_id` | tiap user `waiting`/`selected` di event itu (D-15 Q6) |
| `application.submitted` | (bukan admin — otomatis saat user apply) | `event_id, application_id` | user |

`title`/`body` contoh dari mock: *"You're selected"* / *"Arunika annual
gathering · 5 Oct · Crew"*. Copy akhir bebas, bahasa Inggris, nada pendek
seperti copy-table.

## 5. Usulan endpoint admin (bukan kontrak, boleh diubah)

Kontrak mobile tidak mendefinisikan sisi admin. Usulan agar konsisten
dengan konvensi mobile (`/api/v1`, Sanctum, paginator Laravel):

```
/api/v1/admin
  GET    /users?branch_id&verification_status&search&page
  GET    /users/{id}                       → User + applications[]
  POST   /users/{id}/approve  {role_ids[]}
  POST   /users/{id}/reject   {note}
  PUT    /users/{id}/roles    {role_ids[]}

  GET    /events?branch_id&status&page
  POST   /events                           → EventDetail (status draft)
  GET    /events/{id}
  PUT    /events/{id}
  POST   /events/{id}/publish
  POST   /events/{id}/close                → F2b, memicu not_selected massal
  GET    /events/{id}/applications?status&position_id
  POST   /applications/{id}/select  {assigned_position_id}
  POST   /applications/{id}/unselect

  GET|POST|PUT|DELETE /branches            (superadmin)
  GET|POST|PUT|DELETE /crew-roles          (superadmin)
  GET|POST|PUT        /admins  {name, email, branch_ids[]}   (superadmin)
```

Admin auth terpisah dari crew (guard/ability berbeda); admin **bukan**
`User` crew. Superadmin melewati filter branch; admin biasa hanya melihat
`branch_ids`-nya (D-15 Q1). Semua aksi tulis admin dicatat ke activity log (siapa, kapan,
apa) — murah sekarang, mahal kalau ditambah belakangan, dan D-08 REVISIT
sudah meminta jejak perubahan.

## 6. Keputusan produk untuk dashboard (D-15, 15 Okt 2026)

Semua pertanyaan terbuka sudah dijawab pemilik produk dan dicatat sebagai
**D-15** di `decisions.md`. Ringkasannya:

| # | Keputusan |
|---|---|
| Q1 | **Superadmin** akses semua branch, mengelola master data, dan membuat akun **admin** yang di-scope ke satu atau lebih branch |
| Q2 | `needed` = **target, bukan batas keras**; boleh **kosong** (`null`). Admin boleh select lebih dari target |
| Q3 | Select user yang sudah `selected` di event lain pada tanggal sama → **blok** |
| Q4 | Status **`draft`** ada; tidak pernah dikirim ke mobile. Publish = `draft → open` |
| Q5 | Admin **boleh menutup seleksi sebelum deadline** |
| Q6 | Edit tanggal/jam/venue setelah publish → notifikasi **`event.updated`** (in-app + FCM) ke pelamar `waiting`/`selected` |
| Q7 | `APP_DOMAIN` + `.well-known` + fallback `/reset-password` di-host **backend yang sama** |
| Q8 | Token Sanctum **tidak expire** di v1 |

Dua tiket mobile menyusul dari D-15 (bukan tugas tim dashboard):
`EventPosition.needed` → `int?` (model, `EventFormats.needed`, C3/C4,
fixture) dan `NotificationType.eventUpdated` + routing tap. Sampai itu
selesai, app memparse `needed: null` sebagai error parse dan
`event.updated` sebagai `unknown` — jadi **jangan kirim `needed: null` ke
build mobile lama**; isi angka sampai tiket mobile-nya merge.

Pertanyaan §7 kontrak yang masih terbuka: rate limit dan ambang `is_urgent`.

## 7. Cara memverifikasi terhadap app mobile

Tujuan: setiap aksi admin bisa dilihat dampaknya di app tanpa mock.

1. Jalankan backend kalian, lalu app ini dengan mock **dimatikan**: salin
   `env/prod.example.json` → `env/staging.json`, set `USE_MOCK: false` dan
   `BASE_URL` ke **prefix lengkap termasuk versi**, mis.
   `https://api.kalian.com/api/v1`. App tidak menambahkan `/v1` sendiri:
   Dio memakai `BASE_URL` apa adanya dan repository memanggil path kontrak
   (`/events/{id}`, `/me`, …) langsung di belakangnya. Lalu
   `./tool/run.sh staging -d <device>`.
2. Seed data minimal yang mereplikasi persona mock supaya screenshot bisa
   dibandingkan dengan `docs/reports/task-020/` (password `password1`):
   - `nadia@example.com` approved, roles Crew + Event Manager, branch
     Jakarta: 2 `waiting`, 1 `selected` upcoming, 1 `not_selected`,
     6 `selected` lampau (Home menampilkan "02 waiting", "06 worked").
   - `pending@example.com` pending tanpa role; `rejected@example.com`
     rejected dengan note.
   - 3 event open Jakarta (urut deadline; satu `is_urgent`), 1 open
     Bandung (tidak boleh terlihat Nadia), 2 closed upcoming, 8 closed
     lampau. Dua event (satu open, satu closed-selected) di **tanggal yang
     sama** agar `date_conflict` terlihat. Daftar lengkap: `fixtures/mock_data.dart`.
3. Checklist dampak (admin → app):

   | Aksi admin | Lihat di app |
   |---|---|
   | Approve pending user + role | Login ulang/resume: A6 → B1, roles tampil, push `verification.approved` |
   | Reject dengan note | A7 menampilkan note; "Edit profile" → "Submit again" → kembali A6 dengan tanggal baru |
   | Publish event dengan posisi Crew di Jakarta | C1 bertambah ("4 open"), push `event.published` ke Nadia; **tidak** ke user Bandung atau yang tanpa role match |
   | Select Nadia dengan `assigned_position` ≠ applied | C8 "Selected as …" memakai assigned; D1 Upcoming; `admin_note` tampil; push |
   | Tutup event dengan pelamar waiting | C9 untuk yang tidak terpilih; push `application.not_selected`; counter Home berkurang |
   | Ubah `admin_note` | C8 refresh menampilkan teks baru; user non-selected tidak melihatnya |
   | Ubah tanggal/venue event yang punya pelamar | push `event.updated` ke pelamar; tap → detail dengan data baru |

## 8. Hal yang sengaja tidak ditentukan di sini

- Stack dashboard (Laravel Blade/Inertia, Next.js, Filament, dsb.) — bebas.
  README mobile menyebut backend "Laravel-style" (Sanctum, format 422
  Laravel), itu asumsi format, bukan keharusan framework.
- Visual dashboard. Kalau ingin senada dengan app: 7 warna di
  `lib/core/theme/app_colors.dart` (ink `#221F1F`, muted `#6F6B69`,
  surface `#FFFFFF`, background `#F7F7F6`, line `#E4E4E3`, accent/blush
  `#E9DDD8`, error `#B3261E`), font Inter, sudut 32/40.
- Hak akses granular di dalam admin (reviewer vs event manager) — mulai
  dari satu peran admin per branch; pecah kalau kebutuhan nyata muncul.
