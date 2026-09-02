import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/landing/presentation/widgets/landing_features_section.dart';
import 'package:newsllm/features/landing/presentation/widgets/landing_footer.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFF), Color(0xFFF1F5FF), Color(0xFFF8FAFC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 48,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(context, isMobile),
                      SizedBox(height: isMobile ? 64 : 96),
                      isMobile
                          ? Column(
                              children: [
                                _buildHeroText(context, true),
                                const SizedBox(height: 48),
                                _buildDashboardPreview(),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: _buildHeroText(context, false)),
                                const SizedBox(width: 64),
                                Expanded(child: _buildDashboardPreview()),
                              ],
                            ),
                      const SizedBox(height: 72),
                      _buildStatistics(),
                      const SizedBox(height: 120),
                      const LandingFeaturesSection(),
                      const SizedBox(height: 120),
                      const LandingFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.darkNavy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Text(
          'NewsLLM',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        if (!isMobile) ...[
          TextButton(onPressed: () {}, child: const Text('How it works')),
          const SizedBox(width: 8),
          TextButton(onPressed: () {}, child: const Text('Sign in')),
          const SizedBox(width: 12),
        ],
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          child: Text(isMobile ? 'Start' : 'Get started'),
        ),
      ],
    );
  }

  Widget _buildHeroText(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0EAFF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'BUILT FOR COMPETITIVE EXAMS',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'News that helps you '),
              TextSpan(
                text: 'score better.',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.darkNavy,
            fontSize: isMobile ? 42 : 60,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Turn daily news into concise summaries, important one-line facts, '
          'and exam-focused MCQ practice in Bangla and English.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 18,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 14,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Start learning free'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
              ),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('See how it works'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.accent, size: 18),
            SizedBox(width: 8),
            Text(
              'Daily summaries • Smart quizzes • Progress tracking',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardPreview() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A2563EB),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE0EAFF),
                child: Icon(
                  Icons.waving_hand,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Angkan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Your daily briefing is ready',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.notifications_none, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Today’s top stories',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _buildNewsItem(
            icon: Icons.account_balance_outlined,
            category: 'NATIONAL',
            title: 'Bangladesh announces a new green growth roadmap',
            color: const Color(0xFFDCFCE7),
          ),
          const SizedBox(height: 12),
          _buildNewsItem(
            icon: Icons.public,
            category: 'INTERNATIONAL',
            title: 'World leaders agree on an ocean protection framework',
            color: const Color(0xFFE0E7FF),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkNavy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.quiz_outlined, color: Color(0xFF6EE7B7)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '5 questions • About 3 minutes',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem({
    required IconData icon,
    required String category,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.darkNavy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 40,
      runSpacing: 18,
      children: const [
        _Statistic(value: '5 min', label: 'Daily learning'),
        _Statistic(value: '2 languages', label: 'Bangla and English'),
        _Statistic(value: '4 formats', label: 'Learn, revise and test'),
      ],
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.darkNavy,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
