import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';
import 'package:newsllm/features/quiz/presentation/pages/daily_quiz_page.dart';
import 'package:newsllm/features/quiz/presentation/pages/quiz_page.dart';

class QuizHubPage extends StatelessWidget {
  const QuizHubPage({super.key});

  static const List<_PracticeQuiz> _practiceQuizzes = [
    _PracticeQuiz(
      description: 'Test your understanding of important national affairs.',
      icon: Icons.account_balance_outlined,
      color: AppColors.primary,
      quiz: QuizDefinition(
        id: 'national-practice-01',
        title: 'National affairs practice',
        type: QuizType.practice,
        questions: [
          QuizQuestion(
            id: 'national-01',
            question:
                'What is a major goal of a national green-growth roadmap?',
            options: [
              'Building a climate-resilient economy',
              'Reducing renewable-energy use',
              'Stopping infrastructure development',
              'Limiting employment opportunities',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Green growth connects economic development with environmental sustainability.',
          ),
          QuizQuestion(
            id: 'national-02',
            question:
                'Which sector is commonly included in digital development programmes?',
            options: [
              'Education and public services',
              'Celebrity entertainment only',
              'Foreign tourism only',
              'Professional sports only',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Digital development commonly improves education and public-service accessibility.',
          ),
          QuizQuestion(
            id: 'national-03',
            question:
                'Why are climate-resilient infrastructure projects important?',
            options: [
              'They help communities withstand environmental risks',
              'They remove the need for public planning',
              'They prevent every natural disaster',
              'They reduce access to essential services',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Resilient infrastructure reduces vulnerability and supports recovery.',
          ),
          QuizQuestion(
            id: 'national-04',
            question:
                'What should students identify when revising a national policy?',
            options: [
              'Objective, authority and expected impact',
              'Only the headline font',
              'Only the publication date',
              'Unrelated international events',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Objective, responsible authority and impact are central examination points.',
          ),
        ],
      ),
    ),
    _PracticeQuiz(
      description: 'Review trade, diplomacy and international cooperation.',
      icon: Icons.public_rounded,
      color: Color(0xFF7C3AED),
      quiz: QuizDefinition(
        id: 'international-practice-01',
        title: 'International affairs practice',
        type: QuizType.practice,
        questions: [
          QuizQuestion(
            id: 'international-01',
            question:
                'Why do countries participate in regional economic cooperation?',
            options: [
              'To improve trade and shared development',
              'To eliminate all international communication',
              'To prevent technological collaboration',
              'To close every regional market',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Regional cooperation can strengthen trade, investment and development.',
          ),
          QuizQuestion(
            id: 'international-02',
            question:
                'What is an important purpose of international climate partnerships?',
            options: [
              'Sharing resources, research and solutions',
              'Stopping environmental research',
              'Preventing renewable-energy investment',
              'Replacing every national institution',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Climate challenges often require shared knowledge, funding and coordinated action.',
          ),
          QuizQuestion(
            id: 'international-03',
            question: 'Which activity represents diplomatic cooperation?',
            options: [
              'Countries negotiating a shared agreement',
              'A company changing its logo',
              'A local sports team selecting players',
              'A person purchasing a mobile phone',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Negotiation between countries is a central diplomatic activity.',
          ),
        ],
      ),
    ),
    _PracticeQuiz(
      description: 'Practice questions on business and digital finance.',
      icon: Icons.trending_up_rounded,
      color: Color(0xFFD97706),
      quiz: QuizDefinition(
        id: 'business-practice-01',
        title: 'Business and economy practice',
        type: QuizType.practice,
        questions: [
          QuizQuestion(
            id: 'business-01',
            question: 'Why are digital payment services expanding?',
            options: [
              'To make transactions faster and more accessible',
              'To prevent online transactions',
              'To eliminate all financial institutions',
              'To make payments less secure',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Digital payments improve speed, accessibility and convenience.',
          ),
          QuizQuestion(
            id: 'business-02',
            question: 'How can technology support small businesses?',
            options: [
              'By helping manage customers, sales and records',
              'By preventing communication with customers',
              'By removing every business employee',
              'By stopping financial planning',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Digital tools can improve business administration and decision-making.',
          ),
        ],
      ),
    ),
    _PracticeQuiz(
      description: 'Explore technology, satellites and scientific innovation.',
      icon: Icons.science_outlined,
      color: Color(0xFF059669),
      quiz: QuizDefinition(
        id: 'science-technology-practice-01',
        title: 'Science and technology practice',
        type: QuizType.practice,
        questions: [
          QuizQuestion(
            id: 'science-01',
            question: 'How can satellite data support disaster management?',
            options: [
              'By improving monitoring and early warnings',
              'By stopping every natural disaster',
              'By replacing all emergency workers',
              'By preventing weather observation',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Satellite data provides observations that support monitoring and warning systems.',
          ),
          QuizQuestion(
            id: 'science-02',
            question:
                'What is a possible benefit of efficient solar technology?',
            options: [
              'More renewable-energy production at lower cost',
              'Permanent elimination of sunlight',
              'Less access to clean energy',
              'An end to scientific research',
            ],
            correctAnswerIndex: 0,
            explanation:
                'Efficiency improvements can increase output and reduce energy costs.',
          ),
          QuizQuestion(
            id: 'science-03',
            question:
                'How can artificial intelligence support medical research?',
            options: [
              'By helping analyze complex information',
              'By guaranteeing every treatment will work',
              'By removing the need for medical experts',
              'By preventing the collection of evidence',
            ],
            correctAnswerIndex: 0,
            explanation:
                'AI can assist researchers with analysis, but it does not replace medical expertise.',
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const MainNavigationBar(
        currentDestination: MainDestination.quiz,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Quiz centre',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                const Text(
                  'Practice by topic',
                  style: TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 760 ? 2 : 1;
                    const spacing = 16.0;
                    final width =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: _practiceQuizzes.map((practiceQuiz) {
                        return SizedBox(
                          width: width,
                          child: _QuizCard(data: practiceQuiz),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.darkNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.quiz_rounded, color: Colors.white, size: 52),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test what you learned today',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Take the daily exam or practise individual current-affairs topics.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DailyQuizPage(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6EE7B7),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start daily quiz'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.data});

  final _PracticeQuiz data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.color, size: 30),
          const SizedBox(height: 17),
          Text(
            data.quiz.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 14),
          Text(
            '${data.quiz.questions.length} questions',
            style: TextStyle(
              color: data.color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      QuizPage(quiz: data.quiz, accentColor: data.color),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start practice'),
          ),
        ],
      ),
    );
  }
}

class _PracticeQuiz {
  const _PracticeQuiz({
    required this.description,
    required this.icon,
    required this.color,
    required this.quiz,
  });

  final String description;
  final IconData icon;
  final Color color;
  final QuizDefinition quiz;
}
