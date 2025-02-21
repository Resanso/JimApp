import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/app/services/auth_service.dart';

/// Controller untuk menangani logika halaman login
class LoginPageController extends GetxController {
  /// Instance Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Controller untuk input email
  final emailController = TextEditingController();

  /// Controller untuk input password
  final passwordController = TextEditingController();

  /// Status loading saat proses login
  final isLoading = false.obs;

  /// Pesan error yang akan ditampilkan ke user
  final errorMessage = ''.obs;

  /// Method untuk melakukan proses login
  ///
  /// Method ini akan:
  /// 1. Memvalidasi input email dan password
  /// 2. Melakukan autentikasi ke Firebase
  /// 3. Menyimpan status login user
  /// 4. Mengarahkan ke halaman home jika berhasil
  Future<void> login() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validasi input
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        isLoading.value = false;
        return;
      }

      // Proses autentikasi dengan Firebase
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Menyimpan status login
      await AuthService.saveLoginStatus(userCredential.user!.uid);

      // Navigasi ke halaman home
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      // Menangani berbagai error dari Firebase
      switch (e.code) {
        case 'user-not-found':
          errorMessage.value = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage.value = 'Wrong password provided.';
          break;
        default:
          errorMessage.value = 'Login failed. Please try again.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Method yang dipanggil saat controller dihapus
  ///
  /// Membersihkan controller untuk menghindari memory leak
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
