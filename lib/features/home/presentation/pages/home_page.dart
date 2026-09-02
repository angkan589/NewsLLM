import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/widgets/home_content_sections.dart';
import 'package:newsllm/features/home/presentation/widgets/newspaper_sources_section.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 20 : 48,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, isCompact),
                    const SizedBox(height: 44),
                    _buildBriefingHeader(context, isCompact),
                    const SizedBox(height: 36),
                    const NewspaperSourcesSection(),
                    const SizedBox(height: 48),
                    if (isCompact)
                      Column(
                        children: [
                          _buildLeadStory(context),
                          const SizedBox(height: 20),
                          _buildStudyPanel(context),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildLeadStory(context)),
                          const SizedBox(width: 24),
                          Expanded(child: _buildStudyPanel(context)),
                        ],
                      ),
                    const SizedBox(height: 72),
                    const HomeContentSections(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isCompact) {
    return Row(
      children: [
        SizedBox(
          width: isCompact ? 155 : 230,
          height: 62,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        if (!isCompact) ...[
          const SizedBox(width: 48),
          _navButton('Today', true),
          _navButton('National', false),
          _navButton('International', false),
          _navButton('Business', false),
          _navButton('Science & Tech', false),
        ],
        const Spacer(),
        if (!isCompact) ...[
          IconButton(
            onPressed: () {},
            tooltip: 'Search',
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDF5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              _LanguageOption(label: 'EN', selected: true),
              _LanguageOption(label: 'বা', selected: false),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () {}, child: const Text('Sign in')),
      ],
    );
  }

  Widget _navButton(String label, bool selected) {
    return TextButton(
      onPressed: () {},
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBriefingHeader(BuildContext context, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8),
            Text(
              'THURSDAY, 20 AUGUST 2026',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Good morning. Here’s what matters today.',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.darkNavy,
            fontSize: isCompact ? 34 : 46,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Your exam-focused daily briefing, prepared in about five minutes.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadStory(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF153E75), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            ),
            child: Stack(
              children: [
                const Positioned(
                  right: 30,
                  bottom: 24,
                  child: Icon(
                    Icons.account_balance_outlined,
                    color: Color(0x55FFFFFF),
                    size: 150,
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 22,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'LEAD STORY • NATIONAL',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bangladesh introduces a national green growth roadmap',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.darkNavy,
                    fontSize: 25,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The roadmap prioritises renewable energy, sustainable jobs, '
                  'and climate-resilient infrastructure across the country.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      '4 min read',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ArticleDetailPage(
                              newspaperName: 'The Daily Star',
                              category: 'NATIONAL',
                              title:
                                  'Bangladesh launches ambitious green development roadmap',
                              summary:
                                  'The roadmap prioritises renewable energy, sustainable jobs, '
                                  'and climate-resilient infrastructure across the country.',
                              readingTime: '4 min read',
                              accentColor: AppColors.primary,
                            ),
                          ),
                        );
                      },
                      label: const Text('Read briefing'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyPanel(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt, color: Color(0xFFD97706)),
                  SizedBox(width: 9),
                  Text(
                    'Quick revision',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _factRow('WHO', 'Ministry of Environment'),
              const Divider(height: 24),
              _factRow('WHAT', 'Green Growth Roadmap'),
              const Divider(height: 24),
              _factRow('WHY', 'Climate-resilient economy'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkNavy,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.quiz_outlined,
                color: Color(0xFF6EE7B7),
                size: 30,
              ),
              const SizedBox(height: 18),
              const Text(
                'Ready for today’s quiz?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '5 questions based on today’s important news.',
                style: TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6EE7B7),
                  foregroundColor: AppColors.darkNavy,
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start daily quiz'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _factRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
