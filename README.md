# 🎬 CINENEWS

**CINENEWS** adalah aplikasi berita film dan hiburan yang dikembangkan menggunakan **Flutter** dan bahasa pemrograman **Dart**. Aplikasi ini memanfaatkan **GNews API** untuk menampilkan informasi berita secara dinamis.

CINENEWS dirancang dengan tampilan bertema gelap yang terinspirasi dari platform hiburan digital, sehingga pengguna dapat membaca dan mencari berita dengan mudah.

## Fitur Aplikasi

1. **Berita Terbaru** — Menampilkan daftar berita film dan hiburan.
2. **Kategori Berita** — Menyediakan kategori Semua, Film, Serial TV, Anime, dan Hollywood.
3. **Pencarian Berita** — Memungkinkan pengguna mencari artikel berdasarkan kata kunci.
4. **Detail Berita** — Menampilkan judul, gambar, sumber, tanggal, deskripsi, dan cuplikan artikel.
5. **Baca Artikel Asli** — Membuka berita lengkap melalui situs penerbit.
6. **Refresh Berita** — Memperbarui daftar berita.
7. **Penanganan Kondisi Aplikasi** — Menampilkan informasi saat proses memuat, terjadi kesalahan, atau berita tidak ditemukan.
8. **Responsive Layout** — Menyesuaikan tampilan dengan ukuran layar.

## Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework pengembangan aplikasi |
| Dart | Bahasa pemrograman |
| GNews API | Sumber data berita |
| HTTP | Komunikasi dengan API |
| url_launcher | Membuka artikel asli |
| intl | Format tanggal |
| Git & GitHub | Version control dan repository |

## Struktur Project

```text
lib/
├── config/
│   └── env.dart
├── models/
│   ├── article_model.dart
│   └── news_response_model.dart
├── services/
│   ├── api_exception.dart
│   └── news_api_service.dart
├── utils/
│   └── app_colors.dart
├── views/
│   ├── article_detail_view.dart
│   ├── home_view.dart
│   └── search_result_view.dart
├── widgets/
│   ├── article_card.dart
│   ├── hero_news_banner.dart
│   ├── news_image.dart
│   └── news_state_view.dart
└── main.dart
```

## Screenshot Aplikasi


## Screenshot Aplikasi

### Halaman Utama
![Halaman Utama](screenshots/home.png)

### Kategori Berita
![Kategori Berita](screenshots/kategori.png)

### Pencarian
![Pencarian](screenshots/pencarian.png)

### Hasil Pencarian
![Hasil Pencarian](screenshots/hasil_pencarian.png)

### Detail Berita
![Detail Berita](screenshots/detail_berita.png)

### Artikel Asli
![Artikel Asli](screenshots/artikel_asli.png)


## Cara Menjalankan Aplikasi

**1. Clone repository**

```bash
git clone https://github.com/aauliarhmnn/CINENEWS.git
```

**2. Masuk ke folder project**

```bash
cd CINENEWS
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Siapkan konfigurasi API**

Buat file `config/env.json` berdasarkan `config/env.example.json`, kemudian isi dengan API key GNews milik sendiri.

**5. Jalankan aplikasi**

```bash
flutter run -d chrome --dart-define-from-file=config/env.json
```

> Catatan: API key asli tidak disertakan dalam repository. Konfigurasi ini ditujukan untuk pengembangan lokal. Pada aplikasi Flutter Web yang didistribusikan, API key yang disisipkan ke aplikasi tidak dapat dianggap sebagai rahasia.

## Sumber API

Data berita diperoleh dari [GNews API](https://gnews.io/).

## Pengembang

**Ahmad Aulia Rahman**

Program Studi Ilmu Komputer

---

Dibuat sebagai project pengembangan aplikasi menggunakan Flutter dan integrasi REST API.
