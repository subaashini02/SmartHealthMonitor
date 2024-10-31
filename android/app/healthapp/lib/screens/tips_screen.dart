import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key}); // Add const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Stay Hydrated',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Drink at least 8 glasses of water daily.'),
          SizedBox(height: 20),
          Text(
            'Exercise Regularly',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Aim for at least 30 minutes of exercise per day.'),
          SizedBox(height: 20),
          Text(
            'Healthy Eating',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Eat a balanced diet rich in fruits and vegetables.'),
          SizedBox(height: 20),
          Text(
            'Regular Check-ups',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Visit your doctor for regular health check-ups.'),
        ],
      ),
    );
  }
}