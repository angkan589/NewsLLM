import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      (total, result) => total + result.percentage,
    );

    return (total / _quizResults.length).round();
  }

  bool isArticleBookmarked(String title) {
    return _bookmarkedArticleTitles.contains(title);
  }

  Future<void> initializeAuthentication() async {
    if (_authenticationInitialized) {
      return;
    }

    _authenticationInitialized = true;
    await _applyFirebaseUser(FirebaseAuth.instance.currentUser);
    _authSubscription = FirebaseAuth.instance.authStateChanges().skip(1).listen(
      (user) {
        unawaited(_applyFirebaseUser(user));
      },
    );
  }

  Future<void> refreshAuthenticationUser() async {
    await _applyFirebaseUser(FirebaseAuth.instance.currentUser);
  }

  Future<void> _applyFirebaseUser(User? user) async {
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

      notifyListeners();

      try {
        await _ensureAndLoadUserProfile(user);
      } on FirebaseException catch (error) {
        debugPrint('Could not load the Firestore user profile: $error');
      }
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

  DocumentReference<Map<String, dynamic>> _userReference(User user) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid);
  }

  Map<String, dynamic> _newUserProfile(User user, {String? displayName}) {
    final resolvedName = displayName?.trim().isNotEmpty == true
        ? displayName!.trim()
        : _fallbackName(user);

    return {
      'uid': user.uid,
      'displayName': resolvedName,
      'email': user.email?.trim() ?? '',
      'preferredLanguage': 'English',
      'themeMode': 'light',
      'newsNotificationsEnabled': true,
      'examRemindersEnabled': true,
      'dailyBriefingReminderEnabled': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  String _fallbackName(User user) {
    final displayName = user.displayName?.trim() ?? '';
    final email = user.email?.trim() ?? '';

    if (displayName.isNotEmpty) {
      return displayName;
    }
    if (email.isNotEmpty) {
      return email.split('@').first;
    }
    return 'NewsLLM Student';
  }

  Future<void> _ensureAndLoadUserProfile(User user) async {
    final reference = _userReference(user);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);

      if (!snapshot.exists) {
        transaction.set(reference, _newUserProfile(user));
      }
    });

    final snapshot = await reference.get();

    if (FirebaseAuth.instance.currentUser?.uid != user.uid) {
      return;
    }

    final data = snapshot.data();
    if (data == null) {
      return;
    }

    _loadUserProfile(data);
  }

  void _loadUserProfile(Map<String, dynamic> data) {
    final displayName = data['displayName'];
    final preferredLanguage = data['preferredLanguage'];
    final themeMode = data['themeMode'];
    final newsNotificationsEnabled = data['newsNotificationsEnabled'];
    final examRemindersEnabled = data['examRemindersEnabled'];
    final dailyBriefingReminderEnabled = data['dailyBriefingReminderEnabled'];

    if (displayName is String && displayName.trim().isNotEmpty) {
      _name = displayName.trim();
    }
    if (preferredLanguage is String && preferredLanguage.isNotEmpty) {
      _preferredLanguage = preferredLanguage;
    }

    _themeMode = themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;

    if (newsNotificationsEnabled is bool) {
      _newsNotificationsEnabled = newsNotificationsEnabled;
    }
    if (examRemindersEnabled is bool) {
      _examRemindersEnabled = examRemindersEnabled;
    }
    if (dailyBriefingReminderEnabled is bool) {
      _dailyBriefingReminderEnabled = dailyBriefingReminderEnabled;
    }

    notifyListeners();
  }

  Future<void> saveUserProfile({required String displayName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final reference = _userReference(user);
    final resolvedName = displayName.trim();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);

      if (snapshot.exists) {
        transaction.update(reference, {
          'displayName': resolvedName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(
          reference,
          _newUserProfile(user, displayName: resolvedName),
        );
      }
    });

    await _ensureAndLoadUserProfile(user);
  }

  Future<void> _updateUserFields(Map<String, dynamic> fields) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      await _userReference(
        user,
      ).update({...fields, 'updatedAt': FieldValue.serverTimestamp()});
    } on FirebaseException catch (error) {
      debugPrint('Could not save the Firestore user profile: $error');
    }
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
    unawaited(_updateUserFields({'preferredLanguage': language}));
  }

  void updateThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();
    unawaited(
      _updateUserFields({
        'themeMode': mode == ThemeMode.dark ? 'dark' : 'light',
      }),
    );
  }

  void toggleTheme() {
    updateThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  void updateNewsNotifications(bool enabled) {
    _newsNotificationsEnabled = enabled;
    notifyListeners();
    unawaited(_updateUserFields({'newsNotificationsEnabled': enabled}));
  }

  void updateExamReminders(bool enabled) {
    _examRemindersEnabled = enabled;
    notifyListeners();
    unawaited(_updateUserFields({'examRemindersEnabled': enabled}));
  }

  void updateDailyBriefingReminder(bool enabled) {
    _dailyBriefingReminderEnabled = enabled;
    notifyListeners();
    unawaited(_updateUserFields({'dailyBriefingReminderEnabled': enabled}));
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
