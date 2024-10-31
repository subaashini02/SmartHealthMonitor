class HealthData {
  final int steps;
  final int waterIntake;
  final String sleepDuration;
  final int calories;
  final DateTime? timestamp;

  const HealthData({
    this.steps = 0,
    this.waterIntake = 0,
    this.sleepDuration = '0h 0m',
    this.calories = 0,
    this.timestamp,
  });

  HealthData copyWith({
    int? steps,
    int? waterIntake,
    String? sleepDuration,
    int? calories,
    DateTime? timestamp,
  }) {
    return HealthData(
      steps: steps ?? this.steps,
      waterIntake: waterIntake ?? this.waterIntake,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      calories: calories ?? this.calories,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'waterIntake': waterIntake,
      'sleepDuration': sleepDuration,
      'calories': calories,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      steps: json['steps'] ?? 0,
      waterIntake: json['waterIntake'] ?? 0,
      sleepDuration: json['sleepDuration'] ?? '0h 0m',
      calories: json['calories'] ?? 0,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  // Helper method to create weekly summary
  static HealthData weeklyAverage(List<HealthData> weekData) {
    if (weekData.isEmpty) return const HealthData();

    final totalSteps = weekData.fold<int>(0, (sum, data) => sum + data.steps);
    final totalWater = weekData.fold<int>(0, (sum, data) => sum + data.waterIntake);
    final totalCalories = weekData.fold<int>(0, (sum, data) => sum + data.calories);

    return HealthData(
      steps: totalSteps ~/ weekData.length,
      waterIntake: totalWater ~/ weekData.length,
      calories: totalCalories ~/ weekData.length,
      sleepDuration: '${(weekData.length / 7 * 100).toStringAsFixed(1)}% tracked',
    );
  }

  // Helper method to create monthly summary
  static HealthData monthlyAverage(List<HealthData> monthData) {
    if (monthData.isEmpty) return const HealthData();

    final totalSteps = monthData.fold<int>(0, (sum, data) => sum + data.steps);
    final totalWater = monthData.fold<int>(0, (sum, data) => sum + data.waterIntake);
    final totalCalories = monthData.fold<int>(0, (sum, data) => sum + data.calories);

    return HealthData(
      steps: totalSteps ~/ monthData.length,
      waterIntake: totalWater ~/ monthData.length,
      calories: totalCalories ~/ monthData.length,
      sleepDuration: '${(monthData.length / 30 * 100).toStringAsFixed(1)}% tracked',
    );
  }

  // Helper method to check if goals are met
  bool meetsGoals(HealthData goals) {
    return steps >= goals.steps &&
           waterIntake >= goals.waterIntake &&
           calories >= goals.calories;
  }

  // Helper method to calculate percentage of goal achieved
  double goalPercentage(HealthData goals) {
    if (goals.steps == 0) return 0.0;
    return (steps / goals.steps * 100).clamp(0.0, 100.0);
  }

  @override
  String toString() {
    return 'HealthData(steps: $steps, waterIntake: $waterIntake, sleepDuration: $sleepDuration, calories: $calories)';
  }
}