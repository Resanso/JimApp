import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import '../controllers/register_page_controller.dart';

class RegisterPageView extends GetView<RegisterPageController> {
  @override
  Widget build(BuildContext context) {
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
                // Lottie Animation
                Lottie.asset(
                  'assets/lottie.json',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: AppStyles.heading1.copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your fitness journey today',
                  style: AppStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Name field
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
                    controller: controller.nameController,
                    style: AppStyles.body1,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon:
                          Icon(Icons.person, color: AppColors.accentRed),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Email field
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
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email, color: AppColors.accentRed),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
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
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Create password',
                      prefixIcon: Icon(Icons.lock, color: AppColors.accentRed),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: AppColors.accentRed),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox()),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
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
                            : Text('Register', style: AppStyles.button),
                      )),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Already have an account? Login',
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
