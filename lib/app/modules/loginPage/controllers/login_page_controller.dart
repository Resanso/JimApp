import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/main.dart'; // Add this import
import 'package:jim/app/services/auth_service.dart';

class LoginPageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        isLoading.value = false;
        return;
      }

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await AuthService.saveLoginStatus(userCredential.user!.uid);

      // Perbaikan navigasi
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
