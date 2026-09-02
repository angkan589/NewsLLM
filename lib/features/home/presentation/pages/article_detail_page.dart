import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/auth/presentation/pages/auth_page.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';
import 'package:newsllm/features/quiz/presentation/pages/quiz_page.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({
    super.key,
    this.article,
    this.newspaperName = '',
    this.category = '',
    this.title = '',
    this.summary = '',
    this.readingTime = '',
    this.accentColor = AppColors.primary,
  });

  final NewsArticle? article;

  // Temporary compatibility fields. We will remove these after every page
  // has been migrated to NewsArticle.
  final String newspaperName;
  final String category;
  final String title;
  final String summary;
  final String readingTime;
  final Color accentColor;

  String get resolvedNewspaperName => article?.newspaperName ?? newspaperName;

  String get resolvedCategory => article?.category ?? category;

  String get resolvedTitle => article?.title ?? title;

  String get resolvedSummary => article?.summary ?? summary;

  String get resolvedReadingTime => article?.readingTime ?? readingTime;

  Color get resolvedAccentColor => article?.accentColor ?? accentColor;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool _isBookmarked = false;

  final List<Map<String, String>> _facts = const [
    {'label': 'WHO', 'value': 'Government agencies and relevant stakeholders'},
    {
      'label': 'WHAT',
      'value': 'A new national initiative and implementation roadmap',
    },
    {'label': 'WHEN', 'value': 'Announced in today’s current-affairs coverage'},
    {'label': 'WHERE', 'value': 'Bangladesh'},
    {
      'label': 'WHY',
      'value': 'To support sustainable and inclusive development',
    },
  ];

  @override
  void initState() {
    super.initState();

    _isBookmarked = AppSession.instance.isArticleBookmarked(
      widget.resolvedTitle,
    );
  }

  QuizDefinition get _articleQuiz {
    final quizId = widget.resolvedTitle
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return QuizDefinition(
      id: 'article-$quizId',
      title: 'Article quiz',
      type: QuizType.article,
      relatedArticleTitle: widget.resolvedTitle,
      questions: [
        QuizQuestion(
          id: '$quizId-headline',
          question: 'Which headline belongs to this briefing?',
          options: [
            widget.resolvedTitle,
            'Regional tourism programme receives international funding',
            'New glacier research project begins in Europe',
            'Global sports competition announces its final schedule',
          ],
          correctAnswerIndex: 0,
          explanation: 'This is the headline of the briefing you just studied.',
        ),
        QuizQuestion(
          id: '$quizId-summary',
          question: 'Which statement best summarizes this briefing?',
          options: [
            widget.resolvedSummary,
            'The briefing is mainly about entertainment and celebrity news.',
            'The briefing announces the cancellation of all public services.',
            'The briefing discusses an unrelated international sports event.',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The correct option contains the central summary of the article.',
        ),
        QuizQuestion(
          id: '$quizId-source',
          question: 'Which news source published this briefing?',
          options: [
            widget.resolvedNewspaperName,
            'An unnamed social-media account',
            'A fictional newspaper',
            'No source was provided',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The source is displayed at the top of the news briefing.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 760;

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
          'News briefing',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? 'Remove bookmark' : 'Save bookmark',
            onPressed: _toggleBookmark,
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 32,
          vertical: isMobile ? 24 : 36,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHero(isMobile),
                const SizedBox(height: 22),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 850) {
                      return Column(
                        children: [
                          _buildArticleContent(),
                          const SizedBox(height: 20),
                          _buildQuickRevision(),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildArticleContent()),
                        const SizedBox(width: 20),
                        Expanded(flex: 4, child: _buildQuickRevision()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildQuiz(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleBookmark() async {
    if (!AppSession.instance.isSignedIn) {
      final shouldSignIn = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Sign in to save'),
            content: const Text(
              'You can read every briefing and take every exam as a guest. '
              'Sign in is only required to save bookmarks and learning progress.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: const Text('Continue as guest'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Sign in'),
              ),
            ],
          );
        },
      );

      if (shouldSignIn != true || !mounted) {
        return;
      }

      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const AuthPage()));

      if (!mounted || !AppSession.instance.isSignedIn) {
        return;
      }
    }

    final bookmarked = AppSession.instance.toggleArticleBookmark(
      widget.resolvedTitle,
    );

    setState(() {
      _isBookmarked = bookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bookmarked
              ? 'Briefing saved to bookmarks'
              : 'Briefing removed from bookmarks',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.resolvedAccentColor, AppColors.darkNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildBadge(widget.resolvedCategory),
              _buildBadge(widget.resolvedNewspaperName),
            ],
          ),
          SizedBox(height: isMobile ? 22 : 32),
          Text(
            widget.resolvedTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.resolvedSummary,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: isMobile ? 15 : 17,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildHeroInfo(
                Icons.schedule_rounded,
                widget.resolvedReadingTime,
              ),
              _buildHeroInfo(
                Icons.auto_awesome_rounded,
                'AI-assisted exam summary',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.darkNavy,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildHeroInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 7),
        Text(text, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildArticleContent() {
    return Column(
      children: [
        _SectionCard(
          icon: Icons.article_outlined,
          title: 'The story in brief',
          child: Text(
            widget.article?.content ??
                '${widget.resolvedSummary} This development is important because it '
                    'connects today’s news with wider national priorities. For exam '
                    'preparation, focus on the objective, responsible institutions '
                    'and expected public impact.',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          icon: Icons.school_outlined,
          title: 'Exam takeaway',
          child: Text(
            widget.article?.examTakeaway ??
                'Remember the initiative’s main objective, the authority responsible '
                    'for it and how it supports Bangladesh’s long-term development.',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _SectionCard(
          icon: Icons.key_rounded,
          title: 'Key terms',
          child: Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _Keyword(label: 'Sustainable development'),
              _Keyword(label: 'Public policy'),
              _Keyword(label: 'Bangladesh'),
              _Keyword(label: 'National roadmap'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickRevision() {
    return _SectionCard(
      icon: Icons.bolt_rounded,
      iconColor: const Color(0xFFD97706),
      title: 'Quick revision',
      child: Column(
        children: _facts.map((fact) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 58,
                  child: Text(
                    fact['label']!,
                    style: TextStyle(
                      color: widget.resolvedAccentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    fact['value']!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuiz() {
    final quiz = _articleQuiz;

    return _SectionCard(
      icon: Icons.quiz_outlined,
      title: 'Check your understanding',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${quiz.questions.length} questions based on this briefing.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.resolvedAccentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.resolvedAccentColor.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Review the summary and key facts before starting.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    quiz: quiz,
                    accentColor: widget.resolvedAccentColor,
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: widget.resolvedAccentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start article quiz'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 23),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _Keyword extends StatelessWidget {
  const _Keyword({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
