# 🍽️ **Restaurant Management Mobile App — Flutter & REST API**

Aplikasi ini merupakan sistem manajemen restoran berbasis mobile yang dikembangkan menggunakan **Flutter**, **Dart**, serta **REST API berbasis PHP & MySQL**. Proyek ini dibuat sebagai bagian dari praktikum *Mobile Programming*, dengan tujuan membangun sistem restoran yang terintegrasi untuk tiga peran utama: **Waiter**, **Kitchen Staff**, dan **Receptionist**.

Aplikasi ini menekankan prinsip **UI/UX modern**, arsitektur aplikasi yang bersih, manajemen state yang terstruktur, serta integrasi data realtime melalui **REST API**.

---

# 📁 **Struktur Repositori**

Repositori ini terdiri dari dua bagian utama: **frontend Flutter** dan **backend REST API**.

### **1️⃣ Flutter Mobile App (`/flutter_app/`)**

Komponen aplikasi mobile yang dibangun menggunakan Flutter.

Berisi folder-folder berikut:

```
lib/
 ├── pages/
 │    ├── login_page.dart
 │    ├── dashboard.dart
 │    ├── table_page.dart
 │    ├── menu_management.dart
 │    ├── table_order.dart
 │    ├── kitchen_tasks.dart
 ├── components/
 ├── api/
 ├── models/
 └── main.dart
```

### **2️⃣ REST API Backend (`/api/`)**

Backend PHP yang wajib ditempatkan di:

```
C:/xampp/htdocs/resto_api/
```

Isi folder:

* `connection-pdo.php` — koneksi database
* `login.php` — autentikasi user
* `menu_list.php` — daftar menu
* `menu_update_available.php` — update status menu
* `table_status.php` — status meja
* `create_order.php` — membuat order
* `order_list.php` — daftar pesanan
* `active_orders.php` — jumlah order aktif
* dll.

Server dijalankan melalui **XAMPP (Apache + MySQL)**.
Frontend Flutter mengakses backend melalui IPv4 / localhost.

---

# 🎨 **Prinsip UI/UX yang Digunakan**

Perancangan UI mengikuti standar modern berdasarkan Material Design 3 dan prinsip UX:

### ✔ *Visual Hierarchy*

Menu yang tersedia diberi warna hijau, sedangkan menu kosong diberi warna merah – memperjelas status secara visual (Nielsen, 2025).

### ✔ *Recognition Over Recall*

Ikon tambah (`+`) digunakan untuk menambah pesanan agar pengguna mengenali fungsi tanpa membaca teks.

### ✔ *Switch Button for Binary Actions*

Pada halaman **Menu Management**, komponen *Toggle Switch* digunakan untuk menandai menu "Available / Not Available" karena komponen ini direkomendasikan Google untuk perubahan status cepat (Google Material, 2025).

### ✔ *Efficient Workflow for Kitchen*

Halaman *Kitchen Tasks* menggunakan *Card Layout* dengan warna-warna status (waiting/cooking/ready), memudahkan koki mengambil keputusan dalam lingkungan dapur yang sibuk.

---

# 🍽️ **Fitur Utama Aplikasi**

### 🔑 **Autentikasi Login**

* Login dengan username & password (REST API)
* Verifikasi menggunakan PDO + binding untuk mencegah SQL Injection

### 🏠 **Dashboard**

* Ringkasan meja
* Ringkasan order aktif
* Preview aktivitas dapur
* Berdasarkan data realtime dari backend

### 🪑 **Table Layout**

* Menampilkan semua meja dengan status:

  * 🟢 Available
  * 🟡 Cleaning
  * 🔴 Booked
* Data diambil dari: `tables_view_status.php`

### 🍜 **Menu Management (Waiter)**

* Filter berdasarkan kategori
* Search bar
* Toggle menu availability
* Integrasi dengan: `menu_update_available.php`

### 🧾 **Table Order**

* Pilih kategori
* Tambah pesanan untuk setiap meja
* Ringkasan pesanan
* Kirim order ke kitchen melalui `create_order.php`

### 👨‍🍳 **Kitchen Task System**

* Daftar pesanan dari waiter
* Status waiting → cooking → ready
* Update status ke server
* Diambil dari: `order_list.php`

---

# 🌐 **Integrasi REST API**

Aplikasi menggunakan **HTTP GET & POST** untuk komunikasi antara Flutter dan backend.

### 📌 *Contoh Operasi API:*

#### **1. GET Login**

```
http://your-ip/resto_api/login.php?username=admin&password=12345
```

#### **2. GET Menu List**

```
http://your-ip/resto_api/menu_list.php?category=MainCourse
```

#### **3. POST Update Menu Availability**

```
POST → menu_update_available.php
{
  "menu_id": "M_01",
  "available": "1"
}
```

#### **4. POST Create Order**

Mengirim JSON body:

```
{
  "table_id": "Meja 3",
  "items": [
     {"menu_id": "M_01", "quantity": 2},
     {"menu_id": "M_15", "quantity": 1}
  ],
  "payment_method": "Cash"
}
```

---

# 🧪 **Testing & Debugging**

Aplikasi diuji menggunakan:

### 📱 *Perangkat Fisik*

* Developer Mode → USB Debugging
* menggunakan `flutter run` (Flutter Team, 2025)

### ⚡ *Hot Reload / Hot Restart*

* `r` → inject perubahan ke Dart VM
* `R` → reload aplikasi dari awal
  Fitur ini mempercepat iterasi pengembangan UI (Flutter Team, 2025).

---

# 🛠️ **Persyaratan Sistem**

* Flutter SDK 3.19+
* Dart SDK 3.5+
* Android Studio / VS Code
* XAMPP (Apache + MySQL)
* Perangkat fisik Android (opsional, rekomendasi untuk testing API)

---

# 🚀 **Cara Menjalankan**

### **1️⃣ Clone Repo**

```
git clone https://github.com/restaurant-app-team/project.git
```

### **2️⃣ Install Dependencies**

```
flutter pub get
```

### **3️⃣ Jalankan Backend**

* Copy folder `/api` ke:
  `C:/xampp/htdocs/resto_api/`
* Jalankan Apache + MySQL dari XAMPP
* Import database `.sql` ke phpMyAdmin

### **4️⃣ Jalankan Aplikasi**

```
flutter run
```

---

# 📚 **Struktur Data & Database**

Aplikasi menggunakan database MySQL dengan tabel:

### **Tables:**

* `users`
* `menu_categories`
* `tables`
* `orders`
* `order_items`

Struktur lengkap dijelaskan dalam dokumen makalah (Bagian 2.3.1).

ERD menghubungkan:

* users → orders
* menu_categories → order_items
* tables → orders

---

# 🔄 **Diagram Penelitian (Text Version)**

Proses penelitian dan pengembangan aplikasi mengikuti tahapan berikut:

> Kisah pengembangan dimulai dari identifikasi masalah operasional restoran yang masih dilakukan secara manual melalui catatan kertas dan komunikasi verbal. Setelah kebutuhan dipahami, tim mengembangkan rancangan antarmuka (*UI/UX*) menggunakan Figma sebagai visualisasi awal. Selanjutnya struktur proyek Flutter dibangun sebagai fondasi aplikasi. Implementasi halaman inti dilakukan secara bertahap, mulai dari login, dashboard, table layout, menu management, kitchen tasks, hingga halaman order untuk waiter.
> Setelah UI selesai, aplikasi diintegrasikan dengan database melalui REST API berbasis PHP & MySQL. Pengujian dilakukan pada emulator dan perangkat Android fisik melalui `flutter run`, memanfaatkan *hot reload* untuk mempercepat iterasi. Tahap akhir adalah dokumentasi hasil dan penyusunan makalah penelitian sebagai bentuk pelaporan ilmiah.

---

# 🔍 **Sumber Referensi**

Semua referensi menggunakan format (Someone, 2025) sesuai permintaan.

* Nielsen, J. (2025). *Interaction Principles & User Experience Rules*. Nielsen Norman Group.
* Google Material Design Team. (2025). *Material Design Components & Guidelines*. Google Developers.
* Flutter Team. (2025). *Run & Debug Flutter Apps*. Flutter.dev.
* MySQL Documentation Team. (2025). *Relational Database Fundamentals*. Oracle.
* REST API Best Practices (2025). *Designing Scalable API Endpoints*.

---


# 🎉 **Terima Kasih!**

Selamat menggunakan dan mengembangkan aplikasi ini.
Jika ingin saya buatkan **ikon, dokumentasi PDF, atau diagram gambar**, tinggal beri tahu saja!
