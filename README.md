# 📝 Catatanku - Aplikasi Catatan Pribadi

**UTS Mobile Application Development - Semester 7**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-green?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Realtime-orange?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-success)](#lisensi)

---

## 📱 Deskripsi Aplikasi

**Catatanku** adalah aplikasi mobile modern untuk menyimpan catatan pribadi dengan mudah dan aman. Aplikasi ini dirancang untuk membantu pengguna dalam mengelola catatan harian mereka dengan fitur-fitur lengkap termasuk autentikasi, database cloud, dan tema gelap.

Aplikasi ini dibangun menggunakan **Flutter** sebagai framework UI dan **Firebase** sebagai backend untuk penyimpanan data yang realtime dan aman.

---

## ✨ Fitur Utama

### 🔐 1. Autentikasi Pengguna
- **Login/Register dengan Email & Password**
  - Validasi email format yang ketat
  - Password requirement minimal 6 karakter
  - Error handling yang user-friendly
  - Real-time validation feedback

- **Google Sign-In Integration**
  - Login dengan akun Google
  - Single-tap sign-in experience
  - Automatic profile sync
  - Error handling untuk Google API

**Error Handling:**
- ✅ User tidak ditemukan
- ✅ Password salah
- ✅ Email format tidak valid
- ✅ Email sudah terdaftar
- ✅ Akun dinonaktifkan
- ✅ Terlalu banyak percobaan login gagal

### 📝 2. Halaman Daftar Catatan
- **View Semua Catatan**
  - Display real-time dari Firestore
  - Sorted berdasarkan tanggal dibuat (newest first)
  - Angka catatan yang clear dan ringkas
  - Custom card design dengan shadow effect

- **Pencarian & Sorting**
  - Sort by date (created/updated)
  - Empty state message yang informatif
  - Pull-to-refresh functionality

- **Quick Actions**
  - Buka catatan untuk edit dengan 1 tap
  - Delete catatan dengan confirmation dialog
  - Akses settings dari halaman list

### ✏️ 3. Halaman Tambah/Edit Catatan
- **Create Catatan Baru**
  - Title input field
  - Content textarea dengan expand capability
  - Auto-save notification
  - Loading indicator saat menyimpan

- **Edit Catatan Existing**
  - Pre-populate fields dengan data lama
  - Update timestamp otomatis
  - Success/error notification
  - Prevent duplicate saves

**Validasi Input:**
- ✅ Title tidak boleh kosong
- ✅ Content tidak boleh kosong
- ✅ User authentication check
- ✅ Firestore permission validation

### 🎨 4. Pengaturan Tema (Dark Mode)
- **Theme Toggle**
  - Switch antara Light Mode dan Dark Mode
  - Smooth transition animations
  - Persistent preference dengan SharedPreferences
  - Automatic system theme detection

- **Theme Customization**
  - Primary color: Teal (#0FA3A3)
  - Light theme: Clean white background
  - Dark theme: Dark surface dengan proper contrast
  - Material Design 3 compliance

### 🎬 5. Splash Screen
- **Professional Loading Screen**
  - Logo animasi dengan shadow effect
  - Progress bar dengan smooth animation
  - Loading text indicator
  - Auto-redirect ke login/notes sesuai auth status
  - Duration: 3 detik dengan customizable timing

---

## 🏗️ Arsitektur Aplikasi

### Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **UI Framework** | Flutter | 3.0+ |
| **Language** | Dart | 3.0+ |
| **State Management** | Provider | 6.0.5 |
| **Backend** | Firebase | v3.0+ |
| **Database** | Firestore | Realtime |
| **Authentication** | Firebase Auth | v5.0+ |
| **Local Storage** | SharedPreferences | 2.1.1 |
| **Social Sign-In** | Google Sign-In | 6.2.0 |


## 🔒 Keamanan & Error Handling

### Authentication Errors (15+)
```
LOGIN:
├── user-not-found         → Email tidak terdaftar
├── wrong-password         → Password salah
├── invalid-email          → Format email tidak valid
├── user-disabled          → Akun sudah dinonaktifkan
└── too-many-requests      → Terlalu banyak percobaan

REGISTER:
├── weak-password          → Password terlalu lemah
├── email-already-in-use   → Email sudah terdaftar
├── invalid-email          → Format email tidak valid
└── operation-not-allowed  → Pendaftaran tidak tersedia

GOOGLE SIGN-IN:
├── account-exists-with-different-credential
├── invalid-credential     → Kredensial tidak valid
└── general-error          → Error umum
```

### Input Validation
- ✅ Email format validation dengan regex
- ✅ Password minimum 6 characters
- ✅ Password matching di register
- ✅ Non-empty field checks
- ✅ Title & content validation di notes

### UI/UX Error Feedback
- ✅ SnackBar notifications (2 detik duration)
- ✅ Red background untuk errors
- ✅ Green background untuk success
- ✅ AlertDialog untuk confirmations
- ✅ Loading indicators saat async operations
- ✅ Disabled buttons saat loading

---

## 📲 Instalasi & Setup

### Prerequisites
```bash
# Flutter SDK 3.0+
flutter --version

# Dart 3.0+
dart --version

# Android SDK (untuk build APK)
# Xcode (untuk build iOS)
```

### Installation Steps

#### 1. Clone Repository
```bash
git clone https://github.com/Affnsyhr/Catatanku-Mobile-App.git
cd Catatanku-Mobile-App
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Firebase Configuration
```bash
# Konfigurasi Firebase untuk project Anda
flutterfire configure

# Pilih platforms yang ingin dikonfigurasi:
# - Android
# - iOS
# - Web
```

#### 4. Run Aplikasi
```bash
# Run di emulator Android
flutter run

# Run di device fisik
flutter run -d <device-id>

# Run di Chrome (Web)
flutter run -d chrome

# Build APK release
flutter build apk --release

# Build iOS release
flutter build ios --release
```

---

## ⚙️ Konfigurasi

### Firebase Project Setup
```yaml
Project ID: hehe2-b05f5
Services:
  - Authentication (Email/Password + Google)
  - Firestore Database
  - Cloud Storage (ready)
```


## 🚀 Deployment

### Android APK
```bash
flutter build apk --release

# Output: build/app/outputs/flutter-app.apk
```

### iOS App Bundle
```bash
flutter build ios --release

# Output: build/ios/iphoneos/Runner.app
```

### Web Release
```bash
flutter build web --release

# Output: build/web/
```

---

## 🤝 Kontribusi & Pengembangan

### Feature Ideas untuk Future Development
- [ ] Offline mode dengan SQLite
- [ ] Push notifications untuk reminder
- [ ] Photo attachment di catatan
- [ ] Search & filter functionality
- [ ] Export catatan ke PDF
- [ ] Backup ke Google Drive
- [ ] Share catatan dengan user lain
- [ ] Tags & categories untuk organization
- [ ] Favorites/pinned notes
- [ ] Voice-to-text input

---

## 📝 Lisensi

MIT License - Silakan gunakan untuk tujuan educational dan commercial.

---

## 👨‍💻 Author & Credits

**Developed for**: UTS Mobile Application Development - Semester 7  
**Institution**: Universitas  
**Date**: 19 November 2025

**Technologies Used:**
- Flutter & Dart
- Firebase Authentication & Firestore
- Google Sign-In
- Provider State Management
- Material Design 3

---


## ✅ Checklist Completion

- ✅ Splash Screen dengan animasi loading
- ✅ Autentikasi email/password + Google Sign-In
- ✅ CRUD operations untuk catatan
- ✅ Real-time sync dengan Firestore
- ✅ Dark mode toggle
- ✅ Comprehensive error handling
- ✅ Professional UI/UX
- ✅ Production-ready code
- ✅ Full documentation

**Status**: 🚀 PRODUCTION READY

---

**Last Updated**: November 19, 2025  