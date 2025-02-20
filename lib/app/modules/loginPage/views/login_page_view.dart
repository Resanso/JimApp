import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Login', style: AppStyles.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              style: AppStyles.body1,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.secondaryDark,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.passwordController,
              style: AppStyles.body1,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.secondaryDark,
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: AppColors.accentRed),
                  )
                : SizedBox()),
            SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Login', style: AppStyles.button),
                )),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.toNamed(Routes.REGISTER), // Updated route
              child: Text(
                'Don\'t have an account? Register',
                style: TextStyle(color: AppColors.accentGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
