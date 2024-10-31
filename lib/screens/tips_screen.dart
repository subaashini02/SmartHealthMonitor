import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {  // Changed from TipsTab to TipsScreen
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tips'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HealthTipCard(
            title: 'Stay Active',
            content: 'Try to get at least 30 minutes of moderate exercise daily.',
            icon: Icons.directions_run,
          ),
          SizedBox(height: 16),
          HealthTipCard(
            title: 'Hydration',
            content: 'Aim to drink 8 glasses of water per day.',
            icon: Icons.water_drop,
          ),
          SizedBox(height: 16),
          HealthTipCard(
            title: 'Sleep Well',
            content: 'Get 7-9 hours of quality sleep each night.',
            icon: Icons.bedtime,
          ),
        ],
      ),
    );
  }
}

class HealthTipCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const HealthTipCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}