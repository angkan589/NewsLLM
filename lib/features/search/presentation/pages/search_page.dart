import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  String _query = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'National',
    'International',
    'Business',
    'Science & Tech',
  ];

  final List<_SearchArticle> _articles = const [
    _SearchArticle(
      newspaperName: 'The Daily Star',
      category: 'National',
      title: 'Bangladesh introduces a national green growth roadmap',
      summary:
          'The roadmap prioritises renewable energy, sustainable jobs and climate-resilient infrastructure.',
      readingTime: '4 min read',
      accentColor: AppColors.primary,
    ),
    _SearchArticle(
      newspaperName: 'Prothom Alo',
      category: 'National',
      title: 'Digital learning programme reaches more students',
      summary:
          'New technology and learning resources are being introduced in classrooms.',
      readingTime: '3 min read',
      accentColor: Color(0xFF059669),
    ),
    _SearchArticle(
      newspaperName: 'BBC News',
      category: 'International',
      title: 'Regional leaders discuss stronger economic cooperation',
      summary:
          'The meeting highlighted trade, technology and cross-border collaboration.',
      readingTime: '4 min read',
      accentColor: Color(0xFFDC2626),
    ),
    _SearchArticle(
      newspaperName: 'Reuters',
      category: 'International',
      title: 'Countries expand international climate partnerships',
      summary:
          'The agreement supports renewable energy investment and environmental research.',
      readingTime: '3 min read',
      accentColor: AppColors.primary,
    ),
    _SearchArticle(
      newspaperName: 'The Business Standard',
      category: 'Business',
      title: 'Digital payment services continue to expand',
      summary:
          'New services aim to make transactions faster, safer and more accessible.',
      readingTime: '3 min read',
      accentColor: Color(0xFFD97706),
    ),
    _SearchArticle(
      newspaperName: 'Financial Express',
      category: 'Business',
      title: 'Small businesses increase their use of technology',
      summary:
          'Digital tools are helping businesses manage customers, sales and financial records.',
      readingTime: '4 min read',
      accentColor: Color(0xFF7C3AED),
    ),
    _SearchArticle(
      newspaperName: 'The Daily Star',
      category: 'Science & Tech',
      title: 'Satellite data improves national disaster monitoring',
      summary:
          'Updated technology will provide faster and more accurate disaster warnings.',
      readingTime: '4 min read',
      accentColor: AppColors.primary,
    ),
    _SearchArticle(
      newspaperName: 'BBC Science',
      category: 'Science & Tech',
      title: 'Researchers develop more efficient solar technology',
      summary:
          'The research could improve renewable-energy production while reducing costs.',
      readingTime: '4 min read',
      accentColor: Color(0xFF059669),
    ),
  ];

  List<_SearchArticle> get _filteredArticles {
    final normalizedQuery = _query.trim().toLowerCase();

    return _articles.where((article) {
      final matchesCategory = _selectedCategory == 'All' ||
          article.category == _selectedCategory;

      final matchesQuery = normalizedQuery.isEmpty ||
          article.title.toLowerCase().contains(normalizedQuery) ||
          article.summary.toLowerCase().contains(normalizedQuery) ||
          article.newspaperName.toLowerCase().contains(normalizedQuery) ||
          article.category.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
      _selectedCategory = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredArticles;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search stories, newspapers or topics...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  '${results.length} ${results.length == 1 ? 'result' : 'results'}',
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                if (results.isEmpty)
                  _buildEmptyState()
                else
                  ...results.map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildArticleCard(article),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(_SearchArticle article) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(
                newspaperName: article.newspaperName,
                category: article.category.toUpperCase(),
                title: article.title,
                summary: article.summary,
                readingTime: article.readingTime,
                accentColor: article.accentColor,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: article.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.article_outlined,
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
                          article.category.toUpperCase(),
                          style: TextStyle(
                            color: article.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                          ),
                        ),
                        Text(
                          article.newspaperName,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.readingTime,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.textSecondary,
            size: 52,
          ),
          const SizedBox(height: 16),
          const Text(
            'No stories found',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try another keyword or category.',
            style: TextStyle(color: AppColors.textSecondary),
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
}

class _SearchArticle {
  const _SearchArticle({
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