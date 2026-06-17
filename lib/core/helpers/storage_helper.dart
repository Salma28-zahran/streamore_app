import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  // Save auth token
  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: "auth_token",
      value: token,
    );

    print('🔑 Token: $token');
  }

  // Get auth token
  static Future<String?> getToken() async {
    return await _storage.read(
      key: "auth_token",
    );
  }

  // Clear auth token
  static Future<void> clearToken() async {
    await _storage.delete(
      key: "auth_token",
    );
  }

  // Save invite token
  static Future<void> saveInviteToken(
      String token) async {
    await _storage.write(
      key: "invite_token",
      value: token,
    );
  }

  // Get invite token
  static Future<String?> getInviteToken() async {
    return await _storage.read(
      key: "invite_token",
    );
  }

  // Optional: clear invite token
  static Future<void> clearInviteToken() async {
    await _storage.delete(
      key: "invite_token",
    );
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




  static const String accountsKey = 'saved_accounts';

  static Future<List<String>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(accountsKey) ?? [];
  }

  static Future<void> saveAccount(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final accounts = prefs.getStringList(accountsKey) ?? [];

    if (!accounts.contains(email)) {
      accounts.add(email);
      await prefs.setStringList(accountsKey, accounts);
    }

    await prefs.setString('user_email', email);
  }

  static Future<void> setCurrentEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  static Future<void> clearAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accountsKey);
  }
  // Save csrf token
  static Future<void> saveCsrf(String csrf) async {
    await _storage.write(
      key: "csrf_token",
      value: csrf,
    );

    print('🛡️ CSRF Token: $csrf');
  }

// Get csrf token
  static Future<String?> getCsrf() async {
    return await _storage.read(
      key: "csrf_token",
    );
  }

// Clear csrf token
  static Future<void> clearCsrf() async {
    await _storage.delete(
      key: "csrf_token",
    );
  }


}
