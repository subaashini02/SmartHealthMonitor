import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int steps = 0;
  double waterIntake = 0.0;
  int caloriesBurned = 0;
  double sleepHours = 0.0;
  bool workoutCompleted = false;
  String moodToday = 'Good';
  double weight = 70.0; // in kg
  int heartRate = 75; // in bpm
  double bmi = 22.0;
  double height = 170.0; // in cm
  late SharedPreferences _prefs;
  final List<String> moodOptions = ['Great', 'Good', 'Okay', 'Bad'];
  
  // Weekly data for charts
  final List<double> weeklyWater = [2.1, 2.3, 1.9, 2.5, 2.2, 2.0, 2.4];
  final List<int> weeklySteps = [8000, 10000, 7500, 9000, 8500, 11000, 9500];
  final List<double> weeklySleep = [7.5, 6.8, 7.2, 8.0, 7.0, 7.5, 6.5];
  
  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      steps = _prefs.getInt('steps') ?? 0;
      waterIntake = _prefs.getDouble('waterIntake') ?? 0.0;
      caloriesBurned = _prefs.getInt('calories') ?? 0;
      sleepHours = _prefs.getDouble('sleep') ?? 0.0;
      workoutCompleted = _prefs.getBool('workout') ?? false;
      moodToday = _prefs.getString('mood') ?? 'Good';
      weight = _prefs.getDouble('weight') ?? 70.0;
      height = _prefs.getDouble('height') ?? 170.0;
      heartRate = _prefs.getInt('heartRate') ?? 75;
      bmi = _calculateBMI();
    });
  }

  double _calculateBMI() {
    return weight / math.pow(height / 100, 2);
  }

  Future<void> _saveData() async {
    await _prefs.setInt('steps', steps);
    await _prefs.setDouble('waterIntake', waterIntake);
    await _prefs.setInt('calories', caloriesBurned);
    await _prefs.setDouble('sleep', sleepHours);
    await _prefs.setBool('workout', workoutCompleted);
    await _prefs.setString('mood', moodToday);
    await _prefs.setDouble('weight', weight);
    await _prefs.setDouble('height', height);
    await _prefs.setInt('heartRate', heartRate);
  }

  String _getBMICategory() {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMIColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  Widget _buildLineChart(List<double> data, String title, Color color, String unit) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() < 0 || value.toInt() >= days.length) {
                    return const Text('');
                  }
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Card(
              elevation: 4,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BMI: ${bmi.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getBMIColor(),
                          ),
                        ),
                        Text(
                          _getBMICategory(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daily Progress Card with new design
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCard(
                          Icons.directions_walk,
                          '$steps',
                          'Steps',
                          Colors.blue,
                        ),
                        _buildMetricCard(
                          Icons.local_fire_department,
                          '$caloriesBurned',
                          'Calories',
                          Colors.orange,
                        ),
                        _buildMetricCard(
                          Icons.water_drop,
                          '${waterIntake.toStringAsFixed(1)}L',
                          'Water',
                          Colors.cyan,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Charts Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Water Intake (L)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLineChart(weeklyWater, 'Water Intake', Colors.blue, 'L'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Sleep Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLineChart(weeklySleep, 'Sleep', Colors.purple, 'hrs'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Health Metrics Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Metrics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHealthMetricSlider(
                      'Weight (kg)',
                      weight,
                      40,
                      150,
                      (value) {
                        setState(() {
                          weight = value;
                          bmi = _calculateBMI();
                          _saveData();
                        });
                      },
                    ),
                    _buildHealthMetricSlider(
                      'Height (cm)',
                      height,
                      120,
                      220,
                      (value) {
                        setState(() {
                          height = value;
                          bmi = _calculateBMI();
                          _saveData();
                        });
                      },
                    ),
                    _buildHeartRateSection(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sleep and Mood Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sleep & Mood',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSleepSection(),
                    const Divider(),
                    _buildMoodSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            steps += 100;
            caloriesBurned += 5;
            _saveData();
          });
        },
        label: const Text('Add Steps'),
        icon: const Icon(Icons.directions_walk),
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildHeartRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Heart Rate (BPM)',
          style: TextStyle(fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (heartRate > 40) {
                  setState(() {
                    heartRate--;
                    _saveData();
                  });
                }
              },
            ),
            Text(
              '$heartRate',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (heartRate < 200) {
                  setState(() {
                    heartRate++;
                    _saveData();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep Duration: ${sleepHours.toStringAsFixed(1)} hours',
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: sleepHours,
          min: 0,
          max: 12,
          divisions: 24,
          label: '${sleepHours.toStringAsFixed(1)} hours',
          onChanged: (value) {
            setState(() {
              sleepHours = value;
              _saveData();
            });
          },
        ),
      ],
    );
  }
Widget _buildMoodSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Mood Today',
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8.0,
        children: moodOptions.map((mood) {
          return ChoiceChip(
            label: Text(mood),
            selected: moodToday == mood,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  moodToday = mood;
                  _saveData();
                });
              }
            },
            selectedColor: Colors.blue.shade100,
          );
        }).toList(),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(
            _getMoodIcon(),
            size: 24,
            color: _getMoodColor(),
          ),
          const SizedBox(width: 8),
          Text(
            'Current Mood: $moodToday',
            style: TextStyle(
              fontSize: 16,
              color: _getMoodColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

// Add these helper methods to the _DashboardScreenState class
IconData _getMoodIcon() {
  switch (moodToday) {
    case 'Great':
      return Icons.sentiment_very_satisfied;
    case 'Good':
      return Icons.sentiment_satisfied;
    case 'Okay':
      return Icons.sentiment_neutral;
    case 'Bad':
      return Icons.sentiment_dissatisfied;
    default:
      return Icons.sentiment_neutral;
  }
}

Color _getMoodColor() {
  switch (moodToday) {
    case 'Great':
      return Colors.green;
    case 'Good':
      return Colors.lightGreen;
    case 'Okay':
      return Colors.orange;
    case 'Bad':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
}