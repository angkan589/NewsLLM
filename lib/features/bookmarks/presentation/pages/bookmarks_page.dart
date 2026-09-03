import 'package:flutter/material.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/article_detail_page.dart';
import 'package:newsllm/features/news/data/mock_news_repository.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

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
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Saved briefings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        currentDestination: MainDestination.saved,
      ),
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, child) {
          final titles = AppSession.instance.bookmarkedArticleTitles;

          if (titles.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            itemCount: titles.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 14);
            },
            itemBuilder: (context, index) {
              final title = titles[index];
              final article = MockNewsRepository.findByTitle(title);

              return _BookmarkCard(
                title: title,
                source: article?.newspaperName,
                category: article?.category,
                readingTime: article?.readingTime,
                canOpen: article != null,
                onOpen: article == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailPage(article: article),
                          ),
                        );
                      },
                onRemove: () {
                  AppSession.instance.removeArticleBookmark(title);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Briefing removed from saved stories'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFF172A46)
                      : Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'No saved briefings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Open a news briefing and select the bookmark icon to save it '
                'for later revision.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded),
                label: Text('Browse briefings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({
    required this.title,
    required this.source,
    required this.category,
    required this.readingTime,
    required this.canOpen,
    required this.onOpen,
    required this.onRemove,
  });

  final String title;
  final String? source;
  final String? category;
  final String? readingTime;
  final bool canOpen;
  final VoidCallback? onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 900),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF172A46)
                          : Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.bookmark_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category != null)
                          Text(
                            category!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        if (category != null) SizedBox(height: 7),
                        Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 9),
                        if (canOpen)
                          Wrap(
                            spacing: 14,
                            runSpacing: 6,
                            children: [
                              if (source != null)
                                _Metadata(
                                  icon: Icons.newspaper_rounded,
                                  text: source!,
                                ),
                              if (readingTime != null)
                                _Metadata(
                                  icon: Icons.schedule_rounded,
                                  text: readingTime!,
                                ),
                            ],
                          )
                        else
                          Text(
                            'This older saved story is not available in the '
                            'current frontend news collection.',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Remove bookmark',
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  if (canOpen)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
