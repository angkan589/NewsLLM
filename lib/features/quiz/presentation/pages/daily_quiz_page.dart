import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/core/session/app_session.dart';

class DailyQuizPage extends StatefulWidget {
  const DailyQuizPage({super.key});

  @override
  State<DailyQuizPage> createState() => _DailyQuizPageState();
}

class _DailyQuizPageState extends State<DailyQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _quizCompleted = false;

  final List<_QuizQuestion> _questions = const [
    _QuizQuestion(
      question:
          'What is the main purpose of Bangladesh’s green growth roadmap?',
      options: [
        'To develop a climate-resilient economy',
        'To reduce renewable-energy production',
        'To restrict employment opportunities',
        'To replace all existing industries',
      ],
      correctAnswerIndex: 0,
    ),
    _QuizQuestion(
      question: 'Which area is prioritised by the green growth roadmap?',
      options: [
        'Renewable energy',
        'Luxury imports',
        'Private entertainment',
        'International tourism only',
      ],
      correctAnswerIndex: 0,
    ),
    _QuizQuestion(
      question: 'What did regional leaders recently discuss strengthening?',
      options: [
        'Economic cooperation',
        'Military competition',
        'Travel restrictions',
        'Import bans',
      ],
      correctAnswerIndex: 0,
    ),
    _QuizQuestion(
      question: 'Why are digital payment services continuing to expand?',
      options: [
        'To make transactions faster and more accessible',
        'To eliminate all physical businesses',
        'To reduce access to banking services',
        'To prevent online transactions',
      ],
      correctAnswerIndex: 0,
    ),
    _QuizQuestion(
      question: 'How can satellite data improve national disaster management?',
      options: [
        'By providing faster and more accurate warnings',
        'By preventing all natural disasters',
        'By replacing emergency services',
        'By reducing access to weather information',
      ],
      correctAnswerIndex: 0,
    ),
  ];

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _continueQuiz() {
  if (_selectedAnswerIndex == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select an answer before continuing.'),
      ),
    );
    return;
  }

  final selectedCorrectly = _selectedAnswerIndex ==
      _questions[_currentQuestionIndex].correctAnswerIndex;

  final updatedScore = selectedCorrectly ? _score + 1 : _score;
  final isLastQuestion =
      _currentQuestionIndex == _questions.length - 1;

  if (isLastQuestion) {
    setState(() {
      _score = updatedScore;
      _quizCompleted = true;
    });

    if (AppSession.instance.isSignedIn) {
      AppSession.instance.recordQuizResult(
        score: updatedScore,
        totalQuestions: _questions.length,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz result saved to your profile.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Guest result is not saved. Sign in to track your progress.',
          ),
        ),
      );
    }

    return;
  }

  setState(() {
    _score = updatedScore;
    _currentQuestionIndex++;
    _selectedAnswerIndex = null;
  });
}
  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Daily quiz',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: _quizCompleted ? _buildResultCard() : _buildQuestionCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.quiz_outlined, color: AppColors.primary),
                  SizedBox(width: 9),
                  Text(
                    'CURRENT AFFAIRS',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                question.question,
                style: const TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 26),
              ...List.generate(
                question.options.length,
                (index) => _buildAnswerOption(
                  index: index,
                  text: question.options[index],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _continueQuiz,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1
                        ? 'Finish quiz'
                        : 'Next question',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOption({required int index, required String text}) {
    final selected = _selectedAnswerIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _selectAnswer(index);
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final percentage = (_score / _questions.length * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.accent,
              size: 44,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Quiz completed!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You answered $_score out of ${_questions.length} correctly.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _restartQuiz,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Try again'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to homepage'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  final String question;
  final List<String> options;
  final int correctAnswerIndex;
}
