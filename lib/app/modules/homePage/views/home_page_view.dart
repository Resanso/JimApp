import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';
import 'package:jim/core/widgets/anatomy.dart';
import 'package:jim/core/widgets/progress.dart';
import '../controllers/home_page_controller.dart';

/// HomePageView adalah widget utama yang menampilkan halaman beranda aplikasi.
/// Widget ini menggunakan GetX untuk manajemen state dan menampilkan beberapa
/// bagian utama seperti profil pengguna, kutipan motivasi, progress mingguan,
/// dan grafik perkembangan berat badan.
class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller untuk mengatur tampilan anatomi otot
    final anatomyController = Get.find<AnatomyController>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Header dengan Profil
                // Menampilkan pesan sambutan dan avatar pengguna
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: AppStyles.heading2
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.accentRed,
                      child:
                          Icon(Icons.sports_gymnastics, color: AppColors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Bagian Kutipan Motivasi
                // Menampilkan kutipan motivasi harian dengan desain yang menarik
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Icon(
                          Icons.format_quote,
                          color: AppColors.accentRed.withOpacity(0.1),
                          size: 80,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'TODAY\'S MOTIVATION',
                              style: AppStyles.body2.copyWith(
                                color: AppColors.accentRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'The only bad workout is the one that didn\'t happen.',
                            style: AppStyles.heading3.copyWith(
                              color: AppColors.white,
                              height: 1.4,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: AppColors.accentRed,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fitness Wisdom',
                                style: AppStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bagian Progress Mingguan dengan Anatomi Otot
                // Menampilkan visualisasi otot yang telah dilatih dalam seminggu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Muscle work this week',
                        style: AppStyles.heading3
                            .copyWith(color: AppColors.accentGreen),
                      ),
                      const SizedBox(height: 20),
                      // Widget MuscleAnatomy menampilkan visualisasi otot
                      // dengan warna yang menunjukkan intensitas latihan
                      AspectRatio(
                        aspectRatio: 1,
                        child: MuscleAnatomy(
                          trainedMuscles: anatomyController.trainedMuscles,
                          colorCallback: anatomyController.getMuscleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bagian Grafik Progress Berat Badan
                // Menampilkan grafik perkembangan berat badan dari waktu ke waktu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Progress',
                        style: AppStyles.heading3
                            .copyWith(color: AppColors.accentRed),
                      ),
                      const SizedBox(height: 20),
                      // Widget ProgressTracker menampilkan grafik progress
                      const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ProgressTracker(),
                      ),
                    ],
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
