import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jim/core/models/workout_split.dart';

class EditWorkoutController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> updateWorkoutWeight(
    String splitId,
    String day,
    String workoutId,
    double newWeight,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Update the workout weight in the split
      final splitDoc = await _db.collection('users_splits').doc(splitId).get();
      if (!splitDoc.exists) return;

      final split = WorkoutSplit.fromJson(splitDoc.data()!);
      var updated = false;

      // Update the weight in the schedule
      if (split.schedule.containsKey(day)) {
        final workouts = split.schedule[day]!;
        for (var i = 0; i < workouts.length; i++) {
          if (workouts[i].workoutId == workoutId) {
            workouts[i] = WorkoutDetails(
              workoutId: workoutId,
              sets: workouts[i].sets,
              reps: workouts[i].reps,
              weight: newWeight,
              restTime: workouts[i].restTime,
            );
            updated = true;
            break;
          }
        }
      }

      if (updated) {
        // Update the split document
        await _db
            .collection('users_splits')
            .doc(splitId)
            .update(split.toJson());

        // Record weight change in history
        await _db.collection('weight_history').add({
          'userId': userId,
          'splitId': splitId,
          'totalWeight': split.calculateTotalWeight(),
          'timestamp': FieldValue.serverTimestamp(),
          'dayOfWeek': day,
          'isWeightUpdate': true,
        });
      }
    } catch (e) {
      print('Error updating workout weight: $e');
    }
  }
}
