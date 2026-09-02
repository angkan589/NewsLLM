import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.quiz,
    this.accentColor = AppColors.primary,
    this.bottomNavigationBar,
  });

  final QuizDefinition quiz;
  final Color accentColor;
  final Widget? bottomNavigationBar;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;
  bool _completed = false;

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _continue() {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an answer before continuing.')),
      );
      return;
    }

    final question = widget.quiz.questions[_currentIndex];
    final isCorrect = _selectedAnswerIndex == question.correctAnswerIndex;
    final updatedScore = isCorrect ? _score + 1 : _score;
    final isLastQuestion = _currentIndex == widget.quiz.questions.length - 1;

    if (isLastQuestion) {
      setState(() {
        _score = updatedScore;
        _completed = true;
      });

      _recordResult(updatedScore);
      return;
    }

    setState(() {
      _score = updatedScore;
      _currentIndex++;
      _selectedAnswerIndex = null;
    });
  }

  void _recordResult(int finalScore) {
    if (AppSession.instance.isSignedIn) {
      AppSession.instance.recordQuizResult(
        quizId: widget.quiz.id,
        quizTitle: widget.quiz.title,
        quizType: widget.quiz.type,
        relatedArticleTitle: widget.quiz.relatedArticleTitle,
        score: finalScore,
        totalQuestions: widget.quiz.questions.length,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz attempt saved to your profile.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Guest attempt is not saved. Sign in to track your progress.',
          ),
        ),
      );
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswerIndex = null;
      _score = 0;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quiz.questions.isEmpty) {
      return _buildEmptyQuiz();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
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
        title: Text(
          widget.quiz.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: _completed ? _buildResult() : _buildQuestion(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final question = widget.quiz.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.quiz.questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Question ${_currentIndex + 1} of '
              '${widget.quiz.questions.length}',
              style: TextStyle(
                color: widget.accentColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              switch (widget.quiz.type) {
                QuizType.daily => 'DAILY QUIZ',
                QuizType.article => 'ARTICLE QUIZ',
                QuizType.practice => 'PRACTICE QUIZ',
              },
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: AppColors.border,
            color: widget.accentColor,
          ),
        ),
        const SizedBox(height: 26),
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
              ...List.generate(question.options.length, (index) {
                return _buildOption(index, question.options[index]);
              }),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                  child: Text(
                    _currentIndex == widget.quiz.questions.length - 1
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

  Widget _buildOption(int index, String text) {
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
                ? widget.accentColor.withValues(alpha: 0.08)
                : AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? widget.accentColor : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? widget.accentColor : AppColors.textSecondary,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: selected
                        ? widget.accentColor
                        : AppColors.textPrimary,
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

  Widget _buildResult() {
    final percentage = (_score / widget.quiz.questions.length * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: widget.accentColor,
              size: 44,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Quiz completed!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 29,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You answered $_score of '
            '${widget.quiz.questions.length} correctly.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            '$percentage%',
            style: TextStyle(
              color: widget.accentColor,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _restart,
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
              label: const Text('Leave quiz'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQuiz() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Quiz unavailable'),
      ),
      body: const Center(
        child: Text('No questions are available for this quiz.'),
      ),
    );
  }
}
