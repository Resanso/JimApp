import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/app/modules/addSplit/views/add_split_view.dart';
import 'package:jim/app/modules/doExercise/views/do_exercise_view.dart';
import 'package:jim/app/routes/app_pages.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/constants/app_sizes.dart';
import 'package:jim/core/widgets/addWorkout.dart';
import 'package:jim/core/widgets/workout_detail_popup.dart';
import '../controllers/exercise_page_controller.dart';

class ExercisePageView extends GetView<ExercisePageController> {
  const ExercisePageView({Key? key}) : super(key: key);

  Future<void> _showDeleteConfirmation(
      BuildContext context, String splitId, String splitName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryDark,
          title: Text('Delete Split', style: AppStyles.heading3),
          content: Text(
            'Are you sure you want to delete "$splitName"?',
            style: AppStyles.body1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: AppStyles.body2),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.deleteSplit(splitId);
              },
              child: Text(
                'Delete',
                style: AppStyles.body2.copyWith(color: AppColors.accentRed),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditWorkoutDialog(BuildContext context, DocumentSnapshot split,
      String day, Map<String, dynamic> workoutDetail) {
    // Add null checks and default values
    final workoutId = workoutDetail['workoutId'] as String?;
    if (workoutId == null) {
      print('Error: workoutId is null');
      return;
    }

    // Initialize controllers with existing values or defaults
    final sets =
        TextEditingController(text: (workoutDetail['sets']?.toString() ?? '3'));
    final reps = TextEditingController(
        text: (workoutDetail['reps']?.toString() ?? '12'));
    final weight = TextEditingController(
        text: (workoutDetail['weight']?.toString() ?? '0'));
    final restTime = TextEditingController(
        text: (workoutDetail['restTime']?.toString() ?? '60'));

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Edit workout details', style: AppStyles.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sets,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sets',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            TextField(
              controller: reps,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            TextField(
              controller: weight,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            TextField(
              controller: restTime,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Rest Time (seconds)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppStyles.body2),
          ),
          TextButton(
            onPressed: () async {
              try {
                final updatedWorkoutDetail = {
                  'workoutId': workoutId,
                  'sets': int.parse(sets.text),
                  'reps': int.parse(reps.text),
                  'weight': double.parse(weight.text),
                  'restTime': int.parse(restTime.text),
                };

                final schedule =
                    Map<String, dynamic>.from(split['schedule'] as Map);
                final dayWorkouts = List<dynamic>.from(schedule[day] as List);

                final workoutIndex =
                    dayWorkouts.indexWhere((w) => w['workoutId'] == workoutId);

                if (workoutIndex != -1) {
                  dayWorkouts[workoutIndex] = updatedWorkoutDetail;
                  schedule[day] = dayWorkouts;

                  await FirebaseFirestore.instance
                      .collection('users_splits')
                      .doc(split.id)
                      .update({'schedule': schedule});
                }

                Get.back();
              } catch (e) {
                print('Error updating workout: $e');
                Get.snackbar(
                  'Error',
                  'Failed to update workout details',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Text('Save', style: TextStyle(color: AppColors.accentGreen)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Workout Schedule',
          style: AppStyles.heading2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSizes.spaceMedium),
            child: IconButton(
              icon: Icon(
                Icons.fitness_center,
                color: AppColors.accentGreen,
              ),
              onPressed: () => Get.to(() => const AddWorkoutScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.secondaryDark.withOpacity(0.95),
            ],
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users_splits')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.accentGreen),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 80,
                      color: AppColors.accentGreen.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Text(
                      'No workout schedules yet\nCreate your first split!',
                      textAlign: TextAlign.center,
                      style: AppStyles.heading3.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 40,
                bottom: 120, // Increased from 100 to 120 for more space
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, splitIndex) {
                final split = snapshot.data!.docs[splitIndex];
                final schedule = split['schedule'] as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMedium,
                    vertical: AppSizes.spaceSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Split Header
                      Container(
                        padding: const EdgeInsets.all(AppSizes.spaceMedium),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentRed.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                split['name'],
                                style: AppStyles.heading2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_fill),
                              color: Colors.white,
                              onPressed: () => Get.toNamed(
                                Routes.DO_EXERCISE,
                                arguments: {
                                  'splitId': split.id,
                                  'workouts': schedule,
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.white,
                              onPressed: () => _showDeleteConfirmation(
                                context,
                                split.id,
                                split['name'],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Workout Days Timeline
                      ...schedule.entries.map((entry) {
                        final day = entry.key;
                        final workouts = entry.value as List;

                        return Container(
                          margin:
                              const EdgeInsets.only(top: AppSizes.spaceMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Day Header
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.spaceMedium,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          day[0],
                                          style: AppStyles.heading3.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.spaceSmall),
                                    Text(
                                      day,
                                      style: AppStyles.heading3.copyWith(
                                        color: AppColors.accentGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Workout Items
                              Container(
                                margin: const EdgeInsets.only(left: 47),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: AppColors.accentGreen
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: workouts.map((workout) {
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('workouts')
                                          .doc(workout['workoutId'])
                                          .get(),
                                      builder: (context, workoutSnapshot) {
                                        if (!workoutSnapshot.hasData) {
                                          return const SizedBox.shrink();
                                        }

                                        final workoutData =
                                            workoutSnapshot.data!.data()
                                                as Map<String, dynamic>?;
                                        if (workoutData == null) {
                                          return const SizedBox.shrink();
                                        }

                                        return Container(
                                          margin: const EdgeInsets.only(
                                            left: AppSizes.spaceMedium,
                                            bottom: AppSizes.spaceSmall,
                                          ),
                                          child: InkWell(
                                            onTap: () => showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  WorkoutDetailPopup(
                                                workoutData: workoutData,
                                              ),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                AppSizes.spaceMedium,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryDark
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: AppColors.accentGreen
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  if (workoutData['image'] !=
                                                      null)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        workoutData['image'],
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .accentGreen
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: const Icon(
                                                        Icons.fitness_center,
                                                        color: AppColors
                                                            .accentGreen,
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                      width:
                                                          AppSizes.spaceSmall),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          workoutData['name'],
                                                          style: AppStyles.body1
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          '${workout['sets']} sets × ${workout['reps']} reps • ${workout['weight']}kg',
                                                          style: AppStyles.body2
                                                              .copyWith(
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 20,
                                                    ),
                                                    color:
                                                        AppColors.accentGreen,
                                                    onPressed: () =>
                                                        _showEditWorkoutDialog(
                                                      context,
                                                      split,
                                                      day,
                                                      workout,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 80), // Add padding to lift the FAB
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accentRed, AppColors.accentRed.withRed(200)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentRed.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => Get.to(() => AddSplitView()),
            child: const Icon(Icons.add),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
