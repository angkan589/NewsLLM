import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsllm/features/news/data/firestore_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';
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

  final Map<String, Map<String, dynamic>> _bookmarkSnapshots = {};

  NewsArticle? bookmarkedArticle(String title) {
    final snapshot = _bookmarkSnapshots[title];
    return snapshot == null
        ? FirestoreNewsRepository.findByTitle(title)
        : FirestoreNewsRepository.articleFromSnapshot(snapshot);
  }

  final Set<String> _bookmarkedArticleTitles = {};
  final List<QuizResult> _quizResults = [];

  bool get isSignedIn => _isSignedIn;

  String get name => _name;

  String get email => _email;

  String get preferredLanguage => _preferredLanguage;

  bool get isBangla => _preferredLanguage == 'বাংলা';

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

  String _bookmarkKey(String title, {String? sourceId}) {
    for (final entry in _bookmarkSnapshots.entries) {
      if (sourceId != null && entry.value['id'] == sourceId) {
        return entry.key;
      }
      if (sourceId == null) {
        final data = entry.value['data'] as Map;
        final localized = data['localizedContent'];
        if (localized is Map &&
            localized.values.any(
              (content) => content is Map && content['title'] == title,
            )) {
          return entry.key;
        }
      }
    }
    return title;
  }

  bool isArticleBookmarked(String title, {String? sourceId}) {
    return _bookmarkedArticleTitles.contains(
      _bookmarkKey(title, sourceId: sourceId),
    );
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
    _bookmarkSnapshots.clear();
    _bookmarkedArticleTitles.clear();
    _quizResults.clear();
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

      try {
        await _loadLearningRecords(user);
      } on FirebaseException catch (error) {
        debugPrint('Could not load the Firestore learning records: $error');
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

  CollectionReference<Map<String, dynamic>> _bookmarksReference(User user) {
    return _userReference(user).collection('bookmarks');
  }

  CollectionReference<Map<String, dynamic>> _quizAttemptsReference(User user) {
    return _userReference(user).collection('quizAttempts');
  }

  String _bookmarkDocumentId(String title) {
    return base64Url.encode(utf8.encode(title)).replaceAll('=', '');
  }

  Future<void> _loadLearningRecords(User user) async {
    final results = await Future.wait([
      _bookmarksReference(user).get(),
      _quizAttemptsReference(user).get(),
    ]);

    if (FirebaseAuth.instance.currentUser?.uid != user.uid) {
      return;
    }

    final bookmarkSnapshot = results[0];
    final quizSnapshot = results[1];

    _bookmarkedArticleTitles
      ..clear()
      ..addAll(
        bookmarkSnapshot.docs
            .map((document) => document.data()['articleTitle'])
            .whereType<String>()
            .where((title) => title.isNotEmpty),
      );

    _bookmarkSnapshots.clear();
    for (final document in bookmarkSnapshot.docs) {
      final data = document.data();
      final snapshot = data['articleSnapshot'];
      if (data['articleTitle'] is String &&
          snapshot is Map &&
          snapshot['id'] is String &&
          snapshot['data'] is Map) {
        _bookmarkSnapshots[data['articleTitle'] as String] =
            Map<String, dynamic>.from(snapshot);
      }
    }

    final loadedQuizResults = <QuizResult>[];

    for (final document in quizSnapshot.docs) {
      final data = document.data();
      final quizId = data['quizId'];
      final quizTitle = data['quizTitle'];
      final quizTypeName = data['quizType'];
      final score = data['score'];
      final totalQuestions = data['totalQuestions'];
      final attemptNumber = data['attemptNumber'];
      final completedAt = data['completedAt'];

      if (quizId is! String ||
          quizTitle is! String ||
          quizTypeName is! String ||
          score is! int ||
          totalQuestions is! int ||
          attemptNumber is! int ||
          completedAt is! Timestamp) {
        continue;
      }

      final quizType = switch (quizTypeName) {
        'article' => QuizType.article,
        'practice' => QuizType.practice,
        _ => QuizType.daily,
      };
      final relatedArticleTitle = data['relatedArticleTitle'];

      loadedQuizResults.add(
        QuizResult(
          quizId: quizId,
          quizTitle: quizTitle,
          quizType: quizType,
          relatedArticleTitle: relatedArticleTitle is String
              ? relatedArticleTitle
              : null,
          score: score,
          totalQuestions: totalQuestions,
          attemptNumber: attemptNumber,
          completedAt: completedAt.toDate(),
        ),
      );
    }

    loadedQuizResults.sort(
      (first, second) => first.completedAt.compareTo(second.completedAt),
    );

    _quizResults
      ..clear()
      ..addAll(loadedQuizResults);

    notifyListeners();
  }

  Future<void> _saveBookmark(
    User user,
    String title, {
    Map<String, dynamic>? articleSnapshot,
  }) async {
    final snapshot =
        articleSnapshot ??
        FirestoreNewsRepository.snapshotForTitle(title) ??
        _bookmarkSnapshots[title];
    if (snapshot == null) throw StateError('Article snapshot unavailable');
    final articleId = _bookmarkDocumentId(title);
    await _bookmarksReference(user).doc(articleId).set({
      'articleId': articleId,
      'sourceArticleId': snapshot['id'],
      'articleTitle': title,
      'articleSnapshot': snapshot,
      'savedAt': FieldValue.serverTimestamp(),
    });
    if (FirebaseAuth.instance.currentUser?.uid == user.uid) {
      _bookmarkSnapshots[title] = snapshot;
    }
  }

  Future<void> _deleteBookmark(User user, String title) async {
    await _bookmarksReference(user).doc(_bookmarkDocumentId(title)).delete();
  }

  Future<void> _saveQuizResult(User user, QuizResult result) async {
    try {
      await _quizAttemptsReference(user).add({
        'userId': user.uid,
        'quizId': result.quizId,
        'quizTitle': result.quizTitle,
        'quizType': result.quizType.name,
        'relatedArticleTitle': result.relatedArticleTitle,
        'score': result.score,
        'totalQuestions': result.totalQuestions,
        'attemptNumber': result.attemptNumber,
        'accuracy': result.percentage,
        'completedAt': Timestamp.fromDate(result.completedAt),
      });
    } on FirebaseException catch (error) {
      debugPrint('Could not save the quiz attempt: $error');
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

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      unawaited(_saveQuizResult(user, result));
    }
  }

  Future<bool> toggleArticleBookmark(
    String title, {
    Map<String, dynamic>? articleSnapshot,
  }) async {
    title = _bookmarkKey(title, sourceId: articleSnapshot?['id'] as String?);
    final user = FirebaseAuth.instance.currentUser;
    if (!_isSignedIn || user == null) return false;
    final removing = _bookmarkedArticleTitles.contains(title);
    if (removing) {
      await _deleteBookmark(user, title);
    } else {
      await _saveBookmark(user, title, articleSnapshot: articleSnapshot);
    }
    if (FirebaseAuth.instance.currentUser?.uid != user.uid) return false;
    if (removing) {
      _bookmarkedArticleTitles.remove(title);
      _bookmarkSnapshots.remove(title);
    } else {
      _bookmarkedArticleTitles.add(title);
    }
    notifyListeners();
    return !removing;
  }

  Future<void> removeArticleBookmark(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _deleteBookmark(user, title);
    if (FirebaseAuth.instance.currentUser?.uid != user.uid) return;
    _bookmarkedArticleTitles.remove(title);
    _bookmarkSnapshots.remove(title);
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
