import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jim/core/models/workout_split.dart';

/// Controller untuk mengelola pengeditan workout
///
/// Controller ini bertanggung jawab untuk menangani operasi update
/// pada workout, khususnya untuk mengubah berat beban latihan
class EditWorkoutController extends GetxController {
  /// Instance Firestore untuk akses database
  final _db = FirebaseFirestore.instance;

  /// Instance Firebase Auth untuk autentikasi pengguna
  final _auth = FirebaseAuth.instance;

  /// Mengupdate berat beban dari sebuah workout
  ///
  /// Parameters:
  /// - [splitId] : ID dari split workout yang akan diupdate
  /// - [day] : Hari dimana workout tersebut berada
  /// - [workoutId] : ID dari workout yang akan diupdate
  /// - [newWeight] : Berat beban baru yang akan diset
  ///
  /// Fungsi ini akan:
  /// 1. Memperbarui berat beban workout dalam split
  /// 2. Menyimpan perubahan ke Firestore
  /// 3. Mencatat perubahan dalam history
  Future<void> updateWorkoutWeight(
    String splitId,
    String day,
    String workoutId,
    double newWeight,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Mengambil dokumen split dari database
      final splitDoc = await _db.collection('users_splits').doc(splitId).get();
      if (!splitDoc.exists) return;

      final split = WorkoutSplit.fromJson(splitDoc.data()!);
      var updated = false;

      // Mencari dan mengupdate workout yang sesuai dalam jadwal
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
        // Menyimpan perubahan ke database
        await _db
            .collection('users_splits')
            .doc(splitId)
            .update(split.toJson());

        // Mencatat perubahan berat beban dalam history
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
      // ignore: avoid_print
      print('Error updating workout weight: $e');
    }
  }
}
