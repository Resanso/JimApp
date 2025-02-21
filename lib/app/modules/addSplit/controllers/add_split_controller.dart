import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/core/models/workout_split.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Controller untuk mengelola penambahan jadwal latihan (split workout)
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

  /// Menambahkan workout ke dalam jadwal hari tertentu
  ///
  /// [day] - Hari dalam seminggu (Senin-Minggu)
  /// [workoutId] - ID latihan yang dipilih
  /// [sets] - Jumlah set latihan
  /// [reps] - Jumlah pengulangan per set
  /// [weight] - Berat beban yang digunakan
  /// [restTime] - Waktu istirahat dalam detik
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

  /// Menghapus workout dari jadwal hari tertentu
  ///
  /// [day] - Hari dalam seminggu
  /// [workoutId] - ID latihan yang akan dihapus
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

  /// Memperbarui detail workout yang sudah ada
  ///
  /// [day] - Hari dalam seminggu
  /// [workoutId] - ID latihan yang akan diupdate
  /// [sets] - Jumlah set baru (opsional)
  /// [reps] - Jumlah pengulangan baru (opsional)
  /// [weight] - Berat beban baru (opsional)
  /// [restTime] - Waktu istirahat baru (opsional)
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

  /// Menyimpan jadwal latihan ke Firebase
  ///
  /// Memvalidasi input dan menyimpan split workout ke Firestore.
  /// Akan menampilkan error jika:
  /// - Nama split kosong
  /// - Tidak ada workout yang dipilih
  /// - User tidak terautentikasi
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
