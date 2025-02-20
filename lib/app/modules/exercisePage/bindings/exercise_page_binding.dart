import 'package:get/get.dart';

import '../controllers/exercise_page_controller.dart';

class ExercisePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisePageController>(
      () => ExercisePageController(),
    );
  }
}
