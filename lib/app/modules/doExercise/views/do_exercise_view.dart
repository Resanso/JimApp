import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/constants/app_sizes.dart';
import '../controllers/do_exercise_controller.dart';

class DoExerciseView extends GetView<DoExerciseController> {
  final String splitId;
  final Map<String, dynamic> workouts;

  const DoExerciseView({
    required this.splitId,
    required this.workouts,
    Key? key,
  }) : super(key: key);

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
            Container(
              height: 4,
              child: Obx(() => LinearProgressIndicator(
                    value: controller.workoutProgress.value,
                    backgroundColor: Colors.grey[800],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                  )),
            ),
            Column(
              children: [
                if (controller.currentExerciseImage.value.isNotEmpty)
                  Container(
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
                          decoration: BoxDecoration(
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

  Widget _buildCompletionView() {
    return Container(
      decoration: BoxDecoration(
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

  Widget _buildRestingView() {
    return Container(
      decoration: BoxDecoration(
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
          ],
        ),
      ),
    );
  }

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
