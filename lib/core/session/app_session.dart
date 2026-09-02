import 'package:flutter/foundation.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  bool _isSignedIn = false;
  String _name = '';
  String _email = '';

  final Set<String> _bookmarkedArticleTitles = {};

  bool get isSignedIn => _isSignedIn;
  String get name => _name;
  String get email => _email;

  int get bookmarkCount => _bookmarkedArticleTitles.length;

  bool isArticleBookmarked(String title) {
    return _bookmarkedArticleTitles.contains(title);
  }

  void signIn({
    required String name,
    required String email,
  }) {
    _isSignedIn = true;
    _name = name.trim().isEmpty ? 'NewsLLM Student' : name.trim();
    _email = email.trim();

    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    _name = '';
    _email = '';
    _bookmarkedArticleTitles.clear();

    notifyListeners();
  }

  bool toggleArticleBookmark(String title) {
    if (!_isSignedIn) {
      return false;
    }

    if (_bookmarkedArticleTitles.contains(title)) {
      _bookmarkedArticleTitles.remove(title);
    } else {
      _bookmarkedArticleTitles.add(title);
    }

    notifyListeners();

    return _bookmarkedArticleTitles.contains(title);
  }
}