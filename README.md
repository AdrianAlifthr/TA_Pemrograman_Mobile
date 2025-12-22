# 🍽️ RESTO APP

## 1. Judul Aplikasi

**RESTO APP — Mobile Restaurant Management System**

## 2. Tim

* ADRIAN ALI FATHIR — 241712050
* ELRENO NOELSON HENOCH HASANI — 241712055
* M. IHSAN SADIK — 241712058
* SELO FRISILIA S. — 241712067
* VICENSYAH OCTAVIA SIAGIAN — 241712076

## 3. Deskripsi singkat aplikasi

Resto App adalah aplikasi mobile untuk manajemen operasional restoran secara real-time yang dirancang untuk tiga peran (receptionist, waiter, chef), setiap peran memiliki layar dan akses data spesifik; aplikasi ini dibangun dengan Flutter (frontend) dan REST API PHP + MySQL (backend) untuk menyimpan, mengambil, dan mensinkronkan data pesanan, status meja, dan katalog menu.

> **Update Sistem Backend**
> Proyek ini **tidak lagi menggunakan API lokal (localhost/XAMPP di masing-masing laptop)**. Backend dan database kini dijalankan secara **online** dan diekspos menggunakan **service tunneling (Ngrok)**, sehingga user **tidak perlu menyalin API maupun database** ke perangkat masing-masing.

## 4. Daftar Fitur Aplikasi

### 🔑 Autentikasi Login

* **Apa:** Endpoint `login.php` (GET `?username=&password=`) memvalidasi user dan mengembalikan detail user termasuk `role`.
* **Role yang mengolah:** Semua user (receptionist/waiter/chef) melakukan login; backend (PHP + PDO) memverifikasi.
* **Catatan teknis:** Implementasi menggunakan PDO + parameter binding untuk mengurangi risiko SQL injection (`login.php`).

### 🏠 Dashboard

* **Apa:** Menampilkan ringkasan total meja, jumlah meja booked, jumlah order aktif, status meja (grid) dan ringkasan order masuk. Data diambil dari API: `count_table_available.php`, `active_orders.php`, `tables_view_status.php`, `order_list.php`.
* **Role yang mengolah:** Ditampilkan untuk masing-masing role; data di-fetch oleh UI (DashboardScreen) dan dipresentasikan sesuai role.
* **Catatan teknis:** Kode memanggil beberapa endpoint HTTP GET dan merender grid (GridView.builder).

### 🪑 Table Layout

* **Apa:** Visualisasi layout meja (posisi, jenis meja), filter status (All/Available/Booked/Cleaning). Data menggunakan `tables_view_status.php` / `table_status.php`.
* **Role yang mengolah:** Receptionist / waiter melihat & mengubah status meja; perubahan status dikirim ke `update_table_status.php`.
* **Catatan teknis:** UI menggunakan `LayoutBuilder` + `Positioned` untuk menempatkan meja; backend menyimpan `TABLE_ID` dan `STATUS`.

### 🍜 Menu Management (Waiter / Chef)

* **Apa:** Menampilkan daftar menu, filter kategori, search, dan toggle ketersediaan (Switch). API: `menu_list.php`, `menu_list_waiter.php`, `menu_update_available.php`.
* **Role yang mengolah:** Chef atau manager (dalam implementasi ChefMenuManagementScreen) mengubah ketersediaan menu; waiter melihat menu yang tersedia.
* **Catatan teknis:** `MenuItemModel.fromJson` normalisasi price & available; switch mengirim POST ke `menu_update_available.php`.

### 🧾 Table Order (Waiter)

* **Apa:** Waiter memilih menu, menambah ke cart, masukkan nomor meja, pilih metode pembayaran (Cash/QRIS), dan submit order lewat `create_order.php` (JSON POST).
* **Role yang mengolah:** Waiter membuat order; backend membuat record `orders` dan `order_items`. Kitchen akan menerima order via `order_list.php`.
* **Catatan teknis:** Payload berisi `table_id`, `items` (menu_id & quantity), `payment_method`. `create_order.php` menghitung total, insert order & order_items dalam transaction.

### 👨‍🍳 Kitchen Task System (Chef)

* **Apa:** Menampilkan daftar tugas dapur (order dengan status waiting/cooking/ready), tombol ubah status (Cooking / Ready). Data via `order_list.php` / `active_orders.php`.
* **Role yang mengolah:** Chef mengatur status masak; update status dikirimkan ke endpoint terkait (`update_kitchen_status.php` / `order_items` status).
* **Catatan teknis:** UI card menunjukkan waktu, daftar item, dan tombol untuk mengubah status yang memicu `setState()` lalu POST update.

## 5. Struktur Repository

```
TA_PEMROGRAMAN_MOBILE/
├── api/                      # Backend PHP (online via Ngrok, tidak perlu dicopy ke laptop user)
│   └── ...
├── app/                      # Project Flutter
│   ├── lib/
│   │   ├── api_config.dart
│   │   ├── main.dart
│   │   └── ...
│   ├── pubspec.yaml
│   └── README.md
├── .env.example              # Contoh file environment (API URL)
├── README.md
```

## 6. Stack technology yang digunakan

**Framework & bahasa**

* Flutter — UI cross-platform (Dart)
* Dart — Bahasa pemrograman frontend

**Backend**

* PHP (PDO) — REST API endpoints
* MySQL — Database (online)

**Server / Deployment**

* Ngrok — Service tunneling untuk expose API & database online

**Libraries (Flutter)**

* `http`
* `shared_preferences`
* `flutter_lints`
* `cupertino_icons`

## 7. Konfigurasi API (WAJIB)

Aplikasi **mengambil base URL API dari file environment (`.env`)**, bukan hardcoded di source code.

### Langkah konfigurasi

1. **Buat file `.env` baru** di root folder project Flutter (`app/`)
2. Isi file tersebut dengan variabel berikut:

```env
API_URL=ISI_DENGAN_URL_API_ONLINE
```

> ⚠️ **Catatan penting:**
>
> * URL API **tidak disertakan di repository** demi keamanan.
> * Untuk mendapatkan URL API yang valid (Ngrok aktif), **silakan hubungi developer secara pribadi**.
> * Tanpa file `.env`, aplikasi **tidak dapat mengakses API dan database online**.

### Penggunaan di Flutter

Nilai `API_URL` akan dibaca dari environment dan digunakan sebagai base URL seluruh endpoint API.

## 8. Cara Menjalankan Aplikasi (Frontend Only)

Karena backend sudah tersedia **online**, user **tidak perlu**:

* Install XAMPP
* Import database
* Menjalankan Apache / MySQL

### Langkah menjalankan

1. **Masuk ke folder app**

```bash
cd TA_PEMROGRAMAN_MOBILE/app
```

2. **Pastikan file `.env` sudah dibuat dan diisi**

3. **Install dependencies**

```bash
flutter pub get
```

4. **Jalankan aplikasi**

```bash
flutter run
```

Aplikasi akan otomatis terhubung ke **API & database online** melalui URL yang ada di file `.env`.

## 9. Keuntungan Sistem API Online

* Tidak perlu setup backend di setiap laptop
* Database terpusat dan konsisten
* Lebih mudah untuk demo dan penilaian
* Mendekati simulasi deployment real-world

## Tips debugging

* Pastikan file `.env` sudah terbaca dengan benar
* Pastikan URL API masih aktif (Ngrok memiliki batas waktu)
* Jika API tidak bisa diakses, hubungi developer untuk URL terbaru
