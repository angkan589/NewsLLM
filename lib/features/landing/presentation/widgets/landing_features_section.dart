import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class LandingFeaturesSection extends StatelessWidget {
  const LandingFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final cardWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - 20) / 2;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF12352D)
                    : Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'EVERYTHING YOU NEED',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'A smarter way to prepare current affairs',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: isMobile ? 32 : 42,
                height: 1.15,
              ),
            ),
            SizedBox(height: 14),
            Text(
              'Move from reading to remembering with a focused learning flow.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _FeatureCard(
                  width: cardWidth,
                  icon: Icons.summarize_outlined,
                  iconColor: AppColors.primary,
                  iconBackground: Color(0xFFE0EAFF),
                  title: 'Exam-focused summaries',
                  description:
                      'Read the important parts of daily news without going '
                      'through long and distracting articles.',
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: Icons.bolt_outlined,
                  iconColor: Color(0xFFD97706),
                  iconBackground: Color(0xFFFEF3C7),
                  title: 'One-line facts',
                  description:
                      'Quickly revise the who, what, when, and where from every '
                      'important current-affairs story.',
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: Icons.quiz_outlined,
                  iconColor: Color(0xFF7C3AED),
                  iconBackground: Color(0xFFEDE9FE),
                  title: 'Smart MCQ practice',
                  description:
                      'Test yourself with AI-generated questions based directly '
                      'on the news you studied.',
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: Icons.bar_chart_outlined,
                  iconColor: Color(0xFF059669),
                  iconBackground: Color(0xFFD1FAE5),
                  title: 'Learning progress',
                  description:
                      'Track quiz scores, accuracy, study streaks, and the '
                      'topics that need more attention.',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.width,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.description,
  });

  final double width;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
