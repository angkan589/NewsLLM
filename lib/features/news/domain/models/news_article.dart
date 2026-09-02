import 'package:flutter/material.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

class NewsFact {
  const NewsFact({required this.label, required this.value});

  final String label;
  final String value;
}

class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.newspaperName,
    required this.category,
    required this.title,
    required this.summary,
    required this.content,
    required this.examTakeaway,
    required this.readingTime,
    required this.accentColor,
    required this.facts,
    required this.keyTerms,
    required this.quizQuestions,
  });

  final String id;
  final String newspaperName;
  final String category;
  final String title;
  final String summary;
  final String content;
  final String examTakeaway;
  final String readingTime;
  final Color accentColor;
  final List<NewsFact> facts;
  final List<String> keyTerms;
  final List<QuizQuestion> quizQuestions;

  QuizDefinition get quiz {
    return QuizDefinition(
      id: 'article-$id',
      title: '$category article quiz',
      type: QuizType.article,
      relatedArticleTitle: title,
      questions: quizQuestions,
    );
  }
}
