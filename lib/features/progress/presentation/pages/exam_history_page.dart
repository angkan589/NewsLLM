import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class ExamHistoryPage extends StatelessWidget {
  const ExamHistoryPage({super.key});

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
          'Exam history',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, child) {
          final results = AppSession.instance.quizPercentages;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: results.isEmpty
                    ? _buildEmptyState(context)
                    : _buildHistory(results),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistory(List<double> results) {
    final newestFirst = results.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your results',
          style: TextStyle(
            color: AppColors.darkNavy,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${results.length} completed ${results.length == 1 ? 'exam' : 'exams'}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          newestFirst.length,
          (index) {
            final percentage = newestFirst[index].round();
            final attemptNumber = results.length - index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ExamResultCard(
                attemptNumber: attemptNumber,
                percentage: percentage,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'No exam history',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Complete a daily quiz while signed in and your result will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to profile'),
          ),
        ],
      ),
    );
  }
}

class _ExamResultCard extends StatelessWidget {
  const _ExamResultCard({
    required this.attemptNumber,
    required this.percentage,
  });

  final int attemptNumber;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final passed = percentage >= 60;
    final color = passed
        ? const Color(0xFF059669)
        : const Color(0xFFDC2626);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              passed
                  ? Icons.check_circle_outline_rounded
                  : Icons.refresh_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily quiz attempt $attemptNumber',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  passed ? 'Passed' : 'Needs improvement',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}