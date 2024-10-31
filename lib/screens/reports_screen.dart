import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportCard(
            'Weekly Summary',
            'View your health metrics for the past week',
            Icons.calendar_view_week,
            Colors.blue,
            onTap: () {
              // TODO: Navigate to weekly report
            },
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            'Monthly Progress',
            'Check your monthly health trends',
            Icons.calendar_month,
            Colors.green,
            onTap: () {
              // TODO: Navigate to monthly report
            },
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            'Goals Progress',
            'Track your health goals progress',
            Icons.track_changes,
            Colors.orange,
            onTap: () {
              // TODO: Navigate to goals progress
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String subtitle, IconData icon, Color color, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}