import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../services/permission_service.dart';
import '../../reminders/data/reminders_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showReliabilityGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppColors.indigoLight),
            SizedBox(width: 8),
            Text('Reliability Guide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _guideItem(
                title: '1. Screen Locked or Turned Off',
                desc: 'TASKLY uses high-priority notification channels and full-screen intents with "showWhenLocked" and "turnScreenOn" flags to illuminate your screen and ring when alarms fire.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _guideItem(
                title: '2. Device Reboot Recovery',
                desc: 'Scheduled notifications are registered with Android\'s ScheduledNotificationBootReceiver to automatically restore pending alarms after a device restart.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _guideItem(
                title: '3. Battery Optimization (Doze Mode)',
                desc: 'To prevent Android OS from deferring exact alarms, set TASKLY\'s battery usage to "Unrestricted" in Android App Info settings.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _guideItem(
                title: '4. Force Stop Limitation',
                desc: 'Android OS intentionally halts all background execution if an app is manually Force Stopped from System Settings. Alarms resume normally once you reopen TASKLY.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _guideItem({required String title, required String desc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Voice Personalities Section Preview
          const _SettingsSectionHeader(title: 'Voice Personalities (USP)'),
          _SettingsTile(
            title: 'TTS Voice Engines',
            subtitle: 'Nova, Max, Atlas, Echo (Offline Device TTS)',
            icon: Icons.record_voice_over_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () => context.push('/voice-settings'),
          ),
          _SettingsTile(
            title: 'Test Spoken Alarm (5s Demo)',
            subtitle: 'Fires full-screen alarm & speaks in 5 seconds',
            icon: Icons.play_circle_fill_rounded,
            iconColor: AppColors.primaryIndigo,
            onTap: () async {
              final testTime = DateTime.now().add(const Duration(seconds: 5));
              await ref
                  .read(alarmServiceProvider)
                  .scheduleReminder(
                    id: 'test_demo_alarm',
                    title: 'TASKLY Voice Alarm Demo',
                    scheduledAt: testTime,
                    voicePersonality: 'nova',
                    customSpokenMessage: "Hey! It's time to test TASKLY. Your spoken alarms are working perfectly!",
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '⏰ Test alarm will fire in 5 seconds! Feel free to lock your screen.',
                    ),
                    backgroundColor: AppColors.indigoLight,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Appearance Section
          const _SettingsSectionHeader(title: 'Appearance'),
          _SettingsTile(
            title: 'Theme Mode',
            subtitle: isDark
                ? 'Dark Mode (Tap to switch)'
                : 'Light Mode (Tap to switch)',
            icon: Icons.palette_outlined,
            iconColor: AppColors.cyanLight,
            onTap: () {
              ref.read(themeModeProvider.notifier).state = isDark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Alarm & Permissions Section
          const _SettingsSectionHeader(
            title: 'Alarm & Notification Reliability',
          ),
          _SettingsTile(
            title: 'Alarm History & Logs',
            subtitle: 'View triggered, snoozed, and completed reminders',
            icon: Icons.history_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () => context.push('/alarm-history'),
          ),
          _SettingsTile(
            title: 'Background Reliability Guide',
            subtitle: 'Permissions, reboot recovery, and Doze mode details',
            icon: Icons.verified_user_rounded,
            iconColor: AppColors.cyanLight,
            onTap: () => _showReliabilityGuideDialog(context),
          ),
          _SettingsTile(
            title: 'Android Exact Alarm Permission',
            subtitle: 'Exact timing requires SCHEDULE_EXACT_ALARM',
            icon: Icons.alarm_rounded,
            iconColor: AppColors.warningLight,
            onTap: () async {
              final granted = await PermissionService()
                  .requestExactAlarmPermission();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      granted ? 'Exact alarm permission granted!' : 'Exact alarm permission requested. Please enable in Android Settings.',
                    ),
                  ),
                );
              }
            },
          ),
          _SettingsTile(
            title: 'Battery Optimization Whitelist',
            subtitle: 'Ensures background reminders wake device',
            icon: Icons.battery_charging_full_rounded,
            iconColor: AppColors.successLight,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please set TASKLY battery usage to Unrestricted in Android Settings for 100% reliable alarms.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // About Section
          const _SettingsSectionHeader(title: 'About TASKLY'),
          _SettingsTile(
            title: 'Version',
            subtitle: '1.0.0+1 (Offline First • Zero AI APIs)',
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.darkTextTertiary,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'TASKLY',
                applicationVersion: '1.0.0+1',
                applicationLegalese: '100% Free and Open Source Productivity & Smart Spoken Alarms',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: isDark ? AppColors.indigoLight : AppColors.primaryIndigo,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: AppRadius.roundedSm,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
