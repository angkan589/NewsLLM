import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

class FirestoreNewsRepository {
  FirestoreNewsRepository._();

  static List<_FirestoreArticleRecord> _records = [];

  static Future<void> initialize() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('articles')
          .where('isPublished', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .get();

      _records = snapshot.docs
          .map(
            (document) =>
                _FirestoreArticleRecord(id: document.id, data: document.data()),
          )
          .toList();
    } on FirebaseException catch (error) {
      debugPrint('Could not load Firestore news; using demo news: $error');
      _records = [];
    }
  }

  static bool get isUsingFirestore => _records.isNotEmpty;

  static List<NewsArticle> get articles {
    if (_records.isEmpty) {
      return MockNewsRepository.articles;
    }

    final languageCode = AppSession.instance.preferredLanguage == 'বাংলা'
        ? 'bn'
        : 'en';

    return _records
        .map((record) => record.toNewsArticle(languageCode))
        .toList();
  }

  static NewsArticle? findById(String id) {
    if (_records.isEmpty) {
      return MockNewsRepository.findById(id);
    }

    for (final record in _records) {
      if (record.id == id) {
        return record.toNewsArticle(_languageCode);
      }
    }

    return null;
  }

  static NewsArticle? findByTitle(String title) {
    if (_records.isEmpty) {
      return MockNewsRepository.findByTitle(title);
    }

    for (final record in _records) {
      if (record.hasTitle(title)) {
        return record.toNewsArticle(_languageCode);
      }
    }

    return null;
  }

  static List<NewsArticle> articlesByCategory(String category) {
    final normalizedCategory = category.trim().toLowerCase();

    return articles.where((article) {
      final articleCategory = article.category.toLowerCase();

      if (normalizedCategory == 'science & tech') {
        return articleCategory == 'science' ||
            articleCategory == 'technology' ||
            articleCategory == 'science & tech';
      }

      return articleCategory == normalizedCategory;
    }).toList();
  }

  static List<NewsArticle> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return articles;
    }

    if (_records.isNotEmpty) {
      return _records
          .where((record) => record.matchesQuery(normalizedQuery))
          .map((record) => record.toNewsArticle(_languageCode))
          .toList();
    }

    return articles.where((article) {
      return article.title.toLowerCase().contains(normalizedQuery) ||
          article.summary.toLowerCase().contains(normalizedQuery) ||
          article.category.toLowerCase().contains(normalizedQuery) ||
          article.newspaperName.toLowerCase().contains(normalizedQuery) ||
          article.keyTerms.any(
            (term) => term.toLowerCase().contains(normalizedQuery),
          );
    }).toList();
  }

  static String get _languageCode {
    return AppSession.instance.preferredLanguage == 'বাংলা' ? 'bn' : 'en';
  }
}

class _FirestoreArticleRecord {
  const _FirestoreArticleRecord({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;

  bool hasTitle(String title) {
    final localizedContent = _map(data['localizedContent']);
    final english = _map(localizedContent['en']);
    final bangla = _map(localizedContent['bn']);

    return _string(english['title']) == title ||
        _string(bangla['title']) == title;
  }

  bool matchesQuery(String normalizedQuery) {
    final localizedContent = _map(data['localizedContent']);
    final searchableValues = <String>[
      _string(data['category']),
      _string(data['sourceName']),
      _string(data['sourceReference']),
    ];

    for (final languageCode in ['en', 'bn']) {
      final content = _map(localizedContent[languageCode]);
      searchableValues
        ..add(_string(content['title']))
        ..add(_string(content['summary']))
        ..addAll(_strings(content['keyTerms']));
    }

    return searchableValues.any(
      (value) => value.toLowerCase().contains(normalizedQuery),
    );
  }

  NewsArticle toNewsArticle(String languageCode) {
    final localizedContent = _map(data['localizedContent']);
    final english = _map(localizedContent['en']);
    final requested = _map(localizedContent[languageCode]);
    final content = requested.isEmpty ? english : requested;
    final category = _string(data['category'], fallback: 'GENERAL');

    return NewsArticle(
      id: id,
      newspaperName: _string(
        data['sourceName'],
        fallback: _string(data['sourceReference'], fallback: 'News source'),
      ),
      category: category,
      title: _string(
        content['title'],
        fallback: _string(english['title'], fallback: 'Untitled briefing'),
      ),
      summary: _string(
        content['summary'],
        fallback: _string(english['summary']),
      ),
      content: _string(
        content['content'],
        fallback: _string(english['content']),
      ),
      examTakeaway: _string(
        content['examTakeaway'],
        fallback: _string(english['examTakeaway']),
      ),
      readingTime: _string(data['readingTime'], fallback: '3 min read'),
      accentColor: _accentColor(category),
      facts: _facts(content['facts'], fallback: english['facts']),
      keyTerms: _strings(content['keyTerms'], fallback: english['keyTerms']),
      quizQuestions: _quizQuestions(
        data['quizQuestions'],
        languageCode: languageCode,
      ),
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
  }

  static String _string(dynamic value, {String fallback = ''}) {
    return value is String && value.trim().isNotEmpty ? value.trim() : fallback;
  }

  static List<String> _strings(dynamic value, {dynamic fallback}) {
    final requested = value is List ? value : fallback;

    if (requested is! List) {
      return [];
    }

    return requested.whereType<String>().toList();
  }

  static List<NewsFact> _facts(dynamic value, {dynamic fallback}) {
    final requested = value is List ? value : fallback;

    if (requested is! List) {
      return [];
    }

    return requested
        .map(_map)
        .where((fact) => fact.isNotEmpty)
        .map((fact) {
          return NewsFact(
            label: _string(fact['label']),
            value: _string(fact['value']),
          );
        })
        .where((fact) {
          return fact.label.isNotEmpty && fact.value.isNotEmpty;
        })
        .toList();
  }

  static List<QuizQuestion> _quizQuestions(
    dynamic value, {
    required String languageCode,
  }) {
    if (value is! List) {
      return [];
    }

    final questions = <QuizQuestion>[];

    for (final rawQuestion in value) {
      final question = _map(rawQuestion);
      final questionText = _localizedString(question['question'], languageCode);
      final options = _localizedStrings(question['options'], languageCode);
      final explanation = _localizedString(
        question['explanation'],
        languageCode,
      );
      final correctAnswerIndex = question['correctAnswerIndex'];

      if (questionText.isEmpty ||
          options.length < 2 ||
          correctAnswerIndex is! int ||
          correctAnswerIndex < 0 ||
          correctAnswerIndex >= options.length) {
        continue;
      }

      questions.add(
        QuizQuestion(
          id: _string(
            question['id'],
            fallback: 'question-${questions.length + 1}',
          ),
          question: questionText,
          options: options,
          correctAnswerIndex: correctAnswerIndex,
          explanation: explanation,
        ),
      );
    }

    return questions;
  }

  static String _localizedString(dynamic value, String languageCode) {
    final values = _map(value);
    return _string(values[languageCode], fallback: _string(values['en']));
  }

  static List<String> _localizedStrings(dynamic value, String languageCode) {
    final values = _map(value);
    return _strings(values[languageCode], fallback: values['en']);
  }

  static Color _accentColor(String category) {
    return switch (category.toUpperCase()) {
      'INTERNATIONAL' => const Color(0xFF7C3AED),
      'BUSINESS' => const Color(0xFFD97706),
      'SPORTS' => const Color(0xFFE11D48),
      'SCIENCE' || 'SCIENCE & TECH' || 'TECHNOLOGY' => const Color(0xFF0F766E),
      _ => AppColors.primary,
    };
  }
}
