enum QuizType { daily, article, practice }

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
}

class QuizDefinition {
  const QuizDefinition({
    required this.id,
    required this.title,
    required this.type,
    required this.questions,
    this.relatedArticleTitle,
  });

  final String id;
  final String title;
  final QuizType type;
  final List<QuizQuestion> questions;
  final String? relatedArticleTitle;
}

class QuizResult {
  const QuizResult({
    required this.quizId,
    required this.quizTitle,
    required this.quizType,
    required this.score,
    required this.totalQuestions,
    required this.attemptNumber,
    required this.completedAt,
    this.relatedArticleTitle,
  });

  final String quizId;
  final String quizTitle;
  final QuizType quizType;
  final String? relatedArticleTitle;
  final int score;
  final int totalQuestions;
  final int attemptNumber;
  final DateTime completedAt;

  double get percentage {
    if (totalQuestions == 0) {
      return 0;
    }

    return score / totalQuestions * 100;
  }

  String get typeLabel {
    switch (quizType) {
      case QuizType.daily:
        return 'Daily quiz';
      case QuizType.article:
        return 'Article quiz';
      case QuizType.practice:
        return 'Practice quiz';
    }
  }
}
