import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'tips_screen.dart';
import 'settings_screen.dart';
import 'health_data_screen.dart';
import 'notes_screen.dart';
import 'reports_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hasSeenTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
  }

  Future<void> _checkTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;
    });

    if (!_hasSeenTutorial) {
      if (mounted) {
        _showTutorial();
      }
    }
  }

  void _showTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Welcome to Health App!'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Here\'s what you can do:'),
                SizedBox(height: 8),
                Text('• Track your daily health metrics'),
                Text('• View health tips and recommendations'),
                Text('• Customize your health goals'),
                Text('• Manage your profile and settings'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('has_seen_tutorial', true);
                  Navigator.of(context).pop();
                },
                child: const Text('Get Started'),
              ),
            ],
          );
        },
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToHealthDataInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HealthDataScreen(),
      ),
    );
  }

  void _navigateToNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotesScreen(),
      ),
    );
  }

  void _navigateToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportsScreen(),
      ),
    );
  }

  void _handleFABPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_chart, color: Colors.blue),
                    ),
                    title: const Text('Add Health Data'),
                    subtitle: const Text('Update your daily health metrics'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToHealthDataInput();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.note_add, color: Colors.green),
                    ),
                    title: const Text('Add Note'),
                    subtitle: const Text('Record health-related notes'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToNotes();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.assessment, color: Colors.orange),
                    ),
                    title: const Text('View Reports'),
                    subtitle: const Text('Check your health progress'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToReports();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardScreen(),
          TipsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Tips',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton(
            onPressed: _handleFABPressed,
            elevation: 4,
            child: const Icon(Icons.add),
          )
        : null,
    );
  }
}