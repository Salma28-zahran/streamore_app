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

    if (_starredCommentIndex == index) {
      _starredCommentIndex = null;
    } else if (_starredCommentIndex != null && _starredCommentIndex! > index) {
      _starredCommentIndex = _starredCommentIndex! - 1;
    }

    if (_shownCommentIndex == index) {
      _shownCommentIndex = null;
      _shownCommentText = null;
    } else if (_shownCommentIndex != null && _shownCommentIndex! > index) {
      _shownCommentIndex = _shownCommentIndex! - 1;
    }

    notifyListeners();
  }


  int? _starredCommentIndex;
  int? get starredCommentIndex => _starredCommentIndex;

  bool isCommentStarred(int index) {
    return _starredCommentIndex == index;
  }

  void toggleStarredComment(int index) {
    if (_starredCommentIndex == index) {
      _starredCommentIndex = null;
    } else {
      _starredCommentIndex = index;
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
}
