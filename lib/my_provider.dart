import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

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

  // ==== Folder Clicked State Setter ====
  void setBFolderClicked(bool value) {
    if (value) {
      _bFolderClicked = true;
      _tFolderClicked = false;
    } else {
      _bFolderClicked = false;
    }
    notifyListeners();
  }

  void setTFolderClicked(bool value) {
    if (value) {
      _tFolderClicked = true;
      _bFolderClicked = false;
    } else {
      _tFolderClicked = false;
    }
    notifyListeners();
  }

  // ==== Background and Overlay Images ====
  List<XFile> _overlayImages = [];
  XFile? _selectedOverlayImage = null;
  bool _isOverlayVisible = false;

  List<XFile> _backgroundImages = [];
  XFile? _selectedBackgroundImage = null;
  bool _isBackgroundVisible = false;

  // Getters for background
  List<XFile> get backgroundImages => _backgroundImages;
  bool get isBackgroundVisible => _isBackgroundVisible;
  XFile? get selectedBackgroundImage => _selectedBackgroundImage;

  List<XFile> get overlayImages => _overlayImages;
  XFile? get selectedOverlayImage => _selectedOverlayImage;
  bool get isOverlayVisible => _isOverlayVisible;

  // Background image manipulation
  void addBackgroundImage(XFile image) {
    if (!_backgroundImages.contains(image)) {
      _backgroundImages.add(image);
      notifyListeners();
    }
  }

  void showBackgroundImage(XFile image) {
    if (_selectedBackgroundImage == image) {
      _isBackgroundVisible = !_isBackgroundVisible;
    } else {
      _selectedBackgroundImage = image;
      _isBackgroundVisible = true;
    }
    notifyListeners();
  }

  void toggleBackgroundVisibility() {
    _isBackgroundVisible = !_isBackgroundVisible;
    notifyListeners();
  }

  void setBackgroundImage(XFile image) {
    _selectedBackgroundImage = image;
    notifyListeners();
  }

  void addOverlayImage(XFile image) {
    if (!_overlayImages.contains(image)) {
      _overlayImages.add(image);
      notifyListeners();
    }
  }

  void showOverlayImage(XFile image) {
    if (_selectedOverlayImage == image) {
      _isOverlayVisible = !_isOverlayVisible;
    } else {
      _selectedOverlayImage = image;
      _isOverlayVisible = true;
    }
    notifyListeners();
  }

  void toggleOverlayVisibility() {
    _isOverlayVisible = !_isOverlayVisible;
    notifyListeners();
  }

  // ==== Logo Image properties ====
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

  String? _selectedFont;

  MyProvider() {
    _selectedFont = _defaultFont; // ✅ تحديد الخط الافتراضي من البداية
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

  List<String> chatMessages = [];
  void addChatMessage(String message) {
    chatMessages.add(message);
    notifyListeners();
  }

// // Banner content and state management ****************************************************
 List<String> _banners = [];
  Set<int> _shownBanners = {};
  Set<int> _tappedBanners = {};

  List<String> get banners => _banners;
  Set<int> get shownBanners => _shownBanners;
  Set<int> get tappedBanners => _tappedBanners;

  void addBanner(String bannerContent) {
    _banners.add(bannerContent);
    notifyListeners();
  }

  void toggleBannerVisibility(int index) {
    if (_shownBanners.contains(index)) {
      _shownBanners.remove(index);
    } else {
      _shownBanners.add(index);
    }
    notifyListeners();
  }

  void toggleBannerTapped(int index) {
    if (_tappedBanners.contains(index)) {
      _tappedBanners.remove(index);
    } else {
      _tappedBanners.add(index);
    }
    notifyListeners();
  }

  void removeBannerAt(int index) {
    _banners.removeAt(index);

    _shownBanners.remove(index);
    _shownBanners = _shownBanners.map((i) => i > index ? i - 1 : i).toSet();

    _tappedBanners.remove(index);
    _tappedBanners = _tappedBanners.map((i) => i > index ? i - 1 : i).toSet();

    notifyListeners();
  }

  void clearBanners() {
    _banners.clear();
    _shownBanners.clear();
    _tappedBanners.clear();
    notifyListeners();
  }
}
