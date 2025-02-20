import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/constants/app_sizes.dart';
import 'package:jim/core/models/workout_split.dart';
import '../controllers/add_split_controller.dart';

class AddSplitView extends GetView<AddSplitController> {
  final AddSplitController controller = Get.put(AddSplitController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => Text(
            controller.splitName.value.isEmpty
                ? 'Create your split'
                : controller.splitName.value,
            style: AppStyles.heading2.copyWith(color: Colors.white))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.accentGreen),
            onPressed: () => _showSplitNameDialog(context),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppSizes.spaceSmall,
                  mainAxisSpacing: AppSizes.spaceSmall,
                ),
                itemCount: controller.daysOfWeek.length,
                itemBuilder: (context, index) {
                  final day = controller.daysOfWeek[index];
                  return Hero(
                    tag: 'day-$day',
                    child: Material(
                      color: Colors.transparent,
                      child: _buildDayCard(context, day),
                    ),
                  );
                },
              ),
              SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentGreen,
              AppColors.accentGreen.withGreen(200)
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGreen.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => controller.saveSplit(),
          icon: Icon(Icons.save_rounded, color: Colors.white),
          label: Text('Save Split',
              style: AppStyles.button.copyWith(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDayCard(BuildContext context, String day) {
    return Card(
      color: AppColors.secondaryDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.accentGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showWorkoutSelectionDialog(context, day),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        day,
                        style: AppStyles.heading3.copyWith(
                          color: AppColors.accentGreen,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spaceSmall),
                  Obx(() {
                    final workoutCount =
                        controller.selectedWorkouts[day]?.length ?? 0;
                    return Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: workoutCount > 0
                            ? AppColors.accentGreen
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        workoutCount.toString(),
                        style: TextStyle(
                          color: workoutCount > 0 ? Colors.white : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Divider(color: AppColors.accentGreen.withOpacity(0.3)),
              Expanded(
                child: Obx(() {
                  final selectedWorkouts =
                      controller.selectedWorkouts[day] ?? [];
                  if (selectedWorkouts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.accentGreen.withOpacity(0.5),
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add Workouts',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: selectedWorkouts.length,
                    itemBuilder: (context, index) =>
                        _buildWorkoutItem(day, selectedWorkouts[index]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String day, WorkoutDetails workout) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('workouts')
          .doc(workout.workoutId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        final workoutData = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${workoutData['name']}',
                  style: AppStyles.body2.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${workout.sets}×${workout.reps}',
                style: AppStyles.body2.copyWith(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 14),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                onPressed: () => _showWorkoutDetailsDialog(
                  context,
                  day,
                  workout.workoutId,
                  workoutData,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSplitNameDialog(BuildContext context) {
    // Prevent multiple dialogs
    if (Get.isDialogOpen ?? false) return;

    final textController =
        TextEditingController(text: controller.splitName.value);

    Get.dialog(
      PopScope(
        // Use PopScope instead of WillPopScope for better handling
        canPop: true, // Allow dialog to be closed
        child: Dialog(
          backgroundColor: AppColors.secondaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name your split',
                    style: AppStyles.heading3, textAlign: TextAlign.center),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: textController,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter split name',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    onChanged: (value) => controller.splitName.value = value,
                    onFieldSubmitted: (value) {
                      controller.splitName.value = value;
                      if (Get.isDialogOpen ?? false) Get.back();
                    },
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true, // Allow closing by tapping outside
    );
  }

  void _showWorkoutSelectionDialog(BuildContext context, String day) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.primaryDark,
        child: Container(
          width: double.maxFinite,
          height: Get.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSizes.spaceMedium),
                child:
                    Text('Select workouts for $day', style: AppStyles.heading3),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('workouts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(AppSizes.spaceSmall),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final workout = snapshot.data!.docs[index];
                        return Obx(() {
                          final isSelected = controller.selectedWorkouts[day]
                                  ?.any((w) => w.workoutId == workout.id) ??
                              false;
                          return Card(
                            color: isSelected
                                ? AppColors.accentGreen.withOpacity(0.2)
                                : AppColors.secondaryDark,
                            margin:
                                EdgeInsets.only(bottom: AppSizes.spaceSmall),
                            child: InkWell(
                              onTap: () {
                                _showWorkoutDetailsDialog(
                                  context,
                                  day,
                                  workout.id,
                                  workout,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.spaceSmall),
                                child: Row(
                                  children: [
                                    if (workout['image'] != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radiusSmall),
                                        child: Image.network(
                                          workout['image'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    SizedBox(width: AppSizes.spaceSmall),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(workout['name'],
                                              style: AppStyles.heading3),
                                          Text(
                                            workout['target_muscles'] ?? '',
                                            style: AppStyles.body2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.add_circle_outline,
                                      color: AppColors.accentGreen,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Done',
                    style: TextStyle(color: AppColors.accentGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutDetailsDialog(BuildContext context, String day,
      String workoutId, DocumentSnapshot workout) {
    final sets = TextEditingController(text: '3');
    final reps = TextEditingController(text: '12');
    final weight = TextEditingController(text: '0');
    final restTime = TextEditingController(text: '60');

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.secondaryDark,
        title: Text('Set workout details', style: AppStyles.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(workout['name'], style: AppStyles.heading3),
            const SizedBox(height: AppSizes.spaceMedium),
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
            onPressed: () {
              controller.addWorkoutToDay(
                day,
                workoutId,
                int.parse(sets.text),
                int.parse(reps.text),
                double.parse(weight.text),
                int.parse(restTime.text),
              );
              // Only close the current dialog, not all overlays
              Get.back();
            },
            child: Text('Add', style: TextStyle(color: AppColors.accentGreen)),
          ),
        ],
      ),
    );
  }
}
