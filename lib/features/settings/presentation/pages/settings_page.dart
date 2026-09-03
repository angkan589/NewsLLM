import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, child) {
          final session = AppSession.instance;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageSection(context, session),
                    SizedBox(height: 20),
                    _buildNotificationSection(context, session),
                    SizedBox(height: 20),
                    _buildStorageNotice(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppSession session) {
    return _SettingsCard(
      title: 'Language',
      icon: Icons.language_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose the language used for briefings and quizzes.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: 18),
          SegmentedButton<String>(
            segments: [
              ButtonSegment<String>(
                value: 'English',
                label: Text('English'),
                icon: Icon(Icons.translate_rounded),
              ),
              ButtonSegment<String>(
                value: 'বাংলা',
                label: Text('বাংলা'),
                icon: Icon(Icons.translate_rounded),
              ),
            ],
            selected: {session.preferredLanguage},
            onSelectionChanged: (selection) {
              session.updatePreferredLanguage(selection.first);
            },
          ),
          SizedBox(height: 14),
          Text(
            'Full Bengali content will be connected when multilingual '
            'AI content generation is implemented.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context, AppSession session) {
    return _SettingsCard(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Important news'),
            subtitle: Text(
              'Receive alerts for important current-affairs stories.',
            ),
            value: session.newsNotificationsEnabled,
            onChanged: session.updateNewsNotifications,
          ),
          Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Exam reminders'),
            subtitle: Text(
              'Receive reminders about available quizzes and exams.',
            ),
            value: session.examRemindersEnabled,
            onChanged: session.updateExamReminders,
          ),
          Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Daily briefing'),
            subtitle: Text(
              'Receive a reminder when the daily briefing is ready.',
            ),
            value: session.dailyBriefingReminderEnabled,
            onChanged: session.updateDailyBriefingReminder,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageNotice(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF172A46)
            : Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'These preferences currently remain only while the frontend '
              'application is running. Permanent account synchronization '
              'will be added during backend development.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
