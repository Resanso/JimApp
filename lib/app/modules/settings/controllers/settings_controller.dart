import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jim/app/services/auth_service.dart';

/// Controller untuk mengelola pengaturan aplikasi
///
/// Controller ini menangani fungsi-fungsi terkait pengaturan aplikasi
/// seperti logout dan perhitungan sederhana
class SettingsController extends GetxController {
  /// Instance Firebase Auth untuk autentikasi
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Variable observable untuk menyimpan hitungan
  final count = 0.obs;

  /// Method yang dipanggil saat controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
  }

  /// Method yang dipanggil saat controller siap digunakan
  @override
  void onReady() {
    super.onReady();
  }

  /// Method yang dipanggil saat controller dihapus dari memori
  @override
  void onClose() {}

  /// Method untuk menambah nilai hitungan
  void increment() => count.value++;

  /// Method untuk melakukan proses logout
  ///
  /// Fungsi ini akan:
  /// 1. Menghapus status login di Hive
  /// 2. Melakukan sign out dari Firebase
  /// 3. Mengarahkan pengguna ke halaman login
  ///
  /// Throws error jika proses logout gagal
  Future<void> logout() async {
    try {
      await AuthService.clearLoginStatus();
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
