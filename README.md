# JimApp

JimApp adalah aplikasi gym yang komprehensif yang dirancang untuk membantu pengguna melacak kemajuan latihan mereka, memvisualisasikan keterlibatan otot, dan mengelola rutinitas latihan dengan efisien. Aplikasi ini menawarkan tiga fitur utama: Muscle Work This Week, Weight Tracking, dan Do Exercise.

## Fitur

### 1. Muscle Work This Week
Fitur ini memungkinkan pengguna untuk melihat otot mana saja yang telah dilatih selama minggu ini. Ini memberikan representasi visual dari keterlibatan otot, membantu pengguna memastikan latihan yang seimbang.

### 2. Weight Tracking
Lacak kemajuan Anda berdasarkan total beban yang diangkat. Fitur ini menampilkan kemajuan Anda dalam bentuk grafik, sehingga mudah untuk melihat peningkatan dari waktu ke waktu.

### 3. Do Exercise
Fitur ini membantu pengguna dalam mengelola rutinitas latihan mereka dengan melacak beban, repetisi, dan set untuk setiap latihan. Pengguna tidak perlu lagi mengingat detail ini, karena aplikasi akan melakukannya untuk mereka.

## Instalasi

1. **Clone repository:**
   ```sh
   git clone https://github.com/yourusername/jimapp.git
   cd jimapp
2. **Install dependencies:**
   flutter pub get
3. **Run the App**
   flutter run
   
## Dependencies
- firebase_core: Untuk inisialisasi Firebase.
- flutter_native_splash: Untuk menampilkan splash screen.
- flutter_screenutil: Untuk desain UI responsif.
- get: Untuk manajemen state dan navigasi.
- curved_navigation_bar: Untuk tampilan bottom navigation bar yang menarik.

## Struktur Proyek
lib/
├── app/
│   ├── modules/
│   │   ├── exercisePage/
│   │   │   ├── controllers/
│   │   │   │   └── exercise_page_controller.dart
│   │   │   └── views/
│   │   │       └── exercise_page_view.dart
│   │   ├── homePage/
│   │   │   ├── controllers/
│   │   │   │   └── home_page_controller.dart
│   │   │   └── views/
│   │   │       └── home_page_view.dart
│   │   ├── loginPage/
│   │   │   ├── controllers/
│   │   │   │   └── login_page_controller.dart
│   │   ├── settings/
│   │   │   ├── controllers/
│   │   │   │   └── settings_controller.dart
│   │   │   └── views/
│   │   │       └── settings_view.dart
│   ├── routes/
│   │   └── app_pages.dart
│   ├── services/
│   │   └── auth_service.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_styles.dart
│   ├── controllers/
│   │   └── anatomy_controller.dart
├── main.dart

## Penggunaan :
## Muscle Work This Week
- Navigasikan ke Home Page untuk melihat keterlibatan otot selama minggu ini.
- Aplikasi akan menampilkan representasi visual dari otot yang dilatih.
## Weight Tracking
- Navigasikan ke bagian Weight Tracking untuk melihat kemajuan Anda.
- Aplikasi akan menampilkan grafik yang menunjukkan total beban yang diangkat dari waktu ke waktu.
## Do Exercise
- Navigasikan ke bagian Do Exercise untuk mengelola rutinitas latihan Anda.
- Aplikasi akan melacak beban, repetisi, dan set untuk setiap latihan.
