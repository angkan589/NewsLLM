import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class HomeContentSections extends StatelessWidget {
  const HomeContentSections({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 850;
        final newsCardWidth = isCompact
            ? constraints.maxWidth
            : (constraints.maxWidth - 40) / 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(context),
            const SizedBox(height: 64),
            _buildSectionHeader(
              context,
              title: 'More from today',
              subtitle: 'Short, exam-focused briefings selected for you',
              action: 'View all news',
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _NewsCard(
                  width: newsCardWidth,
                  icon: Icons.public,
                  category: 'INTERNATIONAL',
                  title:
                      'Global leaders approve a new ocean protection framework',
                  summary:
                      'The agreement focuses on marine biodiversity and reducing plastic pollution.',
                  readingTime: '3 min read',
                  color: const Color(0xFFE0E7FF),
                ),
                _NewsCard(
                  width: newsCardWidth,
                  icon: Icons.trending_up,
                  category: 'BUSINESS',
                  title:
                      'Regional trade cooperation receives a new digital boost',
                  summary:
                      'A shared platform aims to simplify cross-border documentation and payments.',
                  readingTime: '4 min read',
                  color: const Color(0xFFFEF3C7),
                ),
                _NewsCard(
                  width: newsCardWidth,
                  icon: Icons.rocket_launch_outlined,
                  category: 'SCIENCE & TECH',
                  title:
                      'Satellite data expands Bangladesh flood-warning coverage',
                  summary:
                      'Improved local data will help authorities issue more targeted monsoon alerts.',
                  readingTime: '3 min read',
                  color: const Color(0xFFD1FAE5),
                ),
              ],
            ),
            const SizedBox(height: 72),
            _buildFactBank(context, isCompact),
            const SizedBox(height: 72),
            _buildSectionHeader(
              context,
              title: 'Keep your preparation moving',
              subtitle: 'Continue learning and understand your weekly progress',
              action: 'View progress',
            ),
            const SizedBox(height: 22),
            if (isCompact)
              Column(
                children: [
                  _buildContinueLearning(context),
                  const SizedBox(height: 20),
                  _buildProgressCard(context),
                ],
              )
            else
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildContinueLearning(context)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildProgressCard(context)),
                ],
              ),
            const SizedBox(height: 72),
            _buildLanguageBanner(context, isCompact),
            const SizedBox(height: 72),
            _buildFooter(context, isCompact),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    const categories = [
      _CategoryData(
        label: 'National',
        icon: Icons.account_balance_outlined,
        color: Color(0xFFE0EAFF),
      ),
      _CategoryData(
        label: 'International',
        icon: Icons.public,
        color: Color(0xFFEDE9FE),
      ),
      _CategoryData(
        label: 'Business',
        icon: Icons.show_chart,
        color: Color(0xFFFEF3C7),
      ),
      _CategoryData(
        label: 'Sports',
        icon: Icons.sports_cricket,
        color: Color(0xFFFFE4E6),
      ),
      _CategoryData(
        label: 'Science',
        icon: Icons.science_outlined,
        color: Color(0xFFD1FAE5),
      ),
      _CategoryData(
        label: 'Technology',
        icon: Icons.memory,
        color: Color(0xFFDBEAFE),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Explore by topic',
          subtitle: 'Choose the current-affairs area you want to study',
          action: 'All topics',
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((category) {
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        category.icon,
                        size: 18,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      category.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFactBank(BuildContext context, bool isCompact) {
    final facts = [
      const _FactData(
        number: '01',
        text:
            'Bangladesh’s green roadmap prioritises renewable energy and sustainable employment.',
      ),
      const _FactData(
        number: '02',
        text:
            'The new ocean framework focuses on biodiversity beyond national waters.',
      ),
      const _FactData(
        number: '03',
        text:
            'Satellite-based flood alerts will support more localised warnings.',
      ),
      const _FactData(
        number: '04',
        text:
            'Digital trade systems reduce paperwork for regional transactions.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 24 : 34),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bolt, color: Color(0xFFD97706)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today’s one-line fact bank',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
              ),
              if (!isCompact)
                TextButton(
                  onPressed: () {},
                  child: const Text('Open fact bank'),
                ),
            ],
          ),
          const SizedBox(height: 24),
          ...facts.map(
            (fact) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fact.number,
                    style: const TextStyle(
                      color: Color(0xFFD97706),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      fact.text,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearning(BuildContext context) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department, color: Color(0xFFFBBF24)),
              SizedBox(width: 8),
              Text(
                '7-DAY STUDY STREAK',
                style: TextStyle(
                  color: Color(0xFFFBBF24),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Continue yesterday’s International Affairs revision',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 24,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'You completed 6 of 10 facts.',
            style: TextStyle(color: Color(0xFFCBD5E1)),
          ),
          const SizedBox(height: 18),
          const LinearProgressIndicator(
            value: 0.6,
            minHeight: 7,
            backgroundColor: Color(0xFF334155),
            color: Color(0xFF6EE7B7),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.darkNavy,
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Continue learning'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    const values = [52.0, 76.0, 64.0, 88.0, 72.0, 96.0, 84.0];

    return Container(
      height: 310,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Weekly accuracy',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const Spacer(),
              const Text(
                '84%',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Up 8% from last week',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Spacer(),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.map((value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      height: value,
                      decoration: BoxDecoration(
                        color: value >= 80
                            ? AppColors.accent
                            : const Color(0xFFBFDBFE),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(7),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mon', style: _chartLabelStyle),
              Text('Tue', style: _chartLabelStyle),
              Text('Wed', style: _chartLabelStyle),
              Text('Thu', style: _chartLabelStyle),
              Text('Fri', style: _chartLabelStyle),
              Text('Sat', style: _chartLabelStyle),
              Text('Sun', style: _chartLabelStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBanner(BuildContext context, bool isCompact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 26 : 40),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: isCompact
          ? Column(
              children: [
                _buildLanguageText(context, true),
                const SizedBox(height: 24),
                _buildLanguageButtons(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildLanguageText(context, false)),
                const SizedBox(width: 40),
                _buildLanguageButtons(),
              ],
            ),
    );
  }

  Widget _buildLanguageText(BuildContext context, bool centered) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Learn in the language that feels natural',
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.darkNavy,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'Switch between Bangla and English summaries whenever you need.',
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLanguageButtons() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(onPressed: () {}, child: const Text('English')),
          TextButton(onPressed: () {}, child: const Text('বাংলা')),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isCompact) {
    return Column(
      children: [
        const Divider(color: AppColors.border),
        const SizedBox(height: 24),
        if (isCompact)
          const Column(
            children: [
              _FooterBrand(),
              SizedBox(height: 18),
              Text(
                'Daily news. Important facts. Better preparation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 18),
              Text(
                '© 2026 NewsLLM',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          )
        else
          const Row(
            children: [
              _FooterBrand(),
              SizedBox(width: 22),
              Text(
                'Daily news. Important facts. Better preparation.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Spacer(),
              Text(
                'About   Privacy   Contact',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(width: 30),
              Text(
                '© 2026 NewsLLM',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkNavy,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.width,
    required this.icon,
    required this.category,
    required this.title,
    required this.summary,
    required this.readingTime,
    required this.color,
  });

  final double width;
  final IconData icon;
  final String category;
  final String title;
  final String summary;
  final String readingTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(19),
              ),
            ),
            child: Icon(icon, color: AppColors.darkNavy, size: 52),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  summary,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  readingTime,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 52,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class _FactData {
  const _FactData({required this.number, required this.text});

  final String number;
  final String text;
}

const TextStyle _chartLabelStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 10,
);
