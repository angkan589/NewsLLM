import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:newsllm/features/progress/presentation/pages/exam_history_page.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';
import 'package:newsllm/features/settings/presentation/pages/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign out?'),
          content: const Text(
            'You will need to sign in again to access your saved progress.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    AppSession.instance.signOut();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const MainNavigationBar(
        currentDestination: MainDestination.profile,
      ),
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
          'My profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, child) {
          final session = AppSession.instance;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    _buildProfileHeader(session),
                    const SizedBox(height: 20),
                    _buildProgressSection(session),
                    const SizedBox(height: 20),
                    _buildAccountSection(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AppSession session) {
    final initial = session.name.isEmpty ? 'N' : session.name[0].toUpperCase();

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
      child: Wrap(
        spacing: 20,
        runSpacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 2,
              ),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                session.email,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF6EE7B7),
                    size: 17,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Frontend demonstration account',
                    style: TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(AppSession session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning progress',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _ProfileStat(
                icon: Icons.quiz_outlined,
                value: '${session.completedQuizCount}',
                label: 'Exams completed',
                color: AppColors.primary,
              ),
              _ProfileStat(
                icon: Icons.grade_outlined,
                value: '${session.averageQuizPercentage}%',
                label: 'Average score',
                color: const Color(0xFF059669),
              ),
              _ProfileStat(
                icon: Icons.bookmark_border_rounded,
                value: '${session.bookmarkCount}',
                label: 'Saved stories',
                color: const Color(0xFFD97706),
              ),
              const _ProfileStat(
                icon: Icons.local_fire_department_outlined,
                value: '0',
                label: 'Day streak',
                color: Color(0xFFDC2626),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Exam history, average score and streak will use real stored data '
            'after the backend is connected.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              color: AppColors.darkNavy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history_rounded),
            title: const Text('Exam history'),
            subtitle: Text(
              '${AppSession.instance.completedQuizCount} completed exams',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExamHistoryPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bookmark_border_rounded),
            title: const Text('Saved briefings'),
            subtitle: Text(
              '${AppSession.instance.bookmarkCount} saved stories',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BookmarksPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            subtitle: Text(
              '${AppSession.instance.preferredLanguage} • Notifications and reminders',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              _signOut(context);
            },
            leading: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            title: const Text(
              'Sign out',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.darkNavy,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
