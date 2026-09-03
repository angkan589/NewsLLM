import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/core/theme/theme_context.dart';
import 'package:newsllm/features/auth/presentation/pages/auth_page.dart';
import 'package:newsllm/features/fact_bank/presentation/pages/fact_bank_page.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/home/presentation/pages/category_news_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';
import 'package:newsllm/features/progress/presentation/pages/exam_history_page.dart';
import 'package:newsllm/features/quiz/presentation/pages/quiz_hub_page.dart';

class HomeContentSections extends StatelessWidget {
  const HomeContentSections({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final articles = MockNewsRepository.articles;
        final isCompact = constraints.maxWidth < 850;
        final newsCardWidth = isCompact
            ? constraints.maxWidth
            : (constraints.maxWidth - 40) / 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(context),
            SizedBox(height: 64),
            _buildSectionHeader(
              context,
              title: 'More from today',
              subtitle: 'Short, exam-focused briefings selected for you',
              action: 'View all news',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryNewsPage(category: 'Today'),
                  ),
                );
              },
            ),
            SizedBox(height: 22),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: articles.map((article) {
                return _NewsCard(
                  width: newsCardWidth,
                  article: article,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailPage(article: article),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 72),
            _buildFactBank(context, isCompact),
            SizedBox(height: 72),
            _buildSectionHeader(
              context,
              title: 'Keep your preparation moving',
              subtitle: 'Continue learning and understand your weekly progress',
              action: 'View progress',
              onAction: () {
                if (!AppSession.instance.isSignedIn) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => AuthPage()));
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ExamHistoryPage()),
                );
              },
            ),
            SizedBox(height: 22),
            if (isCompact)
              Column(
                children: [
                  _buildContinueLearning(context),
                  SizedBox(height: 20),
                  _buildProgressCard(context),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildContinueLearning(context)),
                  SizedBox(width: 20),
                  Expanded(child: _buildProgressCard(context)),
                ],
              ),
            SizedBox(height: 72),
            _buildLanguageBanner(context, isCompact),
            SizedBox(height: 72),
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
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryNewsPage(category: 'Today'),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((category) {
            return Material(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  final destinationCategory = switch (category.label) {
                    'Science' || 'Technology' => 'Science & Tech',
                    _ => category.label,
                  };

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryNewsPage(category: destinationCategory),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderColor),
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
                      SizedBox(width: 10),
                      Text(
                        category.label,
                        style: TextStyle(
                          color: context.primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFactBank(BuildContext context, bool isCompact) {
    const facts = [
      _FactData(
        number: '01',
        text:
            'Bangladesh’s green roadmap prioritises renewable energy and sustainable employment.',
      ),
      _FactData(
        number: '02',
        text:
            'The new ocean framework focuses on biodiversity beyond national waters.',
      ),
      _FactData(
        number: '03',
        text:
            'Satellite-based flood alerts will support more localised warnings.',
      ),
      _FactData(
        number: '04',
        text:
            'Digital trade systems reduce paperwork for regional transactions.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 24 : 34),
      decoration: BoxDecoration(
        color: context.yellowTintColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.isDarkTheme ? Color(0xFF66501D) : Color(0xFFFDE68A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.isDarkTheme
                          ? Color(0xFF4A3714)
                          : Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.bolt, color: Color(0xFFD97706)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Today’s one-line fact bank',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context.primaryTextColor,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FactBankPage()),
                  );
                },
                child: Text('Open fact bank'),
              ),
            ],
          ),
          SizedBox(height: 24),
          ...facts.map(
            (fact) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fact.number,
                    style: TextStyle(
                      color: Color(0xFFD97706),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      fact.text,
                      style: TextStyle(
                        color: context.primaryTextColor,
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
          Row(
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
          Spacer(),
          Text(
            'Continue yesterday’s International Affairs revision',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 24,
              height: 1.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You completed 6 of 10 facts.',
            style: TextStyle(color: Color(0xFFCBD5E1)),
          ),
          SizedBox(height: 18),
          LinearProgressIndicator(
            value: 0.6,
            minHeight: 7,
            backgroundColor: Color(0xFF334155),
            color: Color(0xFF6EE7B7),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => QuizHubPage()));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.darkNavy,
            ),
            icon: Icon(Icons.play_arrow),
            label: Text('Continue learning'),
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
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly accuracy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: context.primaryTextColor,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '84%',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Up 8% from last week',
            style: TextStyle(color: context.secondaryTextColor, fontSize: 13),
          ),
          Spacer(),
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
                            : context.isDarkTheme
                            ? Color(0xFF315276)
                            : Color(0xFFBFDBFE),
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
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _chartLabel(context, 'Mon'),
              _chartLabel(context, 'Tue'),
              _chartLabel(context, 'Wed'),
              _chartLabel(context, 'Thu'),
              _chartLabel(context, 'Fri'),
              _chartLabel(context, 'Sat'),
              _chartLabel(context, 'Sun'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(color: context.secondaryTextColor, fontSize: 10),
    );
  }

  Widget _buildLanguageBanner(BuildContext context, bool isCompact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 26 : 40),
      decoration: BoxDecoration(
        color: context.blueTintColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
      ),
      child: isCompact
          ? Column(
              children: [
                _buildLanguageText(context, true),
                SizedBox(height: 24),
                _buildLanguageButtons(context),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildLanguageText(context, false)),
                SizedBox(width: 40),
                _buildLanguageButtons(context),
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
            color: context.primaryTextColor,
            fontSize: 26,
          ),
        ),
        SizedBox(height: 9),
        Text(
          'Switch between Bangla and English summaries whenever you need.',
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: TextStyle(color: context.secondaryTextColor, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLanguageButtons(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, child) {
        final session = AppSession.instance;

        return SegmentedButton<String>(
          segments: [
            ButtonSegment<String>(value: 'English', label: Text('English')),
            ButtonSegment<String>(value: 'বাংলা', label: Text('বাংলা')),
          ],
          selected: {session.preferredLanguage},
          onSelectionChanged: (selection) {
            session.updatePreferredLanguage(selection.first);
          },
          showSelectedIcon: false,
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isCompact) {
    final description = Text(
      'Daily news. Important facts. Better preparation.',
      textAlign: isCompact ? TextAlign.center : TextAlign.left,
      style: TextStyle(color: context.secondaryTextColor),
    );

    final copyright = Text(
      '© 2026 NewsLLM',
      style: TextStyle(color: context.secondaryTextColor, fontSize: 12),
    );

    return Column(
      children: [
        Divider(color: context.borderColor),
        SizedBox(height: 24),
        if (isCompact)
          Column(
            children: [
              _FooterBrand(),
              SizedBox(height: 18),
              description,
              SizedBox(height: 18),
              copyright,
            ],
          )
        else
          Row(
            children: [
              _FooterBrand(),
              SizedBox(width: 22),
              description,
              Spacer(),
              Text(
                'About   Privacy   Contact',
                style: TextStyle(color: context.secondaryTextColor),
              ),
              SizedBox(width: 30),
              copyright,
            ],
          ),
        SizedBox(height: 28),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String action,
    VoidCallback? onAction,
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
                  color: context.primaryTextColor,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: context.secondaryTextColor),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        TextButton(onPressed: onAction, child: Text(action)),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.width,
    required this.article,
    required this.onTap,
  });

  final double width;
  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: context.surfaceColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.borderColor),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 125,
                width: double.infinity,
                color: article.accentColor.withValues(alpha: 0.12),
                child: Icon(
                  _categoryIcon(article.category),
                  color: article.accentColor,
                  size: 52,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category,
                      style: TextStyle(
                        color: article.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      article.title,
                      style: TextStyle(
                        color: context.primaryTextColor,
                        fontSize: 17,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      article.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.secondaryTextColor,
                        height: 1.45,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: context.secondaryTextColor,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          article.readingTime,
                          style: TextStyle(
                            color: context.secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: article.accentColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'NATIONAL':
        return Icons.account_balance_outlined;
      case 'INTERNATIONAL':
        return Icons.public_rounded;
      case 'BUSINESS':
        return Icons.trending_up_rounded;
      case 'SCIENCE & TECH':
        return Icons.memory_rounded;
      case 'SPORTS':
        return Icons.sports_cricket_rounded;
      default:
        return Icons.article_outlined;
    }
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
