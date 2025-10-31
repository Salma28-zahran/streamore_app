import 'package:flutter/material.dart';

import 'banners_provider.dart';
class Ticker {
  String? name;
  int itemCount;
  bool isEditing;
  List<String> tickers;
  Ticker({this.name, this.isEditing = false, this.itemCount = 0 , List<String>? tickers,}): tickers = tickers ?? [];
}

class TickersProvider extends ChangeNotifier {

  bool _tFolderClicked = false;
  bool get tFolderClicked => _tFolderClicked;

  void setTFolderClicked(bool value) {
    _tFolderClicked = value;
    notifyListeners();
  }


  List<String> _tickers = [];
  Set<int> _shownTickers = {};
  Set<int> _tappedTickers = {};

  List<String> get tickers => _tickers;
  Set<int> get shownTickers => _shownTickers;
  Set<int> get tappedTickers => _tappedTickers;

  void addTicker(String tickerContent) {
    if (_currentTicker != null) {
      _currentTicker!.tickers.add(tickerContent);
      _currentTicker!.itemCount++;
    }
    notifyListeners();
  }

  void toggleTickerVisibility(int index) {
    if (_shownTickers.contains(index)) {
      _shownTickers.remove(index);
    } else {
      _shownTickers.add(index);
    }
    notifyListeners();
  }

  void toggleTickerTapped(int index) {
    if (_tappedTickers.contains(index)) {
      _tappedTickers.remove(index);
    } else {
      _tappedTickers.add(index);
    }
    notifyListeners();
  }

  void removeTickerAt(int index) {
    if (_currentTicker != null && _currentTicker!.itemCount > 0) {
      _currentTicker!.tickers.removeAt(index);
      _currentTicker!.itemCount--;
    }
    _shownTickers.remove(index);
    _shownTickers = _shownTickers.map((i) => i > index ? i - 1 : i).toSet();

    _tappedTickers.remove(index);
    _tappedTickers = _tappedTickers.map((i) => i > index ? i - 1 : i).toSet();

    notifyListeners();
  }

  void clearTickers() {
    _tickers.clear();
    _shownTickers.clear();
    _tappedTickers.clear();
    notifyListeners();
  }
  List<Ticker> _tickersFolder = [];
  List<Ticker> get tickersFolder => _tickersFolder;
  void addTickerFolder(Ticker tickerFolder) {
    _tickersFolder .add(tickerFolder);
    notifyListeners();
  }

  void removeTickerFolderAt(int index) {
    _tickersFolder .removeAt(index);

    notifyListeners();
  }

  void clearTickersFolder() {
    _tickers.clear();
    notifyListeners();
  }
  void resetTappedState() {
    _tappedTickers.clear();
    notifyListeners();
  }
  /// item count provider Tickers Folder ////
  Ticker? _currentTicker;
  Ticker? get currentTicker => _currentTicker;

  void setCurrentTicker(Ticker? ticker) {
    _currentTicker = ticker;
    notifyListeners();
  }
  }
