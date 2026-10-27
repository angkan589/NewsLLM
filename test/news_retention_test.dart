import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsllm/features/news/data/firestore_news_repository.dart';

void main() {
  test('today uses Dhaka midnight, independent of device timezone', () {
    final now = DateTime.utc(2026, 10, 27, 18); // Oct 28, 00:00 in Dhaka
    expect(FirestoreNewsRepository.isToday(DateTime.utc(2026, 10, 27, 17, 59), now), isFalse);
    expect(FirestoreNewsRepository.isToday(DateTime.utc(2026, 10, 27, 18), now), isTrue);
  });

  test('retention is exactly seven days', () {
    expect(FirestoreNewsRepository.retentionCutoff(DateTime.utc(2026, 10, 27, 12)),
        DateTime.utc(2026, 10, 20, 12));
  });

  test('archived snapshot opens without a live article', () {
    final article = FirestoreNewsRepository.articleFromSnapshot({
      'id': 'expired-story',
      'data': {
        'publishedAt': Timestamp.fromDate(DateTime.utc(2020)),
        'sourceName': 'Test source',
        'localizedContent': {
          'en': {
            'title': 'Preserved story',
            'content': 'Full article text',
            'facts': [{'label': 'WHAT', 'value': 'A saved fact'}],
          },
        },
        'quizQuestions': [{
          'id': 'q1',
          'question': {'en': 'Saved question?'},
          'options': {'en': ['A', 'B']},
          'correctAnswerIndex': 0,
          'explanation': {'en': 'Saved explanation'},
        }],
      },
    });
    expect(article.title, 'Preserved story');
    expect(article.content, 'Full article text');
    expect(article.facts.single.value, 'A saved fact');
    expect(article.quizQuestions.single.correctAnswerIndex, 0);
    expect(article.snapshot?['id'], 'expired-story');
    expect(FirestoreNewsRepository.articles, isEmpty);
    expect(FirestoreNewsRepository.todayArticles, isEmpty);
  });
}
