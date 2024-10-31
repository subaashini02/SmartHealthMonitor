import 'package:flutter/material.dart';

class HealthTipCard extends StatelessWidget {
  final String title;
  final String tip;
  final IconData icon;
  final Color? backgroundColor;
  final String? detailedDescription;
  final List<String> bulletPoints;

  const HealthTipCard({
    Key? key,
    required this.title,
    required this.tip,
    this.icon = Icons.lightbulb,
    this.backgroundColor,
    this.detailedDescription,
    this.bulletPoints = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tip,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (bulletPoints.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...bulletPoints.map((point) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, 
                          color: Colors.green, 
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(point),
                        ),
                      ],
                    ),
                  )),
            ],
            if (detailedDescription != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showDetailedDescription(context);
                  },
                  child: const Text('Learn More'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetailedDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(detailedDescription ?? ''),
                if (bulletPoints.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Key Points:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...bulletPoints.map((point) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(point)),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}