import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  StreamSubscription<User?>? _authSubscription;
  bool _authenticationInitialized = false;

  bool _isSignedIn = false;
  String _name = '';
  String _email = '';

  String _preferredLanguage = 'English';
  ThemeMode _themeMode = ThemeMode.light;

  bool _newsNotificationsEnabled = true;
  bool _examRemindersEnabled = true;
  bool _dailyBriefingReminderEnabled = true;

  final Set<String> _bookmarkedArticleTitles = {};
  final List<QuizResult> _quizResults = [];

  bool get isSignedIn => _isSignedIn;

  String get name => _name;

  String get email => _email;

  String get preferredLanguage => _preferredLanguage;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get newsNotificationsEnabled => _newsNotificationsEnabled;

  bool get examRemindersEnabled => _examRemindersEnabled;

  bool get dailyBriefingReminderEnabled {
    return _dailyBriefingReminderEnabled;
  }

  int get bookmarkCount => _bookmarkedArticleTitles.length;

  List<String> get bookmarkedArticleTitles {
    return List.unmodifiable(_bookmarkedArticleTitles);
  }

  int get completedQuizCount => _quizResults.length;

  List<QuizResult> get quizResults {
    return List.unmodifiable(_quizResults);
  }

  List<double> get quizPercentages {
    return List.unmodifiable(_quizResults.map((result) => result.percentage));
  }

  int get averageQuizPercentage {
    if (_quizResults.isEmpty) {
      return 0;
    }

    final total = _quizResults.fold<double>(
      0,
      (sum, result) => sum + result.percentage,
    );

    return (total / _quizResults.length).round();
  }

  bool isArticleBookmarked(String title) {
    return _bookmarkedArticleTitles.contains(title);
  }

  void initializeAuthentication() {
    if (_authenticationInitialized) {
      return;
    }

    _authenticationInitialized = true;
    _applyFirebaseUser(FirebaseAuth.instance.currentUser);
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      _applyFirebaseUser,
    );
  }

  void refreshAuthenticationUser() {
    _applyFirebaseUser(FirebaseAuth.instance.currentUser);
  }

  void _applyFirebaseUser(User? user) {
    _isSignedIn = user != null;

    if (user != null) {
      final displayName = user.displayName?.trim() ?? '';
      final email = user.email?.trim() ?? '';

      if (displayName.isNotEmpty) {
        _name = displayName;
      } else if (email.isNotEmpty) {
        _name = email.split('@').first;
      } else {
        _name = 'NewsLLM Student';
      }
      _email = email;
    } else {
      _name = '';
      _email = '';

      // Language and theme remain device preferences after sign-out.
      _newsNotificationsEnabled = true;
      _examRemindersEnabled = true;
      _dailyBriefingReminderEnabled = true;

      _bookmarkedArticleTitles.clear();
      _quizResults.clear();
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void updatePreferredLanguage(String language) {
    if (_preferredLanguage == language) {
      return;
    }

    _preferredLanguage = language;
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    notifyListeners();
  }

  void updateNewsNotifications(bool enabled) {
    _newsNotificationsEnabled = enabled;
    notifyListeners();
  }

  void updateExamReminders(bool enabled) {
    _examRemindersEnabled = enabled;
    notifyListeners();
  }

  void updateDailyBriefingReminder(bool enabled) {
    _dailyBriefingReminderEnabled = enabled;
    notifyListeners();
  }

  void recordQuizResult({
    required int score,
    required int totalQuestions,
    String quizId = 'daily-news-quiz',
    String quizTitle = 'Daily news quiz',
    QuizType quizType = QuizType.daily,
    String? relatedArticleTitle,
  }) {
    if (!_isSignedIn || totalQuestions == 0) {
      return;
    }

    final previousAttempts = _quizResults.where(
      (result) => result.quizId == quizId,
    );

    final result = QuizResult(
      quizId: quizId,
      quizTitle: quizTitle,
      quizType: quizType,
      relatedArticleTitle: relatedArticleTitle,
      score: score,
      totalQuestions: totalQuestions,
      attemptNumber: previousAttempts.length + 1,
      completedAt: DateTime.now(),
    );

    _quizResults.add(result);
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
