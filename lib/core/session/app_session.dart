import 'package:flutter/foundation.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  bool _isSignedIn = false;
  String _name = '';
  String _email = '';

  final Set<String> _bookmarkedArticleTitles = {};
  final List<double> _quizPercentages = [];

  bool get isSignedIn => _isSignedIn;
  String get name => _name;
  String get email => _email;

  int get bookmarkCount => _bookmarkedArticleTitles.length;

  List<String> get bookmarkedArticleTitles {
    return List.unmodifiable(_bookmarkedArticleTitles);
  }

  int get completedQuizCount => _quizPercentages.length;
List<double> get quizPercentages {
  return List.unmodifiable(_quizPercentages);
}

  int get averageQuizPercentage {
    if (_quizPercentages.isEmpty) {
      return 0;
    }

    final total = _quizPercentages.fold<double>(
      0,
      (sum, percentage) => sum + percentage,
    );

    return (total / _quizPercentages.length).round();
  }

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

  void recordQuizResult({
    required int score,
    required int totalQuestions,
  }) {
    if (!_isSignedIn || totalQuestions == 0) {
      return;
    }

    final percentage = score / totalQuestions * 100;
    _quizPercentages.add(percentage);

    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    _name = '';
    _email = '';
    _bookmarkedArticleTitles.clear();
    _quizPercentages.clear();

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

  void removeArticleBookmark(String title) {
    _bookmarkedArticleTitles.remove(title);
    notifyListeners();
  }
}