import 'package:flutter/material.dart' hide Text;
import 'package:newsllm/core/localization/localized_text.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/widgets/home_content_sections.dart';
import 'package:newsllm/features/home/presentation/widgets/newspaper_sources_section.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/firestore_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';
import 'package:newsllm/features/quiz/presentation/pages/daily_quiz_page.dart';
import 'package:newsllm/features/home/presentation/pages/category_news_page.dart';
import 'package:newsllm/features/auth/presentation/pages/auth_page.dart';
import 'package:newsllm/features/search/presentation/pages/search_page.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/features/profile/presentation/pages/profile_page.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/theme/theme_context.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 900;
    final leadArticle = FirestoreNewsRepository.articles.first;

    return Scaffold(
      backgroundColor: context.pageBackground,
      bottomNavigationBar: MainNavigationBar(
        currentDestination: MainDestination.home,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 20 : 48,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, isCompact),
                    SizedBox(height: 44),
                    _buildBriefingHeader(context, isCompact),
                    SizedBox(height: 36),
                    NewspaperSourcesSection(),
                    SizedBox(height: 48),
                    if (isCompact)
                      Column(
                        children: [
                          _buildLeadStory(context, leadArticle),
                          SizedBox(height: 20),
                          _buildStudyPanel(context, leadArticle),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildLeadStory(context, leadArticle),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: _buildStudyPanel(context, leadArticle),
                          ),
                        ],
                      ),
                    SizedBox(height: 72),
                    HomeContentSections(),
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
          width: isCompact ? 105 : 230,
          height: 62,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        if (!isCompact) ...[
          SizedBox(width: 48),
          _navButton(context, 'Today', true),
          _navButton(context, 'National', false),
          _navButton(context, 'International', false),
          _navButton(context, 'Business', false),
          _navButton(context, 'Science & Tech', false),
        ],
        Spacer(),
        if (!isCompact) ...[
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
            tooltip: localizedUi('Search'),
            icon: Icon(Icons.search),
          ),
          SizedBox(width: 8),
        ],
        AnimatedBuilder(
          animation: AppSession.instance,
          builder: (context, child) {
            final session = AppSession.instance;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _LanguageOption(
                        label: 'EN',
                        selected: session.preferredLanguage == 'English',
                        onTap: () {
                          session.updatePreferredLanguage('English');
                        },
                      ),
                      _LanguageOption(
                        label: 'বা',
                        selected: session.preferredLanguage == 'বাংলা',
                        onTap: () {
                          session.updatePreferredLanguage('বাংলা');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  tooltip: localizedUi(
                    session.isDarkMode ? 'Use light theme' : 'Use dark theme',
                  ),
                  onPressed: () {
                    session.toggleTheme();
                  },
                  icon: Icon(
                    session.isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(width: 12),
        AnimatedBuilder(
          animation: AppSession.instance,
          builder: (context, child) {
            final session = AppSession.instance;

            if (session.isSignedIn) {
              return OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                icon: Icon(Icons.person_outline_rounded),
                label: Text(session.name),
              );
            }

            return OutlinedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AuthPage()));
              },
              child: Text('Sign in'),
            );
          },
        ),
      ],
    );
  }

  Widget _navButton(BuildContext context, String label, bool selected) {
    return TextButton(
      onPressed: selected
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoryNewsPage(category: label),
                ),
              );
            },
      child: Text(
        label,
        style: TextStyle(
          color: selected
              ? AppColors.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBriefingHeader(BuildContext context, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8),
            Text(
              localizedToday(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Text(
          'Good morning. Here’s what matters today.',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: context.primaryTextColor,
            fontSize: isCompact ? 34 : 46,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Your exam-focused daily briefing, prepared in about five minutes.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadStory(BuildContext context, NewsArticle article) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [article.accentColor, AppColors.darkNavy],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 30,
                  bottom: 24,
                  child: Icon(
                    _categoryIcon(article.category),
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
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'LEAD STORY • ${article.category}',
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
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 25,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  article.summary,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 17,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 7),
                    Text(
                      article.readingTime,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailPage(article: article),
                          ),
                        );
                      },
                      label: Text('Read briefing'),
                      icon: Icon(Icons.arrow_forward, size: 18),
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

  Widget _buildStudyPanel(BuildContext context, NewsArticle article) {
    final quickFacts = article.facts.take(3).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bolt, color: Color(0xFFD97706)),
                  SizedBox(width: 9),
                  Text(
                    'Quick revision',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              ...List.generate(quickFacts.length, (index) {
                final fact = quickFacts[index];

                return Column(
                  children: [
                    if (index > 0) Divider(height: 24),
                    _factRow(context, fact.label, fact.value),
                  ],
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 20),
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
              Icon(Icons.quiz_outlined, color: Color(0xFF6EE7B7), size: 30),
              SizedBox(height: 18),
              Text(
                'Ready for today’s quiz?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '5 questions based on today’s important news.',
                style: TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
              ),
              SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DailyQuizPage()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF6EE7B7),
                  foregroundColor: AppColors.darkNavy,
                ),
                icon: Icon(Icons.play_arrow),
                label: Text('Start daily quiz'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _factRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: TextStyle(
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category.toUpperCase()) {
      'NATIONAL' => Icons.account_balance_outlined,
      'INTERNATIONAL' => Icons.public_rounded,
      'BUSINESS' => Icons.trending_up_rounded,
      'SPORTS' => Icons.sports_cricket_rounded,
      'SCIENCE' || 'SCIENCE & TECH' => Icons.science_outlined,
      'TECHNOLOGY' => Icons.memory_rounded,
      _ => Icons.article_outlined,
    };
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.surface
          : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
