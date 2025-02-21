import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import '../controllers/settings_controller.dart';

/// Widget untuk menampilkan halaman pengaturan aplikasi.
///
/// Halaman ini menampilkan daftar pengaturan yang tersedia dan tombol logout.
/// Menggunakan GetX untuk manajemen state dan navigasi.
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Membangun tampilan utama halaman pengaturan
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Settings', style: AppStyles.heading2),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tempat untuk menambahkan item pengaturan lainnya

          // Tombol Logout
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: AppColors.secondaryDark,
            leading: const Icon(Icons.logout, color: AppColors.accentRed),
            title: Text('Logout', style: AppStyles.body1),
            onTap: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
    );
  }

  /// Menampilkan dialog konfirmasi sebelum melakukan logout.
  ///
  /// [context] adalah BuildContext yang digunakan untuk menampilkan dialog.
  /// Dialog ini memberikan pilihan untuk membatalkan atau melanjutkan proses logout.
  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Logout', style: AppStyles.heading3),
        content: Text(
          'Are you sure you want to logout?',
          style: AppStyles.body1,
        ),
        actions: [
          // Tombol untuk membatalkan logout
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          // Tombol untuk mengkonfirmasi logout
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.accentRed),
            ),
          ),
        ],
      ),
    );
  }
}
