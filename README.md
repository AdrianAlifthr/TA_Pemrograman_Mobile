# 🍽️ RESTO APP

## 1. Judul Aplikasi
**RESTO APP — Mobile Restaurant Management System**

## 2. Tim
* ADRIAN ALI FATHIR — 241712050
* ELRENO NOELSON HENOCH HASANI — 241712055
* M. IHSAN SADIK — 241712058
* SELO FRISILIA S. — 241712067
* RAEL GILBERT MANURUNG — 241712070
* VICENSYAH OCTAVIA SIAGIAN — 241712076

## 3. Deskripsi singkat aplikasi
Resto App adalah aplikasi mobile untuk manajemen operasional restoran secara real-time yang dirancang untuk tiga peran (receptionist, waiter, chef), setiap peran memiliki layar dan akses data spesifik; aplikasi ini dibangun dengan Flutter (frontend) dan REST API PHP + MySQL (backend) untuk menyimpan, mengambil, dan mensinkronkan data pesanan, status meja, dan katalog menu.

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
* **Catatan teknis:** UI card menunjukkan waktu, daftar item, dan tombol untuk mengubah status yang memicu `setState()` lalu POST update (di kode contoh ada state lokal; dalam implementasi lengkap update ke server).


## 5. Struktur Repository
```
TA_PEMROGRAMAN_MOBILE/
├── api/                      # Backend PHP (letakkan di C:\xampp\htdocs\resto_api\)
│   ├── connection-pdo.php
│   ├── login.php
│   ├── menu_list.php
│   ├── menu_list_waiter.php
│   ├── menu_update_available.php
│   ├── create_order.php
│   ├── order_list.php
│   ├── active_orders.php
│   ├── tables_view_status.php
│   ├── update_table_status.php
│   └── ... (lainnya)
├── app/                      # Project Flutter (nama folder proyek: app/)
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── api_config.dart
│   │   ├── main.dart
│   │   ├── pages/
│   │   │   ├── login_page.dart
│   │   │   ├── dashboard_page.dart
│   │   │   ├── table_layout.dart
│   │   │   ├── menu_management_page.dart
│   │   │   ├── waiter_order_screen.dart
│   │   │   ├── chef_kitchen_screen.dart
│   │   │   └── ... (lainnya)
│   │   ├── widgets/
│   │   └── models/
│   ├── pubspec.yaml
│   └── README.md
├── README.md                 
```
##

## 6. Stack technology yang digunakan

**Framework & bahasa**
* Flutter — UI cross-platform (Dart)
* Dart — Bahasa pemrograman frontend

**Backend**
* PHP (PDO) — REST API endpoints
* MySQL — Database

**Server / Local dev**
* XAMPP (Apache + MySQL) — Menjalankan PHP + MySQL di `C:\xampp\htdocs\`

**Libraries (Flutter)**
* `http` — HTTP client untuk request ke API
* `shared_preferences` — penyimpanan lokal (opsional untuk token/session)
* `flutter_lints` — linting
* `cupertino_icons` — icons

**Tools**
* Android Studio / VS Code
* Git

---

**Framework & Tools Version**
* Flutter: 3.38.4 (channel stable)
* Dart SDK: 3.10.3
* DevTools: 2.51.1
* Gradle: 8.12 (dari distributionUrl)

**Aplikasi**
* App version: 1.0.0+1
 - 1.0.0 → versionName (nama versi aplikasi)
 - +1 → versionCode (kode build untuk Android)

**Dependencies (Library Utama)**
* flutter — SDK bawaan Flutter
* cupertino_icons: ^1.0.8
* http: ^1.6.0
* shared_preferences: ^2.2.2

**Dev Dependencies**
* flutter_test — SDK bawaan Flutter untuk testing
* flutter_lints: ^5.0.0

**Environtment**
* Dart SDK constraint: ^3.9.0 → Proyek kompatibel mulai dari Dart 3.9 ke atas, saat ini berjalan dengan Dart 3.10.3 sesuai output flutter --version.


## 7. Cara Menjalankan (detail & step-by-step)
Pastikan kamu mengikuti urutan — backend harus hidup sebelum menjalankan app jika kamu ingin memakai API lokal.

### Persiapan (satu kali)

1. **Install XAMPP** ([https://www.apachefriends.org](https://www.apachefriends.org)) — aktifkan **Apache** dan **MySQL**.
2. **Copy folder API**
   * Copy isi folder `TA_PEMROGRAMAN_MOBILE/api/` → `C:\xampp\htdocs\resto_api\` (atau `htdocs\<nama_folder>`).
3. **Import database**
   * Buka `http://localhost/phpmyadmin` → buat database `resto_management` → import `database_dump.sql` (jika ada).
   * Atur kredensial DB di `api/connection-pdo.php` (username/password jika berbeda).
```php
    // connection-pdo.php (sesuaikan jika diperlukan)
    $servername = "localhost";
    $dbusername = "root";
    $dbpassword = "";
    $dbname = "resto_management";
```

4. **Cek endpoint** di browser:
   * `http://localhost/resto_api/active_orders.php` — harus mengembalikan JSON.
   * Jika memakai perangkat fisik dan ingin akses dari HP via USB, gunakan IP address PC (mis. `http://192.168.1.12/resto_api/...`) dan pastikan firewall mengizinkan koneksi.

### Menjalankan Backend (setiap sesi dev)
1. Jalankan **XAMPP Control Panel** → Start **Apache** dan **MySQL**.
2. Buka API base URL di browser/POSTMAN untuk verifikasi (mis. `http://localhost/resto_api/menu_list.php`).


### Menjalankan Frontend Flutter
1. **Persiapan environment Flutter**
   * Pastikan Flutter terinstall (`flutter --version`).
   * Pastikan perangkat tersedia (`flutter devices`).

2. **Install dependencies**
```bash
cd TA_PEMROGRAMAN_MOBILE/app
flutter pub get
```

3. **Jalankan aplikasi (emulator atau perangkat fisik)**
   * **Emulator:** buka Android Studio → AVD → Start → `flutter run`
   * **Perangkat fisik:** aktifkan Developer Options & USB Debugging → hubungkan via USB → jalankan `flutter devices` untuk cek → `flutter run`
   * Jika ingin menjalankan dengan IP lokal untuk mengakses API di PC, ubah `lib/api_config.dart` atau konstanta `ApiConfig` ke `http://<PC_IP>/resto_api/` bukan `localhost`.

4. **Hot reload & hot restart**
   * Saat `flutter run` berjalan, tekan `r` untuk hot reload, `R` untuk hot restart.

## Contoh konfigurasi `lib/api_config.dart`
(Ubah `BASE_URL` sesuai environment)

```dart
class ApiConfig {
  static const String BASE_URL = "http://192.168.1.12/resto_api"; // ganti ke IP PC atau localhost untuk emulator
  static String get login => "$BASE_URL/login.php";
  static String get menuList => "$BASE_URL/menu_list.php";
  static String get menuListWaiter => "$BASE_URL/menu_list_waiter.php";
  static String get menuUpdate => "$BASE_URL/menu_update_available.php";
  static String get createOrder => "$BASE_URL/create_order.php";
  static String get orderList => "$BASE_URL/order_list.php";
  static String get tablesView => "$BASE_URL/tables_view_status.php";
  static String get updateTableStatus => "$BASE_URL/update_table_status.php";
  static String get activeOrder => "$BASE_URL/active_orders.php";
  static String get countTables => "$BASE_URL/count_table_available.php";
}
```

## Tips debugging & common issues

* **CORS / Access issues:** Pastikan header `Access-Control-Allow-Origin: *` di semua endpoint PHP (sudah ada di kode contoh).
* **API tidak muncul di HP:** gunakan IP PC, bukan `localhost`; pastikan firewall/antivirus tidak memblokir; hp & laptop pada jaringan yang sama.
* **Query param encoding di Flutter:** gunakan `Uri.parse(...).replace(queryParameters: {...})`. (lihat `login()` di `login_page.dart`).
* **Performa list gambar:** gunakan `Image.network(..., errorBuilder: ...)` untuk fallback jika URL gambar bermasalah.
