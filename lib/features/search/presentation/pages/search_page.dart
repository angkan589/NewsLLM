import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<NewsArticle> get _results {
    return MockNewsRepository.search(_query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearch(String value) {
    setState(() {
      _query = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
    });
  }

  void _openArticle(NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

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
        title: const Text(
          'Search news',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(
        currentDestination: MainDestination.search,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBox(),
                const SizedBox(height: 25),
                Text(
                  _query.trim().isEmpty
                      ? 'All briefings'
                      : '${results.length} search result${results.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _query.trim().isEmpty
                      ? 'Search by headline, category, summary or newspaper.'
                      : 'Results matching “${_query.trim()}”',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                if (results.isEmpty)
                  _buildEmptyState()
                else
                  ...results.map(_buildArticleCard),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        onChanged: _updateSearch,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search news, category or newspaper',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close_rounded),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            _openArticle(article);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: article.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _categoryIcon(article.category),
                    color: article.accentColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
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
                      const SizedBox(height: 9),
                      Text(
                        article.title,
                        style: const TextStyle(
                          color: AppColors.darkNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            article.readingTime,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No briefings found',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try another headline, category or newspaper name.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: _clearSearch,
            child: const Text('Clear search'),
          ),
        ],
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
      default:
        return Icons.article_outlined;
    }
  }
}
