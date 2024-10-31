import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_data.dart';

class StorageService {
  static const String _healthDataKey = 'health_data_entries';

  // Save health data
  Future<void> saveHealthData(HealthData data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> entries = prefs.getStringList(_healthDataKey) ?? [];
    entries.add(jsonEncode(data.toJson()));
    await prefs.setStringList(_healthDataKey, entries);
  }

  // Get all health data
  Future<List<HealthData>> getAllHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_healthDataKey) ?? [];
    return entries.map((entry) {
      final Map<String, dynamic> json = jsonDecode(entry);
      return HealthData.fromJson(json);
    }).toList()
      ..sort((a, b) => (b.timestamp ?? DateTime.now())
          .compareTo(a.timestamp ?? DateTime.now()));
  }

  // Get today's data
  Future<HealthData?> getTodayData() async {
    final allData = await getAllHealthData();
    final now = DateTime.now();
    return allData.firstWhere(
      (data) => data.timestamp?.day == now.day && 
                data.timestamp?.month == now.month &&
                data.timestamp?.year == now.year,
      orElse: () => const HealthData(),
    );
  }
}