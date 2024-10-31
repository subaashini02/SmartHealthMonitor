import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How to reset password?',
      answer: 'Go to login screen and click "Forgot Password". Follow the email instructions to reset.',
    ),
    FAQItem(
      question: 'How to export health data?',
      answer: 'Navigate to Settings > Profile > Export Data. Choose your format and time range.',
    ),
    FAQItem(
      question: 'How to set up notifications?',
      answer: 'Go to Settings > Notifications. Toggle notifications on and set your preferred time.',
    ),
    FAQItem(
      question: 'How to update goals?',
      answer: 'Navigate to Settings > Daily Goals. Adjust your targets and save changes.',
    ),
  ];

  Future<void> _sendSupportEmail() async {
    // Implement email functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support email feature coming soon')),
    );
  }

  Future<void> _showTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_tutorial', false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showTutorial,
            tooltip: 'Restart Tutorial',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            'Getting Started',
            'Learn how to use the Health App effectively.',
            [
              HelpItem(
                'Track Daily Metrics',
                'Record and monitor your daily health activities',
                Icons.track_changes,
                () => _showFeatureGuide(context, 'tracking'),
              ),
              HelpItem(
                'Set Goals',
                'Define and track your health objectives',
                Icons.flag,
                () => _showFeatureGuide(context, 'goals'),
              ),
              HelpItem(
                'View Progress',
                'Analyze your health journey over time',
                Icons.trending_up,
                () => _showFeatureGuide(context, 'progress'),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildContactSupport(),
          const Divider(height: 32),
          _buildFAQSection(),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String subtitle, List<HelpItem> items) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        children: items
            .map((item) => ListTile(
                  leading: Icon(item.icon, color: Theme.of(context).primaryColor),
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  onTap: item.onTap,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactItem(Icons.email, 'support@healthapp.com', _sendSupportEmail),
            _buildContactItem(Icons.phone, '1-800-HEALTH', () {}),
            _buildContactItem(
                Icons.access_time, 'Hours: Mon-Fri, 9AM-5PM EST', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: const Text('Frequently Asked Questions',
            style: TextStyle(fontWeight: FontWeight.bold)),
        children: _faqs
            .map((faq) => ExpansionTile(
                  title: Text(faq.question),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(faq.answer),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  void _showFeatureGuide(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Guide: ${feature.toUpperCase()}'),
        content: Text('Detailed guide for $feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class HelpItem {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  HelpItem(this.title, this.description, this.icon, this.onTap);
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}