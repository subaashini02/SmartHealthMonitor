import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  String _reminderTime = '08:00';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() => _isLoading = true);
    try {
      final enabled = await NotificationService.getNotificationsEnabled();
      final time = await NotificationService.getReminderTime();
      setState(() {
        _notificationsEnabled = enabled;
        _reminderTime = time ?? '08:00';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateNotifications(bool value) async {
    try {
      await NotificationService.setNotificationsEnabled(value);
      setState(() {
        _notificationsEnabled = value;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating notifications: $e')),
        );
      }
    }
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      try {
        final time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        await NotificationService.setReminderTime(time);
        setState(() {
          _reminderTime = time;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error setting reminder time: $e')),
          );
        }
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                await AuthService.logout();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                setState(() => _isLoading = false);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: Text('Daily reminder at $_reminderTime'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _updateNotifications,
            ),
            onTap: _notificationsEnabled ? _selectReminderTime : null,
          ),
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text('Daily Goals'),
            subtitle: const Text('Set your daily health targets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalsScreen()),
              ).then((_) => _loadNotificationSettings());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('Manage your profile information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ).then((_) => _loadNotificationSettings());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }
}