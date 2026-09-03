import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/home/presentation/pages/newspaper_briefings_page.dart';

class NewspaperSourcesSection extends StatefulWidget {
  const NewspaperSourcesSection({super.key});

  @override
  State<NewspaperSourcesSection> createState() =>
      _NewspaperSourcesSectionState();
}

class _NewspaperSourcesSectionState extends State<NewspaperSourcesSection> {
  final ScrollController _scrollController = ScrollController();

  static const List<_NewspaperSource> _sources = [
    _NewspaperSource(
      shortName: 'PA',
      name: 'Prothom Alo',
      language: 'Bangla',
      briefingCount: '8 briefings',
      color: Color(0xFFDC2626),
    ),
    _NewspaperSource(
      shortName: 'DS',
      name: 'The Daily Star',
      language: 'English',
      briefingCount: '6 briefings',
      color: Color(0xFF0F766E),
    ),
    _NewspaperSource(
      shortName: 'DT',
      name: 'Dhaka Tribune',
      language: 'English',
      briefingCount: '5 briefings',
      color: Color(0xFF2563EB),
    ),
    _NewspaperSource(
      shortName: 'BD',
      name: 'bdnews24.com',
      language: 'Bangla & English',
      briefingCount: '7 briefings',
      color: Color(0xFFEA580C),
    ),
    _NewspaperSource(
      shortName: 'TBS',
      name: 'The Business Standard',
      language: 'English',
      briefingCount: '4 briefings',
      color: Color(0xFF334155),
    ),
  ];

  void _moveCarousel(double distance) {
    if (!_scrollController.hasClients) return;

    final newPosition = (_scrollController.offset + distance).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      newPosition,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isMobile),
        SizedBox(height: 22),

        // A fixed height prevents infinite-height layout errors.
        SizedBox(
          height: isMobile ? 355 : 385,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: _sources.length,
            separatorBuilder: (context, index) {
              return SizedBox(width: 16);
            },
            itemBuilder: (context, index) {
              return _NewspaperCard(
                source: _sources[index],
                width: isMobile ? 215 : 245,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today’s newspaper desk',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: isMobile ? 21 : 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Swipe through today’s newspapers and explore the briefings.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CarouselButton(
          icon: Icons.chevron_left_rounded,
          onPressed: () => _moveCarousel(-500),
        ),
        SizedBox(width: 8),
        _CarouselButton(
          icon: Icons.chevron_right_rounded,
          onPressed: () => _moveCarousel(500),
        ),
        SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '30 BRIEFINGS',
            style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [heading, SizedBox(height: 14), controls],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: heading),
        controls,
      ],
    );
  }
}

class _NewspaperCard extends StatelessWidget {
  const _NewspaperCard({required this.source, required this.width});

  final _NewspaperSource source;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewspaperBriefingsPage(
                  newspaperName: source.name,
                  shortName: source.shortName,
                  language: source.language,
                  color: source.color,
                ),
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: source.color.withValues(alpha: 0.08),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.newspaper_rounded,
                                color: source.color,
                                size: 64,
                              ),
                              SizedBox(height: 14),
                              Text(
                                source.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: source.color,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Front page preview',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 14,
                          right: 14,
                          bottom: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: source.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    source.briefingCount,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: source.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          source.shortName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              source.language,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselButton extends StatelessWidget {
  const _CarouselButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppColors.darkNavy,
        iconSize: 23,
        tooltip: 'Slide newspapers',
      ),
    );
  }
}

class _NewspaperSource {
  const _NewspaperSource({
    required this.shortName,
    required this.name,
    required this.language,
    required this.briefingCount,
    required this.color,
  });

  final String shortName;
  final String name;
  final String language;
  final String briefingCount;
  final Color color;
}
