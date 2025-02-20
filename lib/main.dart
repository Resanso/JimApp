import 'package:firebase_core/firebase_core.dart';
import 'package:jim/app/modules/loginPage/controllers/login_page_controller.dart';
import 'package:jim/app/modules/loginPage/views/login_page_view.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await AuthService.initialize();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize controllers
  Get.put<AnatomyController>(AnatomyController(), permanent: true);
  Get.put<ExercisePageController>(ExercisePageController(), permanent: true);
  Get.put<LoginPageController>(LoginPageController(), permanent: true);
  Get.put<SettingsController>(SettingsController(), permanent: true);

  runApp(MyApp() // Gunakan MyApp() langsung, bukan GetMaterialApp baru
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Design size based on your mockup
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JimApp',
          initialRoute: AuthService.isLoggedIn()
              ? Routes.HOME
              : Routes.LOGIN, // Perbaikan route check
          getPages: AppPages.routes, // Add the routes configuration
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

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key); // Add key parameter

  final controller = Get.put(HomePageController());

  final List<Widget> _pages = [
    const HomePageView(),
    const ExercisePageView(),
    SettingsView(),
  ];
//bottom bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: CurvedNavigationBar(
            backgroundColor: AppColors.primaryDark,
            color: AppColors.secondaryDark,
            buttonBackgroundColor: AppColors.accentRed,
            height: 60,
            animationDuration: Duration(milliseconds: 300),
            index: controller.currentIndex.value,
            onTap: controller.changePage,
            items: [
              Icon(Icons.home_rounded, size: 26, color: AppColors.white),
              Icon(Icons.fitness_center_rounded,
                  size: 26, color: AppColors.white),
              Icon(Icons.settings_rounded, size: 26, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
