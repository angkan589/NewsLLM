import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';

class FactBankPage extends StatefulWidget {
  const FactBankPage({super.key});

  @override
  State<FactBankPage> createState() => _FactBankPageState();
}

class _FactBankPageState extends State<FactBankPage> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = MockNewsRepository.articles
        .map((article) => article.category)
        .toSet()
        .toList();

    return ['All', ...categories];
  }

  List<NewsArticle> get _articles {
    if (_selectedCategory == 'All') {
      return MockNewsRepository.articles;
    }

    return MockNewsRepository.articlesByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Fact bank',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCategoryFilters(),
                const SizedBox(height: 24),
                ..._articles.map(_buildArticleFacts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final factCount = _articles.fold<int>(
      0,
      (total, article) => total + article.facts.length,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD97706), AppColors.darkNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFFFDE68A),
              size: 32,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today’s one-line facts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '$factCount quick revision facts from current briefings',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final selected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArticleFacts(NewsArticle article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 7,
                crossAxisAlignment: WrapCrossAlignment.center,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              ...article.facts.asMap().entries.map((entry) {
                final number = entry.key + 1;
                final fact = entry.value;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 33,
                        height: 33,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            color: Color(0xFFD97706),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      SizedBox(
                        width: 58,
                        child: Text(
                          fact.label,
                          style: TextStyle(
                            color: article.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          fact.value,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 17),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailPage(article: article),
                      ),
                    );
                  },
                  icon: const Icon(Icons.article_outlined, size: 18),
                  label: const Text('Read full briefing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
