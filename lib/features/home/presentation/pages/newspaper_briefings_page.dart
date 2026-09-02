import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';

class NewspaperBriefingsPage extends StatelessWidget {
  const NewspaperBriefingsPage({
    super.key,
    required this.newspaperName,
    required this.shortName,
    required this.language,
    required this.color,
  });

  final String newspaperName;
  final String shortName;
  final String language;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final briefings = [
      const _Briefing(
        category: 'NATIONAL',
        title: 'Bangladesh introduces a new national development roadmap',
        summary:
            'The initiative focuses on sustainable growth, employment and long-term economic development.',
        readingTime: '4 min read',
      ),
      const _Briefing(
        category: 'INTERNATIONAL',
        title: 'Regional leaders discuss stronger economic cooperation',
        summary:
            'The meeting highlighted trade, technology and cross-border collaboration.',
        readingTime: '3 min read',
      ),
      const _Briefing(
        category: 'BUSINESS',
        title: 'Digital payment services continue to expand',
        summary:
            'New services aim to make everyday transactions faster, safer and more accessible.',
        readingTime: '3 min read',
      ),
      const _Briefing(
        category: 'SCIENCE & TECH',
        title: 'Satellite data improves national disaster monitoring',
        summary:
            'Updated technology will help authorities issue faster and more accurate warnings.',
        readingTime: '4 min read',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          newspaperName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNewspaperHeader(context),
                const SizedBox(height: 38),
                Text(
                  'Today’s briefings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.darkNavy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${briefings.length} exam-focused stories selected from $newspaperName.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 22),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 850 ? 2 : 1;
                    final spacing = 18.0;
                    final cardWidth =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: briefings.map((briefing) {
                        return SizedBox(
                          width: cardWidth,
                          child: _BriefingCard(
                            briefing: briefing,
                            newspaperName: newspaperName,
                            color: color,
                          ),
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

  Widget _buildNewspaperHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              shortName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newspaperName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkNavy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$language newspaper • Reviewed today',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BriefingCard extends StatelessWidget {
  const _BriefingCard({
    required this.briefing,
    required this.newspaperName,
    required this.color,
  });

  final _Briefing briefing;
  final String newspaperName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(
                newspaperName: newspaperName,
                category: briefing.category,
                title: briefing.title,
                summary: briefing.summary,
                readingTime: briefing.readingTime,
                accentColor: color,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                briefing.category,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                briefing.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                briefing.summary,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    briefing.readingTime,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Read briefing',
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Briefing {
  const _Briefing({
    required this.category,
    required this.title,
    required this.summary,
    required this.readingTime,
  });

  final String category;
  final String title;
  final String summary;
  final String readingTime;
}
