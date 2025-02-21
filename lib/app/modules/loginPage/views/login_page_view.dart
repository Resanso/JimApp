import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import '../controllers/login_page_controller.dart';

/// LoginPageView adalah widget yang menampilkan halaman login aplikasi.
/// Widget ini menggunakan GetX untuk state management dan merupakan implementasi dari GetView.
class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Membangun tampilan utama dengan Scaffold
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Menampilkan animasi Lottie sebagai ilustrasi
                Lottie.asset(
                  'assets/lottie.json',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                // Judul halaman login
                Text(
                  'Welcome Back!',
                  style: AppStyles.heading1.copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
                // Subtitle halaman login
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your fitness journey',
                  style: AppStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Field input email dengan dekorasi container
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.emailController,
                    style: AppStyles.body1,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email, color: AppColors.accentRed),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Field input password dengan dekorasi container
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.passwordController,
                    style: AppStyles.body1,
                    obscureText: true, // Menyembunyikan teks password
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock, color: AppColors.accentRed),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Menampilkan pesan error jika ada
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: AppColors.accentRed),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox()),
                const SizedBox(height: 32),
                // Tombol login dengan indikator loading
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null // Menonaktifkan tombol saat loading
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text('Login', style: AppStyles.button),
                      )),
                ),
                const SizedBox(height: 16),
                // Tombol untuk navigasi ke halaman registrasi
                TextButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  child: Text(
                    'Don\'t have an account? Register',
                    style: AppStyles.body2.copyWith(
                      color: AppColors.accentRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
