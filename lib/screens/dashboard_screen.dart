import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/health_data.dart';
import '../widgets/health_tip_card.dart';  // Add this import
import 'health_data_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StorageService _storageService = StorageService();
  int steps = 0;
  int waterIntake = 0;
  String sleepDuration = '0h 0m';
  int calories = 0;
  List<HealthData> weeklyData = [];
  bool _isLoading = true;

  // Add health tips list
  final List<Map<String, dynamic>> _healthTips = [
    {
      'title': 'Stay Hydrated',
      'tip': 'Aim to drink 8 glasses of water daily for optimal health.',
      'icon': Icons.water_drop,
      'detailedDescription': 'Proper hydration is essential for maintaining body temperature, keeping joints lubricated, preventing infections, delivering nutrients to cells, and keeping organs functioning properly.',
      'bulletPoints': [
        'Start your day with a glass of water',
        'Carry a reusable water bottle',
        'Set hydration reminders',
        'Monitor your water intake throughout the day'
      ],
    },
    {
      'title': 'Quality Sleep',
      'tip': 'Get 7-9 hours of quality sleep each night for better health.',
      'icon': Icons.bedtime,
      'detailedDescription': 'Quality sleep is crucial for physical recovery, mental health, and overall well-being. It helps improve concentration, productivity, and emotional balance.',
      'bulletPoints': [
        'Maintain a consistent sleep schedule',
        'Create a relaxing bedtime routine',
        'Avoid screens before bed',
        'Keep your bedroom cool and dark'
      ],
    },
    {
      'title': 'Regular Exercise',
      'tip': 'Include at least 30 minutes of physical activity in your daily routine.',
      'icon': Icons.fitness_center,
      'detailedDescription': 'Regular exercise helps maintain physical and mental health, reduces the risk of chronic diseases, and improves mood and energy levels.',
      'bulletPoints': [
        'Start with light exercises',
        'Mix cardio and strength training',
        'Take regular walking breaks',
        'Find activities you enjoy'
      ],
    },
    {
      'title': 'Mindful Eating',
      'tip': 'Practice mindful eating habits and maintain a balanced diet.',
      'icon': Icons.restaurant,
      'detailedDescription': 'Mindful eating helps you make healthier food choices, maintain proper portion control, and enjoy your meals more fully.',
      'bulletPoints': [
        'Eat slowly and without distractions',
        'Listen to your hunger cues',
        'Choose whole, nutritious foods',
        'Practice portion control'
      ],
    },
    {
      'title': 'Stress Management',
      'tip': 'Take regular breaks to manage stress and maintain mental well-being.',
      'icon': Icons.spa,
      'detailedDescription': 'Managing stress is crucial for both mental and physical health. Regular breaks and relaxation techniques can help reduce stress levels.',
      'bulletPoints': [
        'Practice deep breathing exercises',
        'Take short walks during breaks',
        'Try meditation or mindfulness',
        'Maintain a work-life balance'
      ],
    },
  ];

  // Add method to get daily tip
  Map<String, dynamic> _getDailyTip() {
    final DateTime now = DateTime.now();
    final int dayOfYear = now.difference(DateTime(now.year)).inDays;
    return _healthTips[dayOfYear % _healthTips.length];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final todayData = await _storageService.getTodayData();
      final allData = await _storageService.getAllHealthData();
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final weekData = allData.where((data) => 
        (data.timestamp?.isAfter(weekAgo) ?? false) && 
        (data.timestamp?.isBefore(now.add(const Duration(days: 1))) ?? false)
      ).toList();

      setState(() {
        steps = todayData?.steps ?? 0;
        waterIntake = todayData?.waterIntake ?? 0;
        sleepDuration = todayData?.sleepDuration ?? '0h 0m';
        calories = todayData?.calories ?? 0;
        weeklyData = weekData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _addHealthData() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HealthDataScreen()),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyTip = _getDailyTip();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Steps',
                            '$steps',
                            Icons.directions_walk,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            'Water',
                            '$waterIntake glasses',
                            Icons.water_drop,
                            Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Sleep',
                            sleepDuration,
                            Icons.bedtime,
                            Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            'Calories',
                            '$calories kcal',
                            Icons.local_fire_department,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildWeeklyProgress(),
                    const SizedBox(height: 24),
                    const Text(
                      'Daily Health Tip',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add the HealthTipCard
                    HealthTipCard(
                      title: dailyTip['title'],
                      tip: dailyTip['tip'],
                      icon: dailyTip['icon'],
                      detailedDescription: dailyTip['detailedDescription'],
                      bulletPoints: List<String>.from(dailyTip['bulletPoints']),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHealthData,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Your existing _buildSummaryCard method remains the same
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing _buildWeeklyProgress method remains the same
  Widget _buildWeeklyProgress() {
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final now = DateTime.now();
    final weeklySteps = List<int>.filled(7, 0);
    
    for (var data in weeklyData) {
      if (data.timestamp != null) {
        final daysDiff = now.difference(data.timestamp!).inDays;
        if (daysDiff < 7) {
          weeklySteps[6 - daysDiff] = data.steps;
        }
      }
    }

    final maxSteps = weeklySteps.reduce((max, steps) => 
      steps > max ? steps : max);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final percentage = maxSteps == 0 ? 0.0 :
              weeklySteps[index] / maxSteps;
            
            return Column(
              children: [
                Text(
                  daysOfWeek[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 8,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: 60 * percentage,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weeklySteps[index]}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}