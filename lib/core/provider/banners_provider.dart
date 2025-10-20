import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BannersProvider extends ChangeNotifier {

  bool _bFolderClicked = false;
  bool _tFolderClicked = false;

  bool get bFolderClicked => _bFolderClicked;
  bool get tFolderClicked => _tFolderClicked;

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
  void resetTappedState() {
    _tappedBanners.clear();
    notifyListeners();
  }
}
