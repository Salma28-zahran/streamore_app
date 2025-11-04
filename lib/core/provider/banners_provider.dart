import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
class Folder {
  String? name;
  int itemCount;
  bool isEditing;
  List<String> banners;
  Folder({this.name, this.itemCount = 0, this.isEditing = false ,  List<String>? banners,}): banners = banners ?? [];
}


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

    if (_currentFolder != null) {
      _currentFolder!.banners.add(bannerContent);
      _currentFolder!.itemCount++;
    }
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

    if (_currentFolder != null && _currentFolder!.itemCount > 0) {
      _currentFolder!.banners.removeAt(index);
      _currentFolder!.itemCount--;
    }

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
  List<Folder> _folders = [];
  List<Folder> get folders => _folders;

  void addFolder(Folder folder) {
    _folders.add(folder);
    notifyListeners();
  }

  void removeFolderAt(int index) {
    _folders.removeAt(index);
    notifyListeners();
  }

  void clearFolders() {
    _folders.clear();
    notifyListeners();
  }





  /// item count provider Folders ////
  Folder? _currentFolder;
  Folder? get currentFolder => _currentFolder;

  void setCurrentFolder(Folder? folder) {
    _currentFolder = folder;
    notifyListeners();
  }


}
