import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';

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

  List<NewsArticle> get _articles {
    return MockNewsRepository.articles.where((article) {
      return article.newspaperName.toLowerCase() == newspaperName.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final articles = _articles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          newspaperName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNewspaperHeader(articles.length),
                const SizedBox(height: 34),
                const Text(
                  'Today’s briefings',
                  style: TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  articles.isEmpty
                      ? 'No stories are available from $newspaperName yet.'
                      : '${articles.length} exam-focused '
                            '${articles.length == 1 ? 'story' : 'stories'} '
                            'selected from $newspaperName.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 22),
                if (articles.isEmpty)
                  _buildEmptyState(context)
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 800 ? 2 : 1;
                      final spacing = 18.0;
                      final cardWidth =
                          (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: articles.map((article) {
                          return SizedBox(
                            width: cardWidth,
                            child: _BriefingCard(
                              article: article,
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

  Widget _buildNewspaperHeader(int articleCount) {
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
                style: const TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$language newspaper • $articleCount '
                '${articleCount == 1 ? 'briefing' : 'briefings'} today',
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.newspaper_rounded, color: color, size: 47),
          const SizedBox(height: 16),
          const Text(
            'No briefings available',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New stories from $newspaperName will appear here when they are added.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('View other newspapers'),
          ),
        ],
      ),
    );
  }
}

class _BriefingCard extends StatelessWidget {
  const _BriefingCard({required this.article, required this.color});

  final NewsArticle article;
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
              builder: (context) => ArticleDetailPage(article: article),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 235),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.category,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
                    size: 17,
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
