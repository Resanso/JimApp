import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisePageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  Future<void> deleteSplit(String splitId) async {
    try {
      // Only delete the split document
      await _firestore.collection('users_splits').doc(splitId).delete();

      Get.snackbar(
        'Success',
        'Split deleted successfully',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Error deleting split: $e'); // For debugging
      Get.snackbar(
        'Error',
        'Failed to delete split',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
