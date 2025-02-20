import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/main.dart';
import 'package:jim/app/services/auth_service.dart';

class RegisterPageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userId = ''.obs; // Add this line

  Future<void> register() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs first
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: emailController.text.trim(),
      );

      // Store userId
      userId.value = userCredential.user!.uid;

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(userId.value).set({
        'userId': userId.value, // Add userId to Firestore
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Save login status after successful registration
      await AuthService.saveLoginStatus(userId.value);

      Get.off(() => MainScreen()); // Changed to use MainScreen
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          errorMessage.value = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage.value = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage.value = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage.value = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage.value = 'Registration failed. Please try again.';
          print(
              'Firebase Auth Error: ${e.code} - ${e.message}'); // For debugging
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
      print('Unexpected Error: $e'); // For debugging
    } finally {
      isLoading.value = false;
    }
  }

  // Get userId method
  String getUserId() {
    return userId.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
