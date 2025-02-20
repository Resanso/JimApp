import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import '../controllers/register_page_controller.dart';

class RegisterPageView extends GetView<RegisterPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Register', style: AppStyles.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              style: AppStyles.body1,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.secondaryDark,
              ),
            ),
            SizedBox(height: 16),
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
                      controller.isLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Register', style: AppStyles.button),
                )),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: AppColors.accentGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
