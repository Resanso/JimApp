import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/constants/app_sizes.dart';
import '../controllers/do_exercise_controller.dart';

/// Widget untuk menampilkan dan mengelola latihan yang sedang dilakukan.
///
/// View ini menangani:
/// - Tampilan latihan aktif
/// - Tampilan waktu istirahat
/// - Tampilan selesai latihan
/// - Progress bar latihan
/// - Detail latihan seperti set, repetisi, dan berat
class DoExerciseView extends GetView<DoExerciseController> {
  final String splitId;
  final Map<String, dynamic> workouts;

  const DoExerciseView({
    required this.splitId,
    required this.workouts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(DoExerciseController(splitId: splitId, workouts: workouts));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Obx(() => Text(
                  controller.currentExerciseName.value,
                  style: AppStyles.heading3.copyWith(color: Colors.white),
                )),
            Obx(() => Text(
                  'Exercise ${controller.currentExerciseIndex.value + 1}/${controller.totalExercises.value}',
                  style: AppStyles.body2.copyWith(color: Colors.white70),
                )),
          ],
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isWorkoutComplete.value) {
          return _buildCompletionView();
        }

        if (controller.isResting.value) {
          return _buildRestingView();
        }

        return Stack(
          children: [
            // Progress bar at the top
            SizedBox(
              height: 4,
              child: Obx(() => LinearProgressIndicator(
                    value: controller.workoutProgress.value,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentGreen),
                  )),
            ),
            Column(
              children: [
                if (controller.currentExerciseImage.value.isNotEmpty)
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          controller.currentExerciseImage.value,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildExerciseStats(),
                          const SizedBox(height: AppSizes.spaceMedium),
                          _buildExerciseDetails(),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildActionPanel(),
              ],
            ),
          ],
        );
      }),
    );
  }

  /// Widget untuk menampilkan tampilan setelah latihan selesai.
  /// Menampilkan animasi check mark dan tombol untuk kembali.
  Widget _buildCompletionView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.secondaryDark,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.accentGreen,
                size: 100,
              ),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            Text(
              'Workout Complete!',
              style: AppStyles.heading1.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'Great job! Keep pushing yourself!',
              style: AppStyles.body1.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceLarge,
                  vertical: AppSizes.spaceMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Finish', style: AppStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan tampilan saat waktu istirahat.
  /// Menampilkan countdown timer dan informasi latihan berikutnya.
  Widget _buildRestingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.secondaryDark,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rest Time',
              style: AppStyles.heading2.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentGreen.withOpacity(0.3),
                  width: 4,
                ),
              ),
              child: Center(
                child: Obx(() => Text(
                      '${controller.restTimeRemaining.value}',
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.accentGreen,
                        fontSize: 72,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            Text(
              'Next up: ${controller.nextExerciseName.value}',
              style: AppStyles.body1.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            ElevatedButton(
              onPressed: controller.skipRest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceLarge,
                  vertical: AppSizes.spaceMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Skip Rest',
                style: AppStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan statistik latihan saat ini.
  /// Termasuk informasi set, repetisi, berat, dan waktu istirahat.
  Widget _buildExerciseStats() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('Set',
              '${controller.currentSet.value}/${controller.totalSets.value}'),
          _buildStatColumn('Reps', '${controller.currentReps.value}'),
          _buildStatColumn('Weight', '${controller.currentWeight.value}kg'),
          _buildStatColumn('Rest', '${controller.currentRestTime.value}s'),
        ],
      ),
    );
  }

  /// Widget helper untuk membuat kolom statistik individual.
  /// [label] adalah label statistik (contoh: "Set", "Reps")
  /// [value] adalah nilai statistik yang ditampilkan
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppStyles.body2.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.heading3.copyWith(color: AppColors.accentGreen),
        ),
      ],
    );
  }

  /// Widget untuk menampilkan detail lengkap latihan.
  /// Termasuk target otot dan instruksi gerakan.
  Widget _buildExerciseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSection(
          'Target Muscles',
          controller.currentTargetMuscles.value,
          Icons.fitness_center,
        ),
        const SizedBox(height: AppSizes.spaceMedium),
        _buildDetailSection(
          'Instructions',
          controller.currentMovements.value,
          Icons.description,
        ),
      ],
    );
  }

  /// Widget helper untuk membuat bagian detail dengan judul dan konten.
  /// [title] adalah judul bagian
  /// [content] adalah isi/deskripsi
  /// [icon] adalah ikon yang ditampilkan di sebelah judul
  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentGreen, size: 20),
              const SizedBox(width: AppSizes.spaceSmall),
              Text(title, style: AppStyles.heading3),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(content, style: AppStyles.body1),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan panel aksi di bagian bawah layar.
  /// Berisi informasi set saat ini dan tombol untuk menyelesaikan set.
  Widget _buildActionPanel() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Set ${controller.currentSet.value}',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            '${controller.currentReps.value} reps × ${controller.currentWeight.value}kg',
            style: AppStyles.body1.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          ElevatedButton(
            onPressed: controller.completeSet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGreen,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Complete Set',
              style: AppStyles.button.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
