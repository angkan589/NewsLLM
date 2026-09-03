import 'package:flutter/material.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 56,
                vertical: isMobile ? 40 : 52,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: BorderRadius.circular(28),
              ),
              child: isMobile
                  ? Column(
                      children: [
                        _buildCallToActionText(context, true),
                        SizedBox(height: 28),
                        _buildButton(context),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildCallToActionText(context, false)),
                        SizedBox(width: 40),
                        _buildButton(context),
                      ],
                    ),
            );
          },
        ),
        SizedBox(height: 48),
        Divider(color: Theme.of(context).colorScheme.outlineVariant),
        SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            if (isMobile) {
              return Column(
                children: [
                  _FooterBrand(),
                  SizedBox(height: 20),
                  _FooterLinks(),
                  SizedBox(height: 20),
                  Text(
                    '© 2026 NewsLLM. All rights reserved.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                _FooterBrand(),
                Spacer(),
                _FooterLinks(),
                Spacer(),
                Text(
                  '© 2026 NewsLLM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCallToActionText(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to make today’s news count?',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontSize: isMobile ? 30 : 38,
            height: 1.15,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Build a consistent current-affairs habit in only a few minutes a day.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xFF6EE7B7),
        foregroundColor: AppColors.darkNavy,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
      ),
      icon: Icon(Icons.arrow_forward),
      label: Text(
        'Start learning free',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.primary, size: 21),
        SizedBox(width: 8),
        Text(
          'NewsLLM',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      children: [
        Text(
          'About',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Privacy',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Contact',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
