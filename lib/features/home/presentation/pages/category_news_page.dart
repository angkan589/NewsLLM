import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';

class CategoryNewsPage extends StatelessWidget {
  const CategoryNewsPage({super.key, required this.category});

  final String category;

  List<NewsArticle> get _articles {
    if (category.toLowerCase() == 'today') {
      return MockNewsRepository.articles;
    }

    return MockNewsRepository.articlesByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final articles = _articles;

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
        title: Text(
          category == 'Today' ? 'Today’s briefings' : category,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(articles.length),
                const SizedBox(height: 24),
                if (articles.isEmpty)
                  _buildEmptyState()
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 760 ? 2 : 1;
                      final spacing = 16.0;
                      final cardWidth =
                          (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: articles.map((article) {
                          return SizedBox(
                            width: cardWidth,
                            child: _ArticleCard(
                              article: article,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ArticleDetailPage(article: article),
                                  ),
                                );
                              },
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

  Widget _buildHeader(int articleCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.darkNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_categoryIcon(category), color: Colors.white, size: 29),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == 'Today' ? 'Today’s news' : category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$articleCount exam-focused '
                  '${articleCount == 1 ? 'briefing' : 'briefings'} available',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No briefings available',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'New exam-focused stories will appear here when they are added.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String value) {
    switch (value.toUpperCase()) {
      case 'TODAY':
        return Icons.today_outlined;
      case 'NATIONAL':
        return Icons.account_balance_outlined;
      case 'INTERNATIONAL':
        return Icons.public_rounded;
      case 'BUSINESS':
        return Icons.trending_up_rounded;
      case 'SCIENCE & TECH':
        return Icons.memory_rounded;
      default:
        return Icons.article_outlined;
    }
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 245),
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 9,
                runSpacing: 6,
                children: [
                  Text(
                    article.category,
                    style: TextStyle(
                      color: article.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    article.newspaperName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                article.title,
                style: const TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    article.readingTime,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Read briefing',
                    style: TextStyle(
                      color: article.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
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
      ),
    );
  }
}
