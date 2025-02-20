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

      // Get the start of the current week
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);

      final docSnapshot =
          await _db.collection('user_anatomy').doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['lastUpdate'] != null) {
          final lastUpdate = (data['lastUpdate'] as Timestamp).toDate();

          // If data is from current week, load it
          if (lastUpdate.isAfter(startOfWeek)) {
            final muscles = List<String>.from(data['trainedMuscles'] ?? []);
            trainedMuscles.assignAll(muscles);
          } else {
            // Reset for new week
            trainedMuscles.clear();
            await _db.collection('user_anatomy').doc(userId).set({
              'trainedMuscles': [],
              'lastUpdate': FieldValue.serverTimestamp(),
            });
          }
        }
      }
    } catch (e) {
      print('Error loading trained muscles: $e');
    }
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
        ? Colors.red.withOpacity(0.8)
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
