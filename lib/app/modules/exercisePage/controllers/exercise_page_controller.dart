import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controller untuk mengelola halaman latihan (Exercise Page)
/// Menggunakan GetX untuk state management dan Firebase Firestore untuk database
class ExercisePageController extends GetxController {
  /// Instance Firestore untuk mengakses database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Variable observable untuk menghitung
  final count = 0.obs;

  /// Method yang dipanggil saat controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
  }

  /// Method yang dipanggil saat halaman siap ditampilkan
  @override
  void onReady() {
    super.onReady();
  }

  /// Method yang dipanggil saat controller dihapus dari memori
  @override
  void onClose() {}

  /// Method untuk menambah nilai count
  void increment() => count.value++;

  /// Method untuk menghapus split workout dari database
  /// [splitId] adalah ID unik dari split yang akan dihapus
  Future<void> deleteSplit(String splitId) async {
    try {
      // Menghapus dokumen split dari collection users_splits
      await _firestore.collection('users_splits').doc(splitId).delete();

      // Menampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Split deleted successfully',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting split: $e'); // Untuk debugging

      // Menampilkan notifikasi error
      Get.snackbar(
        'Error',
        'Failed to delete split',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
