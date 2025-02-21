import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jim/core/models/workout_split.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/app_sizes.dart';

/// Widget untuk menampilkan grafik progress latihan pengguna.
/// Menampilkan perubahan total berat beban selama 30 hari terakhir.
class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  /// Mengambil riwayat berat beban dari Firestore.
  ///
  /// Mengembalikan List berisi data historis berat beban untuk 30 entri terakhir.
  /// Data difilter untuk hanya mengambil workout yang sudah selesai.
  Future<List<Map<String, dynamic>>> _fetchWeightHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    try {
      // Simplified query that should work without complex index
      final snapshots = await FirebaseFirestore.instance
          .collection('weight_history')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      // ignore: avoid_print
      print('Fetching from weight_history collection');

      final List<Map<String, dynamic>> history = snapshots.docs
          .map((doc) => doc.data())
          .where((data) =>
              data['totalWeight'] != null &&
              data['totalWeight'] > 0 &&
              data['timestamp'] != null &&
              (data['isCompleted'] ??
                  false)) // Filter completed workouts in memory
          .toList();

      // ignore: avoid_print
      print('Fetched ${history.length} weight records');
      // ignore: avoid_function_literals_in_foreach_calls
      history.forEach((record) {
        // ignore: avoid_print
        print('Weight: ${record['totalWeight']}, Date: ${record['timestamp']}');
      });

      return history;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching weight history: $e');
      // If the above query fails, try an even simpler query
      try {
        final snapshots = await FirebaseFirestore.instance
            .collection('weight_history')
            .where('userId', isEqualTo: userId)
            .get();

        final List<Map<String, dynamic>> history = snapshots.docs
            .map((doc) => doc.data())
            .where((data) =>
                data['totalWeight'] != null &&
                data['totalWeight'] > 0 &&
                data['timestamp'] != null &&
                (data['isCompleted'] ?? false))
            .toList();

        // Sort manually since we're not using orderBy
        history.sort((a, b) {
          final aTime = (a['timestamp'] as Timestamp).toDate();
          final bTime = (b['timestamp'] as Timestamp).toDate();
          return bTime.compareTo(aTime); // descending order
        });

        return history.take(30).toList(); // Limit to 30 records
      } catch (e2) {
        // ignore: avoid_print
        print('Error with fallback query: $e2');
        rethrow;
      }
    }
  }

  /// Menghitung total berat beban untuk suatu split workout.
  ///
  /// [splitId] adalah ID unik dari split workout yang akan dihitung.
  /// Mengembalikan total berat dalam kilogram.
  Future<double> _calculateTotalWeight(String splitId) async {
    final splitDoc = await FirebaseFirestore.instance
        .collection('users_splits')
        .doc(splitId)
        .get();

    if (!splitDoc.exists) return 0;

    final split = WorkoutSplit.fromJson(splitDoc.data()!);
    double totalWeight = 0;

    split.schedule.forEach((day, workouts) {
      for (var workout in workouts) {
        totalWeight += workout.weight * workout.sets * workout.reps;
      }
    });

    return totalWeight;
  }

  /// Mencatat perubahan berat beban ke Firestore.
  ///
  /// [splitId] adalah ID dari split workout yang dicatat.
  /// Data disimpan dengan timestamp server untuk tracking yang akurat.
  Future<void> _recordWeightChange(String splitId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final totalWeight = await _calculateTotalWeight(splitId);

    await FirebaseFirestore.instance.collection('weight_history').add({
      'userId': userId,
      'splitId': splitId,
      'totalWeight': totalWeight,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchWeightHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentGreen),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading progress data\n${snapshot.error}',
              style: AppStyles.body1.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No progress data yet\nComplete a workout to see your progress!',
              style: AppStyles.body1,
              textAlign: TextAlign.center,
            ),
          );
        }

        return _buildProgressChart(snapshot.data!);
      },
    );
  }

  /// Membangun grafik progress menggunakan fl_chart.
  ///
  /// [history] adalah List berisi data historis berat beban.
  /// Menampilkan grafik garis dengan tooltip yang menunjukkan tanggal dan berat.
  Widget _buildProgressChart(List<Map<String, dynamic>> history) {
    // Debug print for chart data
    // ignore: avoid_print
    print('Building chart with ${history.length} points');

    final spots = history.asMap().entries.map((entry) {
      final weight = entry.value['totalWeight'].toDouble();
      // ignore: avoid_print
      print('Chart point ${entry.key}: $weight kg');
      return FlSpot(entry.key.toDouble(), weight);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceSmall),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Remove date labels
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColors.secondaryDark,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final date =
                      (history[touchedSpot.x.toInt()]['timestamp'] as Timestamp)
                          .toDate();
                  final weight = touchedSpot.y.toStringAsFixed(1);
                  return LineTooltipItem(
                    '${DateFormat('MMM dd').format(date)}\n$weight kg',
                    AppStyles.caption.copyWith(color: AppColors.textPrimary),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.accentGreen,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: AppColors.accentGreen,
                    strokeWidth: 1,
                    strokeColor: AppColors.accentGreen,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentGreen.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
