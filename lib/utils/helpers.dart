import 'package:flutter/material.dart';

class Helpers {
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String formatSleepDuration(String duration) {
    // Add sleep duration formatting logic
    return duration;
  }

  static Color getHealthStatusColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  static String getProgressMessage(double percentage) {
    if (percentage >= 80) return 'Great progress!';
    if (percentage >= 50) return 'Keep going!';
    return 'You can do better!';
  }
}