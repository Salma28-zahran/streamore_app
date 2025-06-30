import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  // ==== Theme Overlay State ====
  String _selectedTheme = 'Minimal';
  Color _primaryColor = Color(0xff1865E8);

  // ==== Getters ====
  String get selectedTheme => _selectedTheme;
  Color get primaryColor => _primaryColor;

  // ==== Setters ====
  void setSelectedTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  // ==== Theme Mode Toggle ====
  void changeTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  String _selectedFont = 'Inter';

  String get selectedFont => _selectedFont;

  void setSelectedFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

}
