import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

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
          final results = AppSession.instance.quizResults.reversed.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
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

  Widget _buildHistory(List<QuizResult> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your exam attempts',
          style: TextStyle(
            color: AppColors.darkNavy,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${results.length} recorded ${results.length == 1 ? 'attempt' : 'attempts'}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 24),
        ...results.map(
          (result) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _QuizResultCard(result: result),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
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
              Icons.history_rounded,
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
            'Complete a quiz while signed in and your attempt will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
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

class _QuizResultCard extends StatelessWidget {
  const _QuizResultCard({required this.result});

  final QuizResult result;

  @override
  Widget build(BuildContext context) {
    final percentage = result.percentage.round();
    final passed = percentage >= 60;

    final statusColor = passed
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              result.quizType == QuizType.daily
                  ? Icons.calendar_today_outlined
                  : Icons.article_outlined,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _ResultBadge(
                      text: result.typeLabel,
                      color: result.quizType == QuizType.daily
                          ? AppColors.primary
                          : const Color(0xFF7C3AED),
                    ),
                    _ResultBadge(
                      text: 'Attempt ${result.attemptNumber}',
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  result.quizTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                if (result.relatedArticleTitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    result.relatedArticleTitle!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 11),
                Wrap(
                  spacing: 18,
                  runSpacing: 6,
                  children: [
                    Text(
                      '${result.score}/${result.totalQuestions} correct',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDateTime(result.completedAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                passed ? 'Passed' : 'Review',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();

    final hourValue = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year • $hourValue:$minute $period';
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
