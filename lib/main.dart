import 'package:firebase_core/firebase_core.dart';
import 'package:jim/app/modules/loginPage/controllers/login_page_controller.dart';
import 'package:jim/app/modules/settings/controllers/settings_controller.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:jim/app/modules/exercisePage/views/exercise_page_view.dart';
import 'package:jim/app/modules/homePage/controllers/home_page_controller.dart';
import 'package:jim/app/modules/homePage/views/home_page_view.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jim/app/modules/settings/views/settings_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';
import 'package:jim/app/modules/exercisePage/controllers/exercise_page_controller.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/app/services/auth_service.dart';

/// Fungsi utama aplikasi yang menginisialisasi semua dependensi yang diperlukan
/// dan memulai aplikasi Flutter
void main() async {
  // Inisialisasi binding Flutter untuk memastikan widget dapat diinisialisasi
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Inisialisasi Firebase dengan konfigurasi platform yang sesuai
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Inisialisasi Hive untuk penyimpanan lokal
  await AuthService.initialize();

  /// Mendaftarkan controller-controller yang akan digunakan secara global
  /// dengan pengaturan permanent: true agar tidak di-dispose
  Get.put<AnatomyController>(AnatomyController(), permanent: true);
  Get.put<ExercisePageController>(ExercisePageController(), permanent: true);
  Get.put<LoginPageController>(LoginPageController(), permanent: true);
  Get.put<SettingsController>(SettingsController(), permanent: true);

  runApp(const MyApp());
}

/// Widget utama aplikasi yang mengatur tema dan konfigurasi dasar
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      /// Mengatur ukuran desain dasar untuk responsive UI
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JimApp',

          /// Mengatur rute awal berdasarkan status login pengguna
          initialRoute: AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,

          /// Konfigurasi tema aplikasi
          theme: ThemeData(
            fontFamily: 'PlusJakartaSans', // Font default
            scaffoldBackgroundColor: AppColors.primaryDark, // Warna background
            textTheme: AppStyles.textTheme, // Text theme dari AppStyles
            inputDecorationTheme:
                AppStyles.inputDecoration, // Style input field
            cardTheme: AppStyles.cardTheme, // Style card
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: AppStyles.primaryButton, // Style tombol primary
            ),
          ),
        );
      },
    );
  }
}

/// Widget yang menangani tampilan utama dengan navigasi bottom bar
class MainScreen extends StatelessWidget {
  MainScreen({super.key}); // Add key parameter

  /// Controller untuk mengatur navigasi halaman
  final controller = Get.put(HomePageController());

  /// Daftar halaman yang dapat diakses melalui bottom navigation
  final List<Widget> _pages = [
    const HomePageView(),
    const ExercisePageView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Mengaktifkan body yang dapat extend ke bawah navigation bar
      extendBody: true,

      /// Menggunakan Obx untuk reaktivitas saat pergantian halaman
      body: Obx(() => _pages[controller.currentIndex.value]),

      /// Bottom navigation bar dengan animasi curved
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: AppColors.white),
          ),

          /// Menggunakan CurvedNavigationBar untuk tampilan yang menarik
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: AppColors.secondaryDark,
            buttonBackgroundColor: AppColors.accentRed,
            height: 60,
            animationDuration: const Duration(milliseconds: 300),
            index: controller.currentIndex.value,
            onTap: controller.changePage,
            items: const [
              Icon(Icons.home_rounded, size: 26),
              Icon(Icons.fitness_center_rounded, size: 26),
              Icon(Icons.settings_rounded, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
