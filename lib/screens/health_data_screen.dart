import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/health_data.dart';

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({super.key});

  @override
  State<HealthDataScreen> createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = StorageService();
  bool _isLoading = false;

  final _stepsController = TextEditingController();
  final _waterController = TextEditingController();
  final _sleepController = TextEditingController();
  final _caloriesController = TextEditingController();

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final healthData = HealthData(
          steps: int.parse(_stepsController.text),
          waterIntake: int.parse(_waterController.text),
          sleepDuration: _sleepController.text,
          calories: int.parse(_caloriesController.text),
          timestamp: DateTime.now(),
        );

        await _storageService.saveHealthData(healthData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Health data saved successfully')),
          );
          Navigator.pop(context, true); // Return true to indicate data was saved
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving data: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_walk),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter steps' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _waterController,
                decoration: const InputDecoration(
                  labelText: 'Water (glasses)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter water intake' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sleepController,
                decoration: const InputDecoration(
                  labelText: 'Sleep Duration (e.g., 8h 30m)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bedtime),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter sleep duration' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter calories' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}