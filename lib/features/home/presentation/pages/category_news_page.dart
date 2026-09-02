import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';

class CategoryNewsPage extends StatelessWidget {
  const CategoryNewsPage({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final articles = _articlesForCategory(category);

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
          category,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, articles.length),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 800 ? 2 : 1;
                    const spacing = 18.0;
                    final cardWidth =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: articles.map((article) {
                        return SizedBox(
                          width: cardWidth,
                          child: _ArticleCard(article: article),
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

  Widget _buildHeader(BuildContext context, int articleCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.darkNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.newspaper_rounded, color: Colors.white, size: 34),
          const SizedBox(height: 20),
          Text(
            '$category news',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '$articleCount exam-focused briefings selected for today.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  List<_CategoryArticle> _articlesForCategory(String selectedCategory) {
    switch (selectedCategory) {
      case 'National':
        return const [
          _CategoryArticle(
            newspaperName: 'The Daily Star',
            category: 'NATIONAL',
            title: 'Bangladesh introduces a national green growth roadmap',
            summary:
                'The roadmap prioritises renewable energy, sustainable jobs and climate-resilient infrastructure.',
            readingTime: '4 min read',
            accentColor: AppColors.primary,
          ),
          _CategoryArticle(
            newspaperName: 'Prothom Alo',
            category: 'NATIONAL',
            title: 'New education programme targets digital learning',
            summary:
                'The programme aims to improve access to digital resources and modern classroom tools.',
            readingTime: '3 min read',
            accentColor: Color(0xFF059669),
          ),
          _CategoryArticle(
            newspaperName: 'Dhaka Tribune',
            category: 'NATIONAL',
            title: 'Public transport improvement plan announced',
            summary:
                'The new plan focuses on safer journeys, better routes and reduced urban congestion.',
            readingTime: '4 min read',
            accentColor: Color(0xFF7C3AED),
          ),
          _CategoryArticle(
            newspaperName: 'The Business Standard',
            category: 'NATIONAL',
            title: 'Local development projects receive new funding',
            summary:
                'The projects will support infrastructure and essential public services across several districts.',
            readingTime: '3 min read',
            accentColor: Color(0xFFD97706),
          ),
        ];

      case 'International':
        return const [
          _CategoryArticle(
            newspaperName: 'BBC News',
            category: 'INTERNATIONAL',
            title: 'Regional leaders discuss stronger economic cooperation',
            summary:
                'The meeting highlighted trade, technology and cross-border collaboration.',
            readingTime: '4 min read',
            accentColor: Color(0xFFDC2626),
          ),
          _CategoryArticle(
            newspaperName: 'Reuters',
            category: 'INTERNATIONAL',
            title: 'Countries agree to expand climate partnerships',
            summary:
                'The agreement supports renewable energy investment and shared environmental research.',
            readingTime: '3 min read',
            accentColor: AppColors.primary,
          ),
          _CategoryArticle(
            newspaperName: 'Al Jazeera',
            category: 'INTERNATIONAL',
            title: 'Global food-security discussions continue',
            summary:
                'Officials examined agricultural production, supply chains and rising food costs.',
            readingTime: '4 min read',
            accentColor: Color(0xFFB45309),
          ),
          _CategoryArticle(
            newspaperName: 'The Guardian',
            category: 'INTERNATIONAL',
            title: 'New international education initiative launched',
            summary:
                'The initiative will expand scholarships and academic cooperation between participating countries.',
            readingTime: '3 min read',
            accentColor: Color(0xFF059669),
          ),
        ];

      case 'Business':
        return const [
          _CategoryArticle(
            newspaperName: 'The Business Standard',
            category: 'BUSINESS',
            title: 'Digital payment services continue to expand',
            summary:
                'New services aim to make everyday transactions faster, safer and more accessible.',
            readingTime: '3 min read',
            accentColor: Color(0xFFD97706),
          ),
          _CategoryArticle(
            newspaperName: 'Financial Express',
            category: 'BUSINESS',
            title: 'Small businesses increase their use of technology',
            summary:
                'Digital tools are helping businesses manage sales, customers and financial records.',
            readingTime: '4 min read',
            accentColor: AppColors.primary,
          ),
          _CategoryArticle(
            newspaperName: 'Dhaka Tribune',
            category: 'BUSINESS',
            title: 'Export sector explores new international markets',
            summary:
                'Industry leaders are working to diversify products and strengthen trade relationships.',
            readingTime: '3 min read',
            accentColor: Color(0xFF7C3AED),
          ),
          _CategoryArticle(
            newspaperName: 'The Daily Star',
            category: 'BUSINESS',
            title: 'Green investment gains attention from local companies',
            summary:
                'Businesses are considering cleaner technology and more sustainable production methods.',
            readingTime: '4 min read',
            accentColor: Color(0xFF059669),
          ),
        ];

      default:
        return const [
          _CategoryArticle(
            newspaperName: 'The Daily Star',
            category: 'SCIENCE & TECH',
            title: 'Satellite data improves national disaster monitoring',
            summary:
                'Updated technology will help authorities issue faster and more accurate warnings.',
            readingTime: '4 min read',
            accentColor: AppColors.primary,
          ),
          _CategoryArticle(
            newspaperName: 'BBC Science',
            category: 'SCIENCE & TECH',
            title: 'Researchers develop more efficient solar technology',
            summary:
                'The research could improve renewable-energy production while reducing costs.',
            readingTime: '4 min read',
            accentColor: Color(0xFF059669),
          ),
          _CategoryArticle(
            newspaperName: 'Reuters Technology',
            category: 'SCIENCE & TECH',
            title: 'Artificial intelligence supports medical research',
            summary:
                'New tools are helping researchers examine complex medical information more efficiently.',
            readingTime: '3 min read',
            accentColor: Color(0xFF7C3AED),
          ),
          _CategoryArticle(
            newspaperName: 'Dhaka Tribune',
            category: 'SCIENCE & TECH',
            title: 'Digital public services reach more communities',
            summary:
                'Expanded online platforms are improving access to important government information.',
            readingTime: '3 min read',
            accentColor: Color(0xFFD97706),
          ),
        ];
    }
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final _CategoryArticle article;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(
                newspaperName: article.newspaperName,
                category: article.category,
                title: article.title,
                summary: article.summary,
                readingTime: article.readingTime,
                accentColor: article.accentColor,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: article.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      article.newspaperName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Text(
                article.category,
                style: TextStyle(
                  color: article.accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.summary,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.textSecondary,
                    size: 17,
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 5),
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

class _CategoryArticle {
  const _CategoryArticle({
    required this.newspaperName,
    required this.category,
    required this.title,
    required this.summary,
    required this.readingTime,
    required this.accentColor,
  });

  final String newspaperName;
  final String category;
  final String title;
  final String summary;
  final String readingTime;
  final Color accentColor;
}
