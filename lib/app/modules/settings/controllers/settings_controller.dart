import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jim/app/services/auth_service.dart'; // Add this import

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> logout() async {
    try {
      // Clear Hive login status before signing out
      await AuthService.clearLoginStatus();
      await _auth.signOut();
      Get.offAllNamed('/login'); // Navigate to login page
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
