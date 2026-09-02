import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({
    super.key,
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

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool _isBookmarked = false;
  int? _selectedAnswer;
  bool _answerChecked = false;

  final List<Map<String, String>> _facts = const [
    {
      'label': 'WHO',
      'value': 'Government agencies and relevant stakeholders',
    },
    {
      'label': 'WHAT',
      'value': 'A new national initiative and implementation roadmap',
    },
    {
      'label': 'WHEN',
      'value': 'Announced in today’s current-affairs coverage',
    },
    {
      'label': 'WHERE',
      'value': 'Bangladesh',
    },
    {
      'label': 'WHY',
      'value': 'To support sustainable and inclusive development',
    },
  ];

  final List<String> _quizOptions = const [
    'To support sustainable national development',
    'To reduce international cooperation',
    'To replace existing public services',
    'To limit access to technology',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        surfaceTintColor: Colors.white,
        elevation: 0,
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
                        Expanded(
                          flex: 7,
                          child: _buildArticleContent(),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: _buildQuickRevision(),
                        ),
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
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
          colors: [
            widget.accentColor,
            AppColors.darkNavy,
          ],
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
              _buildBadge(widget.category),
              _buildBadge(widget.newspaperName),
            ],
          ),
          SizedBox(height: isMobile ? 22 : 32),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.summary,
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
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
                widget.readingTime,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
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
        Icon(
          icon,
          color: Colors.white70,
          size: 18,
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
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
            '${widget.summary} This development is important because it '
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
        const _SectionCard(
          icon: Icons.school_outlined,
          title: 'Exam takeaway',
          child: Text(
            'Remember the initiative’s main objective, the authority responsible '
            'for it and how it supports Bangladesh’s long-term development. '
            'These points may appear in MCQ, short-answer or written questions.',
            style: TextStyle(
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
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 58,
                  child: Text(
                    fact['label']!,
                    style: TextStyle(
                      color: widget.accentColor,
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
    return _SectionCard(
      icon: Icons.quiz_outlined,
      title: 'Check your understanding',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is the main purpose of the initiative discussed in this briefing?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            _quizOptions.length,
            (index) => _buildQuizOption(index),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _selectedAnswer == null || _answerChecked
                ? null
                : () {
                    setState(() {
                      _answerChecked = true;
                    });
                  },
            style: FilledButton.styleFrom(
              backgroundColor: widget.accentColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 15,
              ),
            ),
            child: const Text('Check answer'),
          ),
          if (_answerChecked) ...[
            const SizedBox(height: 14),
            Text(
              _selectedAnswer == 0
                  ? 'Correct! This is the central objective.'
                  : 'Not quite. Review the exam takeaway above.',
              style: TextStyle(
                color: _selectedAnswer == 0
                    ? const Color(0xFF047857)
                    : const Color(0xFFB91C1C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizOption(int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = _answerChecked && index == 0;
    final isWrong = _answerChecked && isSelected && index != 0;

    Color borderColor = AppColors.border;
    Color backgroundColor = Colors.white;

    if (isSelected) {
      borderColor = widget.accentColor;
      backgroundColor = widget.accentColor.withOpacity(0.06);
    }

    if (isCorrect) {
      borderColor = AppColors.accent;
      backgroundColor = const Color(0xFFECFDF5);
    }

    if (isWrong) {
      borderColor = const Color(0xFFDC2626);
      backgroundColor = const Color(0xFFFEF2F2);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _answerChecked
            ? null
            : () {
                setState(() {
                  _selectedAnswer = index;
                });
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : isWrong
                        ? Icons.cancel_rounded
                        : isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                color: isCorrect
                    ? AppColors.accent
                    : isWrong
                        ? const Color(0xFFDC2626)
                        : isSelected
                            ? widget.accentColor
                            : AppColors.textSecondary,
                size: 21,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(_quizOptions[index]),
              ),
            ],
          ),
        ),
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
              Icon(
                icon,
                color: iconColor,
                size: 23,
              ),
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
  const _Keyword({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
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