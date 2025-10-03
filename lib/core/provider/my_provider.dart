import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  // ==== Theme State ====
  String _selectedTheme = 'minimal';
  Color _primaryColor = Color(0xff1865E8);

  // Getters for theme
  String get selectedTheme => _selectedTheme;
  Color get primaryColor => _primaryColor;

  // ==== Setters for theme ====
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

  String? _selectedFont;

  MyProvider() {
    _selectedFont = _defaultFont;
  }

  String get selectedFont => _selectedFont ?? _defaultFont;

  void setSelectedFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

  String get _defaultFont {
    final isArabic =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';
    return isArabic ? 'amiri' : 'poppins';
  }

  String _orientation = "portrait";
  String get orientation => _orientation;

  set orientation(String newValue) {
    _orientation = newValue;
    notifyListeners();
  }

  bool _shouldGoToFullImage = false;
  bool get shouldGoToFullImage => _shouldGoToFullImage;

  void setShouldGoToFullImage(bool value) {
    _shouldGoToFullImage = value;
    notifyListeners();
  }

  bool _isOverlayEnabled = false;

  bool get isOverlayEnabled => _isOverlayEnabled;

  void toggleOverlay(bool value) {
    _isOverlayEnabled = value;
    notifyListeners();
  }

  List<String> chatMessages = [];
  void addChatMessage(String message) {
    chatMessages.add(message);
    notifyListeners();
  }
  int? _chatId;
  int? get chatId => _chatId;

  void setChatId(int id) {
    _chatId = id;
    notifyListeners();
  }
}
