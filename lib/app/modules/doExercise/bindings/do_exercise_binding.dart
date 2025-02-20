import 'package:get/get.dart';
import '../controllers/do_exercise_controller.dart';

class DoExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoExerciseController>(
      () => DoExerciseController(
        splitId: Get.arguments['splitId'] ?? '',
        workouts: Get.arguments['workouts'] ?? {},
      ),
    );
  }
}
