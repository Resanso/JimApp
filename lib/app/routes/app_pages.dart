import 'package:get/get.dart';

import 'package:jim/app/modules/RegisterPage/bindings/register_page_binding.dart';
import 'package:jim/app/modules/RegisterPage/views/register_page_view.dart';
import 'package:jim/app/modules/addSplit/bindings/add_split_binding.dart';
import 'package:jim/app/modules/addSplit/views/add_split_view.dart';
import 'package:jim/app/modules/doExercise/controllers/do_exercise_controller.dart';
import 'package:jim/app/modules/doExercise/views/do_exercise_view.dart';
import 'package:jim/app/modules/exercisePage/bindings/exercise_page_binding.dart';
import 'package:jim/app/modules/exercisePage/views/exercise_page_view.dart';
import 'package:jim/app/modules/homePage/bindings/home_page_binding.dart';
import 'package:jim/app/modules/loginPage/bindings/login_page_binding.dart';
import 'package:jim/app/modules/loginPage/views/login_page_view.dart';
import 'package:jim/app/modules/settings/bindings/settings_binding.dart';
import 'package:jim/app/modules/settings/views/settings_view.dart';
import 'package:jim/main.dart';

part 'app_routes.dart';

/// Kelas abstrak yang menyimpan semua konstanta rute dalam aplikasi
abstract class Routes {
  Routes._();

  /// Rute untuk halaman utama
  // ignore: constant_identifier_names
  static const HOME = '/home';

  /// Rute untuk halaman latihan
  // ignore: constant_identifier_names
  static const EXERCISE = '/exercise-page';

  /// Rute untuk halaman pengaturan
  // ignore: constant_identifier_names
  static const SETTINGS = '/settings';

  /// Rute untuk halaman login
  // ignore: constant_identifier_names
  static const LOGIN = '/login';

  /// Rute untuk halaman registrasi
  // ignore: constant_identifier_names
  static const REGISTER = '/register';

  /// Rute untuk halaman menambah split latihan
  // ignore: constant_identifier_names
  static const ADD_SPLIT = '/add-split';

  /// Rute untuk halaman melakukan latihan
  // ignore: constant_identifier_names
  static const DO_EXERCISE = '/do-exercise';
}

/// Kelas yang mengatur semua konfigurasi halaman dalam aplikasi
class AppPages {
  AppPages._();

  /// Rute awal saat aplikasi pertama kali dibuka
  // ignore: constant_identifier_names
  static const INITIAsL = Routes.LOGIN;

  /// Daftar semua rute dan konfigurasi halaman dalam aplikasi
  ///
  /// Setiap GetPage berisi:
  /// - name: Nama rute yang didefinisikan di Routes
  /// - page: Widget halaman yang akan ditampilkan
  /// - binding: Dependency injection untuk halaman tersebut
  static final routes = [
    /// Konfigurasi halaman utama
    GetPage(
      name: Routes.HOME,
      page: () => MainScreen(),
      binding: HomePageBinding(),
    ),

    /// Konfigurasi halaman latihan
    GetPage(
      name: Routes.EXERCISE,
      page: () => const ExercisePageView(),
      binding: ExercisePageBinding(),
    ),

    /// Konfigurasi halaman pengaturan
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),

    /// Konfigurasi halaman tambah split latihan
    GetPage(
      name: Routes.ADD_SPLIT,
      page: () => AddSplitView(),
      binding: AddSplitBinding(),
    ),

    /// Konfigurasi halaman melakukan latihan
    /// Menerima parameter splitId dan workouts melalui Get.arguments
    GetPage(
      name: Routes.DO_EXERCISE,
      page: () {
        final Map<String, dynamic> args = Get.arguments ?? {};
        return DoExerciseView(
          splitId: args['splitId'] ?? '',
          workouts: args['workouts'] ?? {},
        );
      },
      binding: BindingsBuilder(() {
        Get.lazyPut<DoExerciseController>(
          () => DoExerciseController(
            splitId: Get.arguments['splitId'] ?? '',
            workouts: Get.arguments['workouts'] ?? {},
          ),
        );
      }),
    ),

    /// Konfigurasi halaman login
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),

    /// Konfigurasi halaman registrasi
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterPageView(),
      binding: RegisterPageBinding(),
    ),
  ];
}
