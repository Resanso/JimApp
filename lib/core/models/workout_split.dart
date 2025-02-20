class WorkoutSplit {
  final String id;
  final String name;
  final Map<String, List<WorkoutDetails>> schedule;
  final String userId;
  final DateTime createdAt;

  WorkoutSplit({
    required this.id,
    required this.name,
    required this.schedule,
    required this.userId,
    required this.createdAt,
  });

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

class WorkoutDetails {
  final String workoutId;
  final int sets;
  final int reps;
  final double weight;
  final int restTime; // in seconds

  WorkoutDetails({
    required this.workoutId,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'restTime': restTime,
    };
  }

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

extension WorkoutSplitUtils on WorkoutSplit {
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
