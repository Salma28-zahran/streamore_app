import 'package:flutter/material.dart';

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
    _tickers.add(tickerContent);
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
    _tickers.removeAt(index);

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
  void resetTappedState() {
    _tappedTickers.clear();
    notifyListeners();
  }
  }
