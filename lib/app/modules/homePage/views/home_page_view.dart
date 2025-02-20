import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';
import 'package:jim/core/widgets/anatomy.dart';
import 'package:jim/core/widgets/progress.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                // Header with Profile
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
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.accentRed,
                      child:
                          Icon(Icons.sports_gymnastics, color: AppColors.white),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Motivational Quote Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
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
                            padding: EdgeInsets.symmetric(
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
                          SizedBox(height: 16),
                          Text(
                            'The only bad workout is the one that didn\'t happen.',
                            style: AppStyles.heading3.copyWith(
                              color: AppColors.white,
                              height: 1.4,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 12),
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
                              SizedBox(width: 8),
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

                SizedBox(height: 24),

                // Weekly Progress with Muscle Anatomy
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: AppStyles.heading3
                            .copyWith(color: AppColors.accentGreen),
                      ),
                      SizedBox(height: 20),
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

                SizedBox(height: 24),

                // Weight Progress Chart
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
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
                      SizedBox(height: 20),
                      AspectRatio(
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
