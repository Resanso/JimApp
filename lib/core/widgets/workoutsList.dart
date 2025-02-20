import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/app_sizes.dart';
import 'addWorkout.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  void _showWorkoutDetail(BuildContext context, Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spaceMedium),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workout['name'] ?? 'No name',
                    style: AppStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceMedium),
                  if (workout['image'] != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                      child: CachedNetworkImage(
                        imageUrl: workout['image'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          color: AppColors.accentGreen,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: AppColors.accentRed,
                          size: AppSizes.iconLarge,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.fitness_center,
                      size: AppSizes.iconLarge * 2,
                      color: AppColors.accentGreen,
                    ),
                  const SizedBox(height: AppSizes.spaceMedium),
                  Text(
                    'Target: ${workout['target_muscles'] ?? 'Not specified'}',
                    style: AppStyles.body1,
                  ),
                  const SizedBox(height: AppSizes.spaceMedium),
                  Text(
                    'Movements:',
                    style:
                        AppStyles.body1.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    workout['movements'] ?? 'Not specified',
                    style: AppStyles.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceMedium),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: AppStyles.button
                          .copyWith(color: AppColors.accentGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentGreen,
                ),
              );
            }

            var workouts = snapshot.data!.docs;
            if (workouts.isEmpty) {
              return Center(
                child: Text(
                  'No workouts found',
                  style: AppStyles.body1,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(AppSizes.spaceMedium),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppSizes.spaceMedium,
                mainAxisSpacing: AppSizes.spaceMedium,
              ),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                var workout = workouts[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: AppSizes.buttonElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  color: AppColors.secondaryDark,
                  child: InkWell(
                    onTap: () => _showWorkoutDetail(context, workout),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusMedium),
                            ),
                            child: workout['image'] != null
                                ? CachedNetworkImage(
                                    imageUrl: workout['image'],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      color: AppColors.accentGreen,
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.fitness_center,
                                      size: AppSizes.iconLarge,
                                      color: AppColors.accentGreen,
                                    ),
                                  )
                                : Icon(
                                    Icons.fitness_center,
                                    size: AppSizes.iconLarge,
                                    color: AppColors.accentGreen,
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.spaceSmall),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout['name'] ?? 'No name',
                                  style: AppStyles.heading3,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSizes.spaceSmall),
                                Text(
                                  'Target: ${workout['target_muscles'] ?? 'Not specified'}',
                                  style: AppStyles.body2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
          );
        },
        backgroundColor: AppColors.accentRed,
        child: Icon(
          Icons.add,
          color: AppColors.textPrimary,
          size: AppSizes.iconMedium,
        ),
      ),
    );
  }
}
