import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Login user
  static Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  // Register user
  static Future<void> register(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
  }

  // Logout user with smooth transition
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Clear all stored data
      await prefs.clear();
      // Add delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  // Get current user's username
  static Future<String?> getCurrentUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUsername);
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  // Get current user's email
  static Future<String?> getCurrentEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyEmail);
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  // Clear all stored data
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user exists
  static Future<bool> userExists(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) == username;
  }
}