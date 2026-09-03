import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';
import 'package:newsllm/features/quiz/presentation/pages/quiz_page.dart';

class DailyQuizPage extends StatelessWidget {
  const DailyQuizPage({super.key});

  static const QuizDefinition _dailyQuiz = QuizDefinition(
    id: 'daily-news-2026-08-20',
    title: 'Daily news quiz — 20 August 2026',
    type: QuizType.daily,
    questions: [
      QuizQuestion(
        id: 'daily-1',
        question:
            'What is the main purpose of Bangladesh’s green growth roadmap?',
        options: [
          'To develop a climate-resilient economy',
          'To reduce renewable-energy production',
          'To restrict employment opportunities',
          'To replace all existing industries',
        ],
        correctAnswerIndex: 0,
        explanation:
            'The roadmap focuses on sustainable development and a climate-resilient economy.',
      ),
      QuizQuestion(
        id: 'daily-2',
        question: 'Which area is prioritised by the green growth roadmap?',
        options: [
          'Renewable energy',
          'Luxury imports',
          'Private entertainment',
          'International tourism only',
        ],
        correctAnswerIndex: 0,
        explanation:
            'Renewable energy is one of the roadmap’s main priorities.',
      ),
      QuizQuestion(
        id: 'daily-3',
        question: 'What did regional leaders recently discuss strengthening?',
        options: [
          'Economic cooperation',
          'Military competition',
          'Travel restrictions',
          'Import bans',
        ],
        correctAnswerIndex: 0,
        explanation:
            'The leaders discussed trade, technology and stronger economic cooperation.',
      ),
      QuizQuestion(
        id: 'daily-4',
        question: 'Why are digital payment services continuing to expand?',
        options: [
          'To make transactions faster and more accessible',
          'To eliminate all physical businesses',
          'To reduce access to banking services',
          'To prevent online transactions',
        ],
        correctAnswerIndex: 0,
        explanation:
            'Digital payments aim to make transactions faster, safer and more accessible.',
      ),
      QuizQuestion(
        id: 'daily-5',
        question: 'How can satellite data improve disaster management?',
        options: [
          'By providing faster and more accurate warnings',
          'By preventing every natural disaster',
          'By replacing emergency services',
          'By reducing access to weather information',
        ],
        correctAnswerIndex: 0,
        explanation:
            'Satellite data helps authorities issue faster and more accurate warnings.',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return QuizPage(
      quiz: _dailyQuiz,
      bottomNavigationBar: MainNavigationBar(
        currentDestination: MainDestination.quiz,
      ),
    );
  }
}
