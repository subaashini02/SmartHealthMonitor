import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _reminderTimeKey = 'reminder_time';

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? false;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  static Future<String?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reminderTimeKey);
  }

  static Future<void> setReminderTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderTimeKey, time);
  }
}