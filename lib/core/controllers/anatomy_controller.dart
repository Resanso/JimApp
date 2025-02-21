import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Controller untuk mengelola data anatomi dan otot yang telah dilatih
/// Menggunakan GetX untuk state management dan Firebase untuk penyimpanan data
class AnatomyController extends GetxController {
  /// List yang menyimpan nama-nama otot yang telah dilatih
  final RxList<String> trainedMuscles = <String>[].obs;

  /// Instance Firestore untuk akses database
  final _db = FirebaseFirestore.instance;

  /// Instance Firebase Auth untuk autentikasi
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadTrainedMuscles();
  }

  /// Memuat data otot yang telah dilatih dari Firebase
  /// Melakukan reset data jika hari ini adalah hari Minggu
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
      // ignore: avoid_print
      print('Error loading trained muscles: $e');
    }
  }

  /// Fungsi helper untuk mengecek apakah dua tanggal adalah hari yang sama
  /// [date1] Tanggal pertama yang akan dibandingkan
  /// [date2] Tanggal kedua yang akan dibandingkan
  /// Returns true jika kedua tanggal adalah hari yang sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Menyimpan data otot yang telah dilatih ke Firebase
  Future<void> saveTrainedMuscles() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _db.collection('user_anatomy').doc(userId).set({
        'trainedMuscles': trainedMuscles.toList(),
        'lastUpdate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error saving trained muscles: $e');
    }
  }

  /// Mengembalikan warna untuk visualisasi otot berdasarkan status latihan
  /// [muscleId] ID atau nama otot yang akan dicek
  /// Returns warna merah jika otot sudah dilatih, abu-abu jika belum
  Color getMuscleColor(String muscleId) {
    if (trainedMuscles.isEmpty) return const Color(0xFFD9D9D9);
    return trainedMuscles.any(
            (muscle) => muscleId.toLowerCase().contains(muscle.toLowerCase()))
        ? Colors.red
        : const Color(0xFFD9D9D9);
  }

  /// Menambahkan otot-otot baru ke daftar yang telah dilatih
  /// [muscles] List nama otot yang akan ditambahkan
  /// Hanya menambahkan otot yang belum ada dalam daftar
  void setTrainedMuscles(List<String> muscles) async {
    final newMuscles =
        muscles.where((m) => !trainedMuscles.contains(m)).toList();
    if (newMuscles.isNotEmpty) {
      trainedMuscles.addAll(newMuscles);
      await saveTrainedMuscles();
      update();
    }
  }
}
