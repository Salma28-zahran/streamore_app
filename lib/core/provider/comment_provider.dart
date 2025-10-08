import 'package:flutter/foundation.dart';

class CommentProvider with ChangeNotifier {

  String _comment = '';
  bool _isCommentShown = false;

  String get comment => _comment;
  bool get isCommentShown => _isCommentShown;

  void setComment(String newComment) {
    _comment = newComment;
    _isCommentShown = true;
    notifyListeners();
  }

  void resetToUsername() {
    _isCommentShown = false;
    notifyListeners();
  }


  final List<String> _comments = [];
  List<String> get comments => _comments;

  void addComment(String comment) {
    _comments.add(comment);
    notifyListeners();
  }

  void clearComments() {
    _comments.clear();
    notifyListeners();
  }

  void deleteComment(int index) {
    _comments.removeAt(index);

    _tappedComments.remove(index);
    final updatedTapped = _tappedComments.map((i) => i > index ? i - 1 : i).toSet().toList();
    _tappedComments
      ..clear()
      ..addAll(updatedTapped);

    _starredComments.remove(index);

    final updatedStarred = _starredComments
        .map((i) => i > index ? i - 1 : i)
        .toSet();
    _starredComments
      ..clear()
      ..addAll(updatedStarred);

    if (_shownCommentIndex == index) {
      _shownCommentIndex = null;
      _shownCommentText = null;
    } else if (_shownCommentIndex != null && _shownCommentIndex! > index) {
      _shownCommentIndex = _shownCommentIndex! - 1;
    }

    notifyListeners();
  }


  final Set<int> _starredComments = {};
  Set<int> get starredComments => _starredComments;

  bool isCommentStarred(int index) {
    return _starredComments.contains(index);
  }
  void toggleStarredComment(int index) {
    if (_starredComments.contains(index)) {
      _starredComments.remove(index);
    } else {
      _starredComments.add(index);
    }
    notifyListeners();
  }


  final List<int> _tappedComments = [];
  int? _shownCommentIndex;
  String? _shownCommentText;

  List<int> get tappedComments => _tappedComments;
  int? get shownCommentIndex => _shownCommentIndex;
  String? get shownCommentText => _shownCommentText;

  void toggleCommentShown(int index) {
    if (_shownCommentIndex == index) {
      _shownCommentIndex = null;
      _shownCommentText = null;
    } else {
      _shownCommentIndex = index;
      _shownCommentText = _comments[index];
    }
    notifyListeners();
  }

  void toggleCommentTapped(int index) {
    if (_tappedComments.contains(index)) {
      _tappedComments.remove(index);
    } else {
      _tappedComments.add(index);
    }
    notifyListeners();
  }

  void hideCommentText() {
    _shownCommentText = null;
    notifyListeners();
  }
  bool _isOverlayEnabled = false;
  bool get isOverlayEnabled => _isOverlayEnabled;

  void toggleOverlay() {
    _isOverlayEnabled = !_isOverlayEnabled;
    notifyListeners();
  }
  void clearTappedComments() {
    _tappedComments.clear();
    notifyListeners();
  }
}
