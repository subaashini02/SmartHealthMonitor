import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _stepsController;
  late TextEditingController _waterController;
  late TextEditingController _sleepController;
  late TextEditingController _caloriesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController(text: '10000');
    _waterController = TextEditingController(text: '8');
    _sleepController = TextEditingController(text: '8');
    _caloriesController = TextEditingController(text: '2000');
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stepsController.text = (prefs.getInt('goal_steps') ?? 10000).toString();
      _waterController.text = (prefs.getInt('goal_water') ?? 8).toString();
      _sleepController.text = (prefs.getInt('goal_sleep') ?? 8).toString();
      _caloriesController.text = (prefs.getInt('goal_calories') ?? 2000).toString();
    });
  }

  Future<void> _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('goal_steps', int.parse(_stepsController.text));
        await prefs.setInt('goal_water', int.parse(_waterController.text));
        await prefs.setInt('goal_sleep', int.parse(_sleepController.text));
        await prefs.setInt('goal_calories', int.parse(_caloriesController.text));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goals updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating goals: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveGoals,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Set your daily health targets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildGoalField(
              controller: _stepsController,
              label: 'Daily Steps',
              icon: Icons.directions_walk,
              suffix: 'steps',
            ),
            const SizedBox(height: 16),
            _buildGoalField(
              controller: _waterController,
              label: 'Water Intake',
              icon: Icons.water_drop,
              suffix: 'glasses',
            ),
            const SizedBox(height: 16),
            _buildGoalField(
              controller: _sleepController,
              label: 'Sleep Duration',
              icon: Icons.bedtime,
              suffix: 'hours',
            ),
            const SizedBox(height: 16),
            _buildGoalField(
              controller: _caloriesController,
              label: 'Calorie Target',
              icon: Icons.local_fire_department,
              suffix: 'kcal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String suffix,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        suffixText: suffix,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}