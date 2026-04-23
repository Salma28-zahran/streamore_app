import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    print('🔑 Token: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }


  static Future<void> saveInviteToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("invite_token", token);
  }

  static Future<String?> getInviteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("invite_token");
  }


  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> clearEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }

  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_password', password);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_password');
  }

  static Future<void> clearPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_password');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }


}
