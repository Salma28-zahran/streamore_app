import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "auth_token";

  /// Save Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Check if token exists
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  /// Clear Token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Update Token
  static Future<void> updateToken(String newToken) async {
    await saveToken(newToken);
  }
}
