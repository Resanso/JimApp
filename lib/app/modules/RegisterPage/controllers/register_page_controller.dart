import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/main.dart';
import 'package:jim/app/services/auth_service.dart';

/// Controller untuk halaman registrasi yang menangani logika pendaftaran pengguna baru
/// menggunakan Firebase Authentication dan Firestore untuk penyimpanan data
class RegisterPageController extends GetxController {
  // Instance Firebase untuk autentikasi dan database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller untuk input field
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variable observable untuk status loading dan pesan error
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userId = ''.obs;

  /// Method untuk melakukan proses registrasi pengguna baru
  ///
  /// Proses yang dilakukan:
  /// 1. Validasi input dari pengguna
  /// 2. Membuat akun baru di Firebase Authentication
  /// 3. Menyimpan data tambahan pengguna di Firestore
  /// 4. Menyimpan status login
  /// 5. Mengarahkan ke halaman utama jika berhasil
  Future<void> register() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validasi input terlebih dahulu
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
      // Menangani berbagai error yang mungkin terjadi saat autentikasi
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
          // ignore: avoid_print
          print(
              'Firebase Auth Error: ${e.code} - ${e.message}'); // For debugging
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
      // ignore: avoid_print
      print('Unexpected Error: $e'); // For debugging
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengambil ID pengguna yang sedang login
  ///
  /// Returns:
  ///   String berupa user ID dari pengguna yang sedang login
  String getUserId() {
    return userId.value;
  }

  /// Dipanggil saat controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
  }

  /// Dipanggil saat halaman siap ditampilkan
  @override
  void onReady() {
    super.onReady();
  }

  /// Dipanggil saat controller dihancurkan
  /// Membersihkan controller untuk mencegah memory leak
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
