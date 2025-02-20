import 'package:get/get.dart';

import 'package:jim/app/modules/RegisterPage/bindings/register_page_binding.dart';
import 'package:jim/app/modules/RegisterPage/views/register_page_view.dart';
import 'package:jim/app/modules/addSplit/bindings/add_split_binding.dart';
import 'package:jim/app/modules/addSplit/views/add_split_view.dart';
import 'package:jim/app/modules/doExercise/bindings/do_exercise_binding.dart';
import 'package:jim/app/modules/doExercise/controllers/do_exercise_controller.dart';
import 'package:jim/app/modules/doExercise/views/do_exercise_view.dart';
import 'package:jim/app/modules/exercisePage/bindings/exercise_page_binding.dart';
import 'package:jim/app/modules/exercisePage/views/exercise_page_view.dart';
import 'package:jim/app/modules/homePage/bindings/home_page_binding.dart';
import 'package:jim/app/modules/homePage/views/home_page_view.dart';
import 'package:jim/app/modules/loginPage/bindings/login_page_binding.dart';
import 'package:jim/app/modules/loginPage/views/login_page_view.dart';
import 'package:jim/app/modules/settings/bindings/settings_binding.dart';
import 'package:jim/app/modules/settings/views/settings_view.dart';
import 'package:jim/main.dart';

part 'app_routes.dart';

abstract class Routes {
  Routes._();
  static const HOME = '/home';
  static const EXERCISE = '/exercise-page';
  static const SETTINGS = '/settings';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ADD_SPLIT = '/add-split';
  static const DO_EXERCISE = '/do-exercise';
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN; // Changed initial route to login

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => MainScreen(), // Ubah ke MainScreen
      binding: HomePageBinding(),
    ),
    GetPage(
      name: Routes.EXERCISE,
      page: () => ExercisePageView(),
      binding: ExercisePageBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.ADD_SPLIT,
      page: () => AddSplitView(),
      binding: AddSplitBinding(),
    ),
    GetPage(
      name: Routes.DO_EXERCISE,
      page: () {
        final Map<String, dynamic> args = Get.arguments ?? {};
        return DoExerciseView(
          splitId: args['splitId'] ?? '',
          workouts:
              args['workouts'] ?? {}, // Changed from users_splits to workouts
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
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPageView(),
      binding: RegisterPageBinding(),
    ),
  ];
}
