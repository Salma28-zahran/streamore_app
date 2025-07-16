import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  // ==== Theme Overlay State ====
  String _selectedTheme = 'minimal';
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
  String _selectedFont = 'inter';

  String get selectedFont => _selectedFont;

  void setSelectedFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

  String _orientation = "portrait";
  String get orientation => _orientation;


  set orientation(String newValue) {
    _orientation = newValue;
    notifyListeners();
  }
  bool _shouldGoToFullImage = false;
  bool get shouldGoToFullImage => _shouldGoToFullImage;

  void setOrientation(String newValue) {
    _orientation = newValue;
    notifyListeners();
  }



  void setShouldGoToFullImage(bool value) {
    _shouldGoToFullImage = value;
    notifyListeners();
  }


  bool _isOverlayEnabled = false;
  final List<String> _comments = [];

  bool get isOverlayEnabled => _isOverlayEnabled;
  List<String> get comments => List.unmodifiable(_comments);

  void toggleOverlay(bool value) {
    _isOverlayEnabled = value;
    notifyListeners();
  }

  void addComment(String comment) {
    _comments.add(comment);
    notifyListeners();
  }

  void clearComments() {
    _comments.clear();
    notifyListeners();
  }

}