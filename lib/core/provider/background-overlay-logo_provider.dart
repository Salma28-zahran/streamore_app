import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BackgroundOverlayLogoProvider extends ChangeNotifier {
  // ==== Overlay Images ====
  List<XFile> _overlayImages = [];
  XFile? _selectedOverlayImage;
  bool _isOverlayVisible = false;

  // ==== Background Images ====
  List<XFile> _backgroundImages = [];
  XFile? _selectedBackgroundImage;
  bool _isBackgroundVisible = false;
  bool get hasBackgroundImage =>
      selectedBackgroundImage != null && isBackgroundVisible;

  // ==== Virtual Background Images ====
  List<XFile> _virtualBackgrounds = [];
  XFile? _selectedVirtualBackground;
  bool _isVirtualBackgroundVisible = false;

  // ==== Logo ====
  XFile? _logoImageFile;
  bool _isLogoVisible = false;
  bool _useDefaultLogo = false;

  // ====== Getters ======
  List<XFile> get overlayImages => _overlayImages;
  XFile? get selectedOverlayImage => _selectedOverlayImage;
  bool get isOverlayVisible => _isOverlayVisible;

  List<XFile> get backgroundImages => _backgroundImages;
  XFile? get selectedBackgroundImage => _selectedBackgroundImage;
  bool get isBackgroundVisible => _isBackgroundVisible;

  List<XFile> get virtualBackgrounds => _virtualBackgrounds;
  XFile? get selectedVirtualBackground => _selectedVirtualBackground;
  bool get isVirtualBackgroundVisible => _isVirtualBackgroundVisible;

  XFile? get logoImageFile => _logoImageFile;
  bool get isLogoVisible => _isLogoVisible;
  bool get useDefaultLogo => _useDefaultLogo;

  // ====== Background Methods ======
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

  // ====== Overlay Methods ======
  void addOverlayImage(XFile image) {
    if (!_overlayImages.contains(image)) {
      _overlayImages.add(image);
      notifyListeners();
    }
  }

  void showOverlayImage(XFile image) {
    print("Selected Overlay: ${image.path}");

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
  void removeOverlay() {
    _selectedOverlayImage = null;
    notifyListeners();
  }


  void clearOverlayImage() {
    _selectedOverlayImage = null;
    notifyListeners();
  }
  // ====== Logo Methods ======
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

  // ====== Virtual Background Methods ======
  void addVirtualBackground(XFile image) {
    if (!_virtualBackgrounds.contains(image)) {
      _virtualBackgrounds.add(image);
      notifyListeners();
    }
  }

  void showVirtualBackground(XFile image) {
    if (_selectedVirtualBackground == image) {
      _isVirtualBackgroundVisible = !_isVirtualBackgroundVisible;
    } else {
      _selectedVirtualBackground = image;
      _isVirtualBackgroundVisible = true;
    }
    notifyListeners();
  }

  void toggleVirtualBackgroundVisibility() {
    _isVirtualBackgroundVisible = !_isVirtualBackgroundVisible;
    notifyListeners();
  }

  void setVirtualBackground(XFile image) {
    _selectedVirtualBackground = image;
    notifyListeners();
  }
}
