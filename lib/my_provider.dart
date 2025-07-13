import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;


  List<XFile> _overlayImages = [];
  XFile? _selectedOverlayImage;
  bool _isOverlayVisible = false;

  List<XFile> get overlayImages => _overlayImages;
  XFile? get selectedOverlayImage => _selectedOverlayImage;
  bool get isOverlayVisible => _isOverlayVisible;

  void addOverlayImage(XFile image) {
    if (!_overlayImages.contains(image)) {
      _overlayImages.add(image);
      notifyListeners();
    }
  }

  void showOverlayImage(XFile image) {
    _selectedOverlayImage = image;
    _isOverlayVisible = true;
    notifyListeners();
  }

  void toggleOverlayVisibility() {
    _isOverlayVisible = !_isOverlayVisible;
    notifyListeners();
  }


// Logo Image properties
 XFile? _logoImageFile;
  bool _isLogoVisible = false;
  bool _useDefaultLogo = false;


  // Getters for logo
  bool get isLogoVisible => _isLogoVisible;
  bool get useDefaultLogo => _useDefaultLogo;
  XFile? get logoImageFile => _logoImageFile;


  // Setters and functions for logo
  void setLogoImage(XFile? image) {
    _logoImageFile = image;
    _isLogoVisible = false;
    notifyListeners();
  }

  void toggleLogoVisibility() {
    _isLogoVisible = !_isLogoVisible;
    notifyListeners();
  }

  void showDefaultLogo() {
    _logoImageFile = null;
    _useDefaultLogo = true;
    _isLogoVisible = true;
    notifyListeners();
  }


  // ==== Theme Overlay State ====
  String _selectedTheme = 'minimal';
  Color _primaryColor = Color(0xff1865E8);

  // ==== Getters ====
  String get selectedTheme => _selectedTheme;
  Color get primaryColor => _primaryColor;

  // ==== Folder Clicked State ====
  bool _bFolderClicked = false;
  bool _tFolderClicked = false;

  bool get bFolderClicked => _bFolderClicked;
  bool get tFolderClicked => _tFolderClicked;

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

  // ==== Folder Clicked State Setter ====
  void setBFolderClicked(bool value) {
    _bFolderClicked = value;
    notifyListeners();
  }

  void setTFolderClicked(bool value) {
    _tFolderClicked = value;
    notifyListeners();
  }

  String _selectedFont = 'Inter';

  String get selectedFont => _selectedFont;

  void setSelectedFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }
}
