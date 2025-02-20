import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/core/models/workout_split.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSplitController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final selectedWorkouts = <String, List<WorkoutDetails>>{}.obs;
  final splitName = ''.obs;
  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void addWorkoutToDay(String day, String workoutId, int sets, int reps,
      double weight, int restTime) {
    if (!selectedWorkouts.containsKey(day)) {
      selectedWorkouts[day] = [];
    }

    // Remove if exists and add new
    selectedWorkouts[day]!
        .removeWhere((detail) => detail.workoutId == workoutId);

    selectedWorkouts[day]!.add(WorkoutDetails(
      workoutId: workoutId,
      sets: sets,
      reps: reps,
      weight: weight,
      restTime: restTime,
    ));

    update();
  }

  void removeWorkoutFromDay(String day, String workoutId) {
    if (selectedWorkouts.containsKey(day)) {
      selectedWorkouts[day]!
          .removeWhere((detail) => detail.workoutId == workoutId);
      if (selectedWorkouts[day]!.isEmpty) {
        selectedWorkouts.remove(day);
      }
      update();
    }
  }

  void updateWorkoutDetails(
    String day,
    String workoutId, {
    int? sets,
    int? reps,
    double? weight,
    int? restTime,
  }) {
    if (selectedWorkouts.containsKey(day)) {
      final index = selectedWorkouts[day]!
          .indexWhere((detail) => detail.workoutId == workoutId);
      if (index != -1) {
        final currentDetail = selectedWorkouts[day]![index];
        selectedWorkouts[day]![index] = WorkoutDetails(
          workoutId: workoutId,
          sets: sets ?? currentDetail.sets,
          reps: reps ?? currentDetail.reps,
          weight: weight ?? currentDetail.weight,
          restTime: restTime ?? currentDetail.restTime,
        );
        update();
      }
    }
  }

  Future<void> saveSplit() async {
    try {
      if (splitName.value.isEmpty) {
        throw 'Please enter a split name';
      }
      if (selectedWorkouts.isEmpty) {
        throw 'Please add at least one workout to your split';
      }

      final user = _auth.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      final splitDoc =
          FirebaseFirestore.instance.collection('users_splits').doc();

      final split = WorkoutSplit(
        id: splitDoc.id,
        name: splitName.value,
        schedule: selectedWorkouts,
        userId: user.uid,
        createdAt: DateTime.now(),
      );

      await splitDoc.set(split.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
