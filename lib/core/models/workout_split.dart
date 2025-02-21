/// Model untuk menyimpan jadwal latihan (workout split)
///
/// Kelas ini mengatur bagaimana latihan dibagi dalam setiap hari
/// dan menyimpan detail dari setiap latihan yang dijadwalkan
class WorkoutSplit {
  /// ID unik untuk workout split
  final String id;

  /// Nama dari workout split (contoh: "Push Pull Legs", "Upper Lower", dll)
  final String name;

  /// Jadwal latihan yang berisi mapping hari ke daftar detail latihan
  /// Key: nama hari, Value: list detail latihan
  final Map<String, List<WorkoutDetails>> schedule;

  /// ID pengguna yang memiliki workout split ini
  final String userId;

  /// Waktu pembuatan workout split
  final DateTime createdAt;

  WorkoutSplit({
    required this.id,
    required this.name,
    required this.schedule,
    required this.userId,
    required this.createdAt,
  });

  /// Mengubah objek WorkoutSplit menjadi Map untuk keperluan JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'schedule': schedule.map((key, value) =>
          MapEntry(key, value.map((detail) => detail.toJson()).toList())),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Membuat objek WorkoutSplit dari Map JSON
  factory WorkoutSplit.fromJson(Map<String, dynamic> json) {
    Map<String, List<WorkoutDetails>> scheduleMap = {};
    (json['schedule'] as Map<String, dynamic>).forEach((key, value) {
      scheduleMap[key] =
          (value as List).map((item) => WorkoutDetails.fromJson(item)).toList();
    });

    return WorkoutSplit(
      id: json['id'],
      name: json['name'],
      schedule: scheduleMap,
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// Model untuk menyimpan detail dari setiap latihan
///
/// Berisi informasi seperti jumlah set, repetisi, berat beban, dan waktu istirahat
class WorkoutDetails {
  /// ID latihan yang direferensikan
  final String workoutId;

  /// Jumlah set yang harus dilakukan
  final int sets;

  /// Jumlah pengulangan per set
  final int reps;

  /// Berat beban dalam kilogram
  final double weight;

  /// Waktu istirahat dalam detik antara set
  final int restTime;

  WorkoutDetails({
    required this.workoutId,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
  });

  /// Mengubah objek WorkoutDetails menjadi Map untuk keperluan JSON
  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'restTime': restTime,
    };
  }

  /// Membuat objek WorkoutDetails dari Map JSON
  factory WorkoutDetails.fromJson(Map<String, dynamic> json) {
    return WorkoutDetails(
      workoutId: json['workoutId'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'],
      restTime: json['restTime'],
    );
  }
}

/// Extension untuk menambah fungsionalitas pada WorkoutSplit
extension WorkoutSplitUtils on WorkoutSplit {
  /// Menghitung total berat beban yang diangkat dalam satu sesi workout split
  ///
  /// Rumus: berat * jumlah set * jumlah repetisi
  /// @return total berat dalam kilogram
  double calculateTotalWeight() {
    double totalWeight = 0;
    schedule.forEach((day, workouts) {
      for (var workout in workouts) {
        totalWeight += workout.weight * workout.sets * workout.reps;
      }
    });
    return totalWeight;
  }
}
