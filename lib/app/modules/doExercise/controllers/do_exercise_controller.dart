import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jim/core/controllers/anatomy_controller.dart';
import 'package:jim/core/models/workout_split.dart';

/// Controller untuk mengelola halaman latihan (exercise)
/// Mengatur alur latihan, waktu istirahat, dan pencatatan progress
class DoExerciseController extends GetxController {
  /// ID dari split workout yang sedang dijalankan
  final String splitId;

  /// Data workout yang akan dijalankan
  final Map<String, dynamic> workouts;

  DoExerciseController({required this.splitId, required this.workouts});

  /// Menyimpan hari latihan saat ini
  final currentDay = ''.obs;

  /// Indeks workout yang sedang dijalankan
  final currentWorkoutIndex = 0.obs;

  /// Set latihan saat ini
  final currentSet = 1.obs;

  /// Status apakah workout sudah selesai
  final isWorkoutComplete = false.obs;

  /// Nama latihan yang sedang dilakukan
  final currentExerciseName = ''.obs;

  /// URL gambar untuk latihan saat ini
  final currentExerciseImage = ''.obs;

  /// Otot target yang dilatih
  final currentTargetMuscles = ''.obs;

  /// Gerakan yang dilakukan dalam latihan
  final currentMovements = ''.obs;

  final _completedMuscles = <String>[].obs;
  final _db = FirebaseFirestore.instance;
  late final AnatomyController _anatomyController;
  final _auth = FirebaseAuth.instance;

  final currentReps = 0.obs;
  final currentWeight = 0.0.obs;
  final currentRestTime = 0.obs;
  final isResting = false.obs;
  final restTimeRemaining = 0.obs;
  final totalSets = 0.obs;

  final nextExerciseName = ''.obs;
  final totalExercises = 0.obs;
  final currentExerciseIndex = 0.obs;
  final workoutProgress = 0.0.obs;

  late Timer? _restTimer;

  /// Inisialisasi awal controller
  /// Dipanggil saat controller pertama kali dibuat
  @override
  void onInit() {
    super.onInit();
    _anatomyController = Get.find<AnatomyController>();
    _initializeWorkout();
  }

  /// Membersihkan timer saat controller dihapus
  @override
  void onClose() {
    _restTimer?.cancel();
    super.onClose();
  }

  /// Menginisialisasi workout berdasarkan hari
  /// Mengatur workout sesuai dengan hari saat ini atau hari pertama yang tersedia
  void _initializeWorkout() {
    final today = DateTime.now().weekday;
    final days = workouts.keys.toList();

    // Get current day's workout or first available day
    currentDay.value = days.firstWhere(
      (day) => _getDayNumber(day) == today,
      orElse: () => days.first,
    );

    _loadCurrentExercise();
  }

  /// Mengkonversi nama hari menjadi angka
  /// @param day Nama hari dalam bahasa Inggris
  /// @return Nomor hari (1-7, Senin-Minggu)
  int _getDayNumber(String day) {
    final days = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return days[day] ?? 1;
  }

  /// Memuat data latihan yang sedang aktif
  /// Mengambil detail latihan dari Firestore dan memperbarui UI
  Future<void> _loadCurrentExercise() async {
    final workoutList = (workouts[currentDay.value] as List)
        .map((item) {
          if (item is Map<String, dynamic>) {
            return WorkoutDetails.fromJson(item);
          }
          return null;
        })
        .whereType<WorkoutDetails>()
        .toList();

    totalExercises.value = workoutList.length;
    currentExerciseIndex.value = currentWorkoutIndex.value;
    workoutProgress.value = currentWorkoutIndex.value / workoutList.length;

    if (currentWorkoutIndex.value >= workoutList.length) {
      isWorkoutComplete.value = true;
      await _recordProgress();
      _updateAnatomyView();
      return;
    }

    final currentWorkout = workoutList[currentWorkoutIndex.value];
    final workoutDoc =
        await _db.collection('workouts').doc(currentWorkout.workoutId).get();
    final data = workoutDoc.data();

    if (data != null) {
      currentExerciseName.value = data['name'] ?? '';
      currentExerciseImage.value = data['image'] ?? '';
      currentTargetMuscles.value = data['target_muscles'] ?? '';
      currentMovements.value = data['movements'] ?? '';

      // Update workout details
      totalSets.value = currentWorkout.sets;
      currentReps.value = currentWorkout.reps;
      currentWeight.value = currentWorkout.weight;
      currentRestTime.value = currentWorkout.restTime;

      if (data['target_muscles'] != null) {
        _completedMuscles.add(data['target_muscles']);
      }
    }

    // Load next workout name if available
    if (currentWorkoutIndex.value + 1 < workoutList.length) {
      final nextWorkout = workoutList[currentWorkoutIndex.value + 1];
      final nextWorkoutDoc =
          await _db.collection('workouts').doc(nextWorkout.workoutId).get();
      final nextData = nextWorkoutDoc.data();
      nextExerciseName.value = nextData?['name'] ?? '';
    } else {
      nextExerciseName.value = 'Workout Complete!';
    }
  }

  /// Menandai set latihan selesai
  /// Memulai waktu istirahat atau pindah ke latihan berikutnya
  void completeSet() async {
    final dayWorkouts = workouts[currentDay.value] as List;
    final currentWorkout =
        dayWorkouts[currentWorkoutIndex.value] as Map<String, dynamic>;

    if (currentSet.value < (currentWorkout['sets'] ?? 3)) {
      startRest();
    } else {
      currentSet.value = 1;
      currentWorkoutIndex.value++;
      await _loadCurrentExercise();
    }
  }

  /// Memulai waktu istirahat
  /// Menghitung mundur waktu istirahat yang ditentukan
  void startRest() {
    isResting.value = true;
    restTimeRemaining.value = currentRestTime.value;

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (restTimeRemaining.value > 0) {
        restTimeRemaining.value--;
      } else {
        timer.cancel();
        isResting.value = false;
        currentSet.value++;
      }
    });
  }

  /// Melewati waktu istirahat
  /// Langsung melanjutkan ke set berikutnya
  void skipRest() {
    if (isResting.value) {
      _restTimer?.cancel();
      isResting.value = false;
      currentSet.value++;
    }
  }

  /// Menyimpan data otot yang telah dilatih ke Firestore
  /// Digunakan untuk tracking progress mingguan
  Future<void> _saveTrainedMuscles() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Get the start of the current week (Monday)
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);

      // Reference to user's anatomy document
      final userAnatomyRef = _db.collection('user_anatomy').doc(userId);

      // Get existing document
      final docSnapshot = await userAnatomyRef.get();

      if (docSnapshot.exists) {
        // Check if we need to reset (if data is from previous week)
        final lastUpdate =
            (docSnapshot.data()?['lastUpdate'] as Timestamp).toDate();
        if (lastUpdate.isBefore(startOfWeek)) {
          // Reset for new week
          await userAnatomyRef.set({
            'trainedMuscles': _completedMuscles,
            'lastUpdate': FieldValue.serverTimestamp(),
          });
        } else {
          // Update existing week's data
          await userAnatomyRef.update({
            'trainedMuscles': FieldValue.arrayUnion(_completedMuscles),
            'lastUpdate': FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Create new document
        await userAnatomyRef.set({
          'trainedMuscles': _completedMuscles,
          'lastUpdate': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error saving trained muscles: $e');
    }
  }

  /// Mencatat progress latihan ke Firestore
  /// Menyimpan total berat dan detail latihan yang telah diselesaikan
  Future<void> _recordProgress() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      if (!isWorkoutComplete.value) {
        // ignore: avoid_print
        print('Workout not complete, skipping progress recording');
        return;
      }

      // Calculate total weight
      double totalWeight = 0;
      final dayWorkouts = workouts[currentDay.value] as List;

      // ignore: avoid_print
      print('Recording workout for day: ${currentDay.value}');
      // ignore: avoid_print
      print('Number of exercises: ${dayWorkouts.length}');

      for (var workout in dayWorkouts) {
        if (workout is Map<String, dynamic>) {
          final sets = workout['sets'] ?? 0;
          final reps = workout['reps'] ?? 0;
          final weight = (workout['weight'] ?? 0).toDouble();
          final exerciseTotal = sets * reps * weight;
          totalWeight += exerciseTotal;

          // ignore: avoid_print
          print('Exercise: ${workout['workoutId']}');
          // ignore: avoid_print
          print('Sets: $sets, Reps: $reps, Weight: $weight');
          // ignore: avoid_print
          print('Exercise total: $exerciseTotal kg');
        }
      }

      // ignore: avoid_print
      print('Total weight for all exercises: $totalWeight kg');

      // Record to weight_history collection
      await _db.collection('weight_history').add({
        'userId': userId,
        'splitId': splitId,
        'totalWeight': totalWeight,
        'timestamp': FieldValue.serverTimestamp(),
        'dayOfWeek': currentDay.value,
        'isCompleted': true,
        'workoutDetails': workouts[currentDay.value],
      });

      // ignore: avoid_print
      print('Progress successfully recorded to weight_history');
    } catch (e) {
      // ignore: avoid_print
      print('Error recording progress: $e');
    }
  }

  /// Memperbarui tampilan anatomi
  /// Menampilkan otot yang telah dilatih pada model anatomi
  void _updateAnatomyView() async {
    await _saveTrainedMuscles();
    _anatomyController.setTrainedMuscles(_completedMuscles);
  }
}
