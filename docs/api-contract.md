# Penta Crew — Kontrak API mobile (usulan ke backend)

Versi 1 · 2 Okt 2026 · Dasar keputusan: [`decisions.md`](decisions.md) (D-xx).

Backend belum ada, jadi dokumen ini adalah **kebutuhan dari sisi app**. Nama
field boleh disesuaikan selama bentuknya setara — tolong beri tahu kami kalau
ada yang diubah.

---

## 0. Konvensi umum

- Base path: `/api/v1`. Semua respons JSON.
- **Envelope:** sukses `{ "message": string, "data": … }`; app hanya membaca
  `data`. Error `{ "message": string, "code"?: string, "errors"?: { field: [msg] } }`.
  - `message` ditampilkan apa adanya ke user (sudah berbahasa manusia).
  - `code` (snake_case, stabil) dipakai app untuk logika, mis.
    `date_conflict`, `deadline_passed`, `token_expired`. Wajib untuk setiap
    422 bisnis (bukan validasi field).
  - `errors` = validasi Laravel standar (422), dipetakan ke field form.
- **Auth:** Bearer token (Sanctum). `401` → app menghapus session dan ke
  Sign in. `403` → layar Forbidden.
- **Paginator:** `{ "data": [...], "meta": { "current_page", "last_page",
  "total", … } }`. Query `page` dan `per_page` (default 20, maks 50).
- **Tanggal/waktu:** `date` = `YYYY-MM-DD`; `*_at` = ISO-8601 dengan offset
  (`2026-10-05T14:00:00+07:00`); jam acara `HH:mm`. Jangan kirim epoch.
- **Enum** selalu snake_case string.
- `Accept-Language: id|en` dikirim app; `message` mengikuti jika bisa.
- Deep link (D-02): backend juga meng-host di `APP_DOMAIN`
  - `GET /.well-known/apple-app-site-association` (JSON, tanpa ekstensi,
    `Content-Type: application/json`)
  - `GET /.well-known/assetlinks.json`
  - `GET /reset-password?token=&email=` halaman web fallback.
  Isi file (team ID / SHA-256 cert) kami kirim menyusul.

---

## 1. Model

### `User` (D-03, flat)
```jsonc
{
  "id": 12,
  "name": "Nadia Putri",
  "email": "nadia@example.com",
  "phone": "+628123456789",
  "avatar_url": null,                    // string|null
  "date_of_birth": "1999-04-12",
  "gender": "female",                    // male | female
  "address": "Jl. Kemang Raya 10, Jakarta Selatan",
  "branch": { "id": 1, "name": "Jakarta" },           // Branch
  "roles": [ { "id": 1, "name": "Crew" }, { "id": 2, "name": "Event Manager" } ], // CrewRole[], kosong saat pending
  "verification_status": "pending",      // pending | approved | rejected
  "verification_note": null,             // string|null — catatan admin saat rejected (A7)
  "submitted_at": "2026-09-25T09:40:00+07:00",
  "reviewed_at": null,                   // null selama pending
  "member_since": "2026-09-25"           // = created_at, dipakai di Profile
}
```

### `Branch` `{ id, name }` · `CrewRole` `{ id, name }`

### `Event` (ringkas — list, carousel, schedule)
```jsonc
{
  "id": 41,
  "title": "Arunika annual gathering",
  "date": "2026-10-05",
  "start_time": "14:00",
  "end_time": "20:00",
  "duration_hours": 6,
  "venue_name": "JIExpo Kemayoran, Hall B",
  "branch": { "id": 1, "name": "Jakarta" },
  "apply_deadline": "2026-09-28T23:59:00+07:00",
  "is_urgent": true,                     // backend: deadline < 48 jam (pill "urgent", C1)
  "positions": [                         // EventPosition[] — ringkas
    { "id": 7, "role": { "id": 1, "name": "Crew" }, "needed": 10, "matches_my_role": true },
    { "id": 8, "role": { "id": 3, "name": "Trainee" }, "needed": 2, "matches_my_role": false }
  ]
}
```

### `EventDetail` = `Event` +
```jsonc
{
  "venue_address": "Jl. Benyamin Sueb, Jakarta Pusat",
  "briefing_time": "13:00",              // string|null
  "requirements": ["Usher", "Registration desk", "Any gender"], // tag chips C3
  "description": "…",                    // string|null
  "admin_note": "All black, closed shoes…", // string|null — HANYA diisi jika my_application.status == selected (C8)
  "status": "open",                      // open | closed (closed = deadline lewat ATAU admin tutup)
  "can_apply": false,
  "cannot_apply_reason": "date_conflict", // null | closed | already_applied | no_matching_role | date_conflict | not_verified
  "my_application": null                 // Application|null
}
```

### `Application` (D-04, D-09)
```jsonc
{
  "id": 301,
  "status": "waiting",                   // waiting | selected | not_selected | withdrawn
  "applied_position": { "id": 7, "role": { "id": 1, "name": "Crew" } },
  "assigned_position": null,             // diisi admin saat selected; boleh beda dari applied
  "applied_at": "2026-09-25T10:12:00+07:00",
  "closes_at": "2026-09-28T23:59:00+07:00", // = event.apply_deadline (timeline C5)
  "decided_at": null,                    // saat selected / not_selected
  "event": { …Event ringkas… }           // disertakan di list Tracked/Schedule; boleh dihilangkan di GET /events/{id}.my_application
}
```

### `Notification` (D-06)
```jsonc
{
  "id": 9001,
  "type": "application.selected",        // lihat §6
  "title": "You're selected",
  "body": "Arunika annual gathering · 5 Oct · Crew",
  "data": { "event_id": 41, "application_id": 301 }, // kunci yang ada tergantung type
  "read_at": null,
  "created_at": "2026-09-29T08:00:00+07:00"
}
```

---

## 2. Auth & akun

| # | Method · Path | Auth | Request | `data` | Catatan |
|---|---|---|---|---|---|
| 2.1 | `POST /login` | – | `email, password, device_token?, device_platform? (ios\|android)` | `{ token, user }` | 401 `code: invalid_credentials`, message "Email or password is incorrect" (A3) |
| 2.2 | `POST /register` | – | `name, email, phone, password, password_confirmation, date_of_birth, gender, branch_id, address, device_token?` | `{ token, user }` | `user.verification_status = pending`, `roles = []` (D-01). 422 `errors` per field |
| 2.3 | `GET /me` | ✓ | – | `User` | Dipanggil di splash & setelah resume |
| 2.4 | `POST /logout` | ✓ | – | – | Hapus token **dan** device token-nya |
| 2.5 | `POST /forgot-password` | – | `email` | – | Selalu 200. Rate-limit per email |
| 2.6 | `POST /reset-password` | – | `token, email, password, password_confirmation` | – | 422 `code: token_expired` / `token_invalid` |
| 2.7 | `PUT /me/profile` | ✓ | `name, phone, date_of_birth, gender, branch_id, address` (email **tidak** bisa diubah) | `User` | **Tidak** mengubah `verification_status` (D-08). Jika `rejected`, lihat 3.1 |
| 2.8 | `PUT /me/password` | ✓ | `current_password, password, password_confirmation` | – | 422 `errors.current_password` jika salah |
| 2.9 | `POST /me/avatar` | ✓ | multipart `avatar` (jpg/png ≤ 5 MB) | `{ avatar_url }` | Backend resize ke ≤ 512 px |
| 2.10 | `PUT /me/device-token` | ✓ | `device_token, device_platform` | – | Dipanggil saat FCM `onTokenRefresh` (D-06) |
| 2.11 | `GET /branches` | – | – | `Branch[]` | Publik, untuk dropdown register (A5) |

Aturan password (dipakai 2.2, 2.6, 2.8): min 8 karakter, minimal 1 angka —
samakan dengan rule live di app (E3).

---

## 3. Verifikasi (A6/A7)

| # | Method · Path | Auth | Request | `data` | Catatan |
|---|---|---|---|---|---|
| 3.1 | `POST /me/verification/resubmit` | ✓ | – | `User` | Hanya jika `rejected`. Status → `pending`, `submitted_at` diperbarui, `verification_note` dikosongkan. App memanggil 2.7 lalu 3.1 dari tombol "Submit again" |

Semua data status ada di `User`; tidak perlu endpoint `GET /me/verification`.

**Guard backend:** semua endpoint §4–§6 mengembalikan `403 code: not_verified`
jika `verification_status != approved` (app sudah memblokir di router, ini
lapis kedua).

---

## 4. Events & apply

| # | Method · Path | Request | `data` | Catatan |
|---|---|---|---|---|
| 4.1 | `GET /events` | query `branch_id` (wajib, D-10), `status=open` (default), `search?`, `page`, `per_page` | paginated `Event[]` | Urut `apply_deadline ASC`. Hanya event `open` dan `branch_id` = branch user (403 jika beda). `positions[].matches_my_role` dihitung dari roles user. `meta.total` dipakai header "3 open" |
| 4.2 | `GET /events/{id}` | – | `EventDetail` | Boleh diakses walau event sudah closed (C6–C9 dibuka dari Tracked/Schedule/notifikasi). 404 jika event beda branch |
| 4.3 | `POST /events/{id}/applications` | `position_id` | `Application` | 422 `code`: `closed` · `already_applied` · `position_not_matching_role` · `date_conflict` (D-09: ada application `waiting`/`selected` di event lain dengan `date` sama). Memicu notifikasi `application.submitted` |
| 4.4 | `DELETE /applications/{id}` | – | – | Withdraw → `status = withdrawn` (soft). 422 `code: deadline_passed` jika sudah lewat `closes_at`; 422 `code: not_withdrawable` jika status bukan `waiting`. Setelah ini user boleh apply lagi (D-04) |
| 4.5 | `GET /applications` | query `status?` (`waiting\|selected\|not_selected`, boleh koma: `waiting,selected`), `page`, `per_page` | paginated `Application[]` (+`event`) | Tab Tracked (C2). **Tidak pernah** mengembalikan `withdrawn`. Urut: `waiting` dulu (by `closes_at ASC`), lalu sisanya `decided_at DESC`. Home memakai `?status=waiting&per_page=1` → `meta.total` |

---

## 5. Schedule

| # | Method · Path | Request | `data` | Catatan |
|---|---|---|---|---|
| 5.1 | `GET /schedule/upcoming` | `page`, `per_page` | paginated `Application[]` (status `selected`, `event.date ≥ today`) | Urut `event.date ASC, start_time ASC`. Item pertama = "Next" (D1) dan "next shift" di Home. Grouping per bulan dilakukan app |
| 5.2 | `GET /schedule/history` | `page`, `per_page` | paginated `Application[]` + `meta.summary` | Isi: `selected` dengan `event.date < today` **dan** `not_selected` (D-07). Urut `event.date DESC`. `meta.summary = { "worked_count": 6, "worked_since": "2026-07-01" }` (`worked_since` = tanggal event completed pertama, `null` jika 0) |

Label di app diturunkan dari `status`: `selected` + lewat → *Completed*,
`not_selected` → *Not selected*. Tidak ada status kehadiran di v1.

---

## 6. Notifications (D-06)

| # | Method · Path | Request | `data` | Catatan |
|---|---|---|---|---|
| 6.1 | `GET /notifications` | `page`, `per_page` | paginated `Notification[]` + `meta.unread_count` | Urut `created_at DESC`. Simpan ≥ 90 hari |
| 6.2 | `GET /notifications/unread-count` | – | `{ "count": 3 }` | Badge bell di Home; ringan, dipanggil tiap Home tampil/resume |
| 6.3 | `POST /notifications/{id}/read` | – | – | Idempoten |
| 6.4 | `POST /notifications/read-all` | – | – | |

### Tipe & push payload

Setiap tipe membuat record in-app **dan** mengirim push FCM ke semua device
token user. FCM `data` (semua nilai string, karena batasan FCM):

```jsonc
{ "type": "application.selected", "notification_id": "9001", "event_id": "41", "application_id": "301" }
```

| `type` | Pemicu | `data` keys | Target |
|---|---|---|---|
| `verification.approved` | admin approve | – | semua device user |
| `verification.rejected` | admin reject | – | semua device user |
| `event.published` | admin publish event | `event_id` | semua user **approved** di branch event yang punya ≥ 1 role match salah satu posisi |
| `application.submitted` | 4.3 sukses | `event_id, application_id` | user |
| `application.selected` | admin set selected | `event_id, application_id` | user |
| `application.not_selected` | admin tutup seleksi | `event_id, application_id` | tiap user `waiting` yang tidak terpilih |

Catatan FCM: kirim `notification` block (title/body) **dan** `data` block;
untuk iOS set `apns.payload.aps.sound = "default"` dan
`content-available` tidak diperlukan.

---

## 7. Hal yang belum ditentukan (perlu jawaban backend)

1. `APP_DOMAIN` untuk deep link reset password — domain apa yang bisa dipakai
   dan siapa yang host dua file `.well-known`?
2. Rate limit login/forgot-password (usulan: 5/menit per IP+email) dan masa
   berlaku token reset (usulan Laravel default 60 menit).
3. Token Sanctum: kadaluarsa atau tidak? Jika ya, app perlu tahu agar bisa
   menampilkan "Session expired" alih-alih error generik.
4. `is_urgent` — ambang 48 jam OK, atau mau dikonfigurasi admin?
5. Apakah admin bisa **menutup seleksi** sebelum `apply_deadline`? Jika ya,
   `EventDetail.status = closed` bisa terjadi sebelum `closes_at`, dan app
   akan menampilkan C6 berdasarkan `status`, bukan berdasarkan waktu.
