import 'package:get/get.dart';
import '../controllers/do_exercise_controller.dart';

/// DoExerciseBinding adalah kelas yang mengatur dependency injection untuk modul DoExercise
///
/// Kelas ini mengimplementasikan Bindings dari GetX untuk menginisialisasi
/// controller yang dibutuhkan sebelum halaman DoExercise ditampilkan
class DoExerciseBinding extends Bindings {
  @override
  void dependencies() {
    /// Mendaftarkan DoExerciseController ke dalam dependency injection GetX
    ///
    /// Controller diinisialisasi dengan lazy loading (hanya saat dibutuhkan)
    /// Menerima 2 parameter dari arguments:
    /// - splitId: String ID dari split workout yang dipilih
    /// - workouts: Map data latihan yang akan dilakukan
    Get.lazyPut<DoExerciseController>(
      () => DoExerciseController(
        splitId: Get.arguments['splitId'] ?? '',
        workouts: Get.arguments['workouts'] ?? {},
      ),
    );
  }
}
