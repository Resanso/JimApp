import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnatomyController extends GetxController {
  final RxList<String> trainedMuscles = <String>[].obs;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadTrainedMuscles();
  }

  Future<void> loadTrainedMuscles() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final now = DateTime.now();
      // Cek apakah hari ini Minggu (weekday 7)
      final isSunday = now.weekday == DateTime.sunday;

      final docSnapshot =
          await _db.collection('user_anatomy').doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['lastUpdate'] != null) {
          final lastUpdate = (data['lastUpdate'] as Timestamp).toDate();

          // Reset jika hari ini Minggu dan data terakhir bukan dari hari ini
          if (isSunday && !_isSameDay(lastUpdate, now)) {
            trainedMuscles.clear();
            await _db.collection('user_anatomy').doc(userId).set({
              'trainedMuscles': [],
              'lastUpdate': FieldValue.serverTimestamp(),
            });
          } else if (!isSunday) {
            // Jika bukan hari Minggu, load data normal
            final muscles = List<String>.from(data['trainedMuscles'] ?? []);
            trainedMuscles.assignAll(muscles);
          }
        }
      }
    } catch (e) {
      print('Error loading trained muscles: $e');
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> saveTrainedMuscles() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _db.collection('user_anatomy').doc(userId).set({
        'trainedMuscles': trainedMuscles.toList(),
        'lastUpdate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving trained muscles: $e');
    }
  }

  Color getMuscleColor(String muscleId) {
    if (trainedMuscles.isEmpty) return const Color(0xFFD9D9D9);
    return trainedMuscles.any(
            (muscle) => muscleId.toLowerCase().contains(muscle.toLowerCase()))
        ? Colors.red
        : const Color(0xFFD9D9D9);
  }

  void setTrainedMuscles(List<String> muscles) async {
    // Hanya tambahkan otot yang belum ada
    final newMuscles =
        muscles.where((m) => !trainedMuscles.contains(m)).toList();
    if (newMuscles.isNotEmpty) {
      trainedMuscles.addAll(newMuscles);
      await saveTrainedMuscles();
      update();
    }
  }
}
