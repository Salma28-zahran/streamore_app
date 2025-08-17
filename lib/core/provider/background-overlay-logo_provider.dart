import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BackgroundOverlayLogoProvider extends ChangeNotifier {
  // ==== Background and Overlay Images ====
  List<XFile> _overlayImages = [];
  XFile? _selectedOverlayImage = null;
  bool _isOverlayVisible = false;

  List<XFile> _backgroundImages = [];
  XFile? _selectedBackgroundImage = null;
  bool _isBackgroundVisible = false;

  XFile? _logoImageFile;
  bool _isLogoVisible = false;
  bool _useDefaultLogo = false;

  // Getters for background and overlay
  List<XFile> get overlayImages => _overlayImages;
  XFile? get selectedOverlayImage => _selectedOverlayImage;
  bool get isOverlayVisible => _isOverlayVisible;

  List<XFile> get backgroundImages => _backgroundImages;
  bool get isBackgroundVisible => _isBackgroundVisible;
  XFile? get selectedBackgroundImage => _selectedBackgroundImage;

  bool get isLogoVisible => _isLogoVisible;
  bool get useDefaultLogo => _useDefaultLogo;
  XFile? get logoImageFile => _logoImageFile;

  // ==== Background image manipulation ====
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

  // ==== Overlay image manipulation ====
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

  // ==== Logo image manipulation ====
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
}
