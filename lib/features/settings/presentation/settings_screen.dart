import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../services/permission_service.dart';
import '../../reminders/data/reminders_repository.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Theme'),
        content: RadioGroup<ThemeMode>(
          groupValue: currentMode,
          onChanged: (mode) async {
            if (mode != null) {
              ref.read(themeModeProvider.notifier).state = mode;
              await ref.read(settingsRepositoryProvider).setThemeMode(mode);
              if (ctx.mounted) Navigator.pop(ctx);
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text('System Default'),
                subtitle: Text('Follow system dark / light mode'),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Dark Mode'),
                subtitle: Text('Deep charcoal & navy surfaces'),
                value: ThemeMode.dark,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Light Mode'),
                subtitle: Text('Crisp white cards & surfaces'),
                value: ThemeMode.light,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSnoozeDurationDialog(
    BuildContext context,
    WidgetRef ref,
    int currentMins,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default Snooze Duration'),
        content: RadioGroup<int>(
          groupValue: currentMins,
          onChanged: (val) async {
            if (val != null) {
              await ref
                  .read(settingsRepositoryProvider)
                  .setDefaultSnoozeMinutes(val);
              if (ctx.mounted) Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [5, 10, 15, 20, 30].map((mins) {
              return RadioListTile<int>(
                title: Text('$mins minutes'),
                value: mins,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFirstDayDialog(
    BuildContext context,
    WidgetRef ref,
    String currentDay,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('First Day of Week'),
        content: RadioGroup<String>(
          groupValue: currentDay.toLowerCase(),
          onChanged: (val) async {
            if (val != null) {
              await ref.read(settingsRepositoryProvider).setFirstDayOfWeek(val);
              if (ctx.mounted) Navigator.pop(ctx);
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Monday'),
                subtitle: Text('ISO 8601 standard week start'),
                value: 'monday',
              ),
              RadioListTile<String>(
                title: Text('Sunday'),
                subtitle: Text('Traditional calendar week start'),
                value: 'sunday',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.privacy_tip_rounded, color: AppColors.indigoLight),
            SizedBox(width: 8),
            Expanded(child: Text('Privacy & Offline First')),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TASKLY is engineered with a strict 100% offline-first architecture.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                '• Zero External APIs: No telemetry, trackers, or user habits are sent to cloud servers.',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '• Zero Paid AI APIs: All voice personalities (Nova, Max, Atlas, Echo) run locally using the device’s built-in Text-to-Speech engine.',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '• Complete Data Isolation: Tasks, reminders, alarms, calendar agendas, and wishlist goals are persisted solely in your device’s local SQLite database.',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '• No Account Required: You never need to sign in, provide an email, or connect any social profile.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showReliabilityGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppColors.indigoLight),
            SizedBox(width: 8),
            Expanded(child: Text('Reliability Guide')),
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
    final themeMode = ref.watch(themeModeProvider);
    final themeSubtitle = themeMode == ThemeMode.system
        ? 'System Default'
        : themeMode == ThemeMode.dark
        ? 'Dark Mode'
        : 'Light Mode';

    final snoozeMins =
        ref.watch(defaultSnoozeMinutesStreamProvider).value ?? 10;
    final is24h = ref.watch(timeFormat24hStreamProvider).value ?? false;
    final firstDay = ref.watch(firstDayOfWeekStreamProvider).value ?? 'monday';
    final haptic = ref.watch(hapticFeedbackStreamProvider).value ?? true;

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
              await PermissionService().requestNotificationPermission();

              final testTime = DateTime.now().add(const Duration(seconds: 5));
              await ref
                  .read(alarmServiceProvider)
                  .scheduleReminder(
                    id: 'test_demo_alarm',
                    title: 'TASKLY Voice Alarm Demo',
                    scheduledAt: testTime,
                    voicePersonality: 'nova',
                    customSpokenMessage:
                        "Hey! It's time to test TASKLY. Your spoken alarms are working perfectly!",
                  );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '⏰ Test alarm will fire in 5 seconds! Feel free to lock your screen or wait here.',
                    ),
                    backgroundColor: AppColors.indigoLight,
                    duration: Duration(seconds: 4),
                  ),
                );
              }

              // Foreground helper: If user stays on this screen, open the alarm visualizer after 5s
              Future.delayed(const Duration(seconds: 5), () {
                if (context.mounted) {
                  final uri = GoRouterState.of(context).uri.toString();
                  if (!uri.contains('/alarm')) {
                    context.push(
                      '/alarm',
                      extra: {
                        'reminderId': 'test_demo_alarm',
                        'title': 'TASKLY Voice Alarm Demo',
                        'scheduledTimeText': 'Just now',
                        'spokenMessage':
                            "Hey! It's time to test TASKLY. Your spoken alarms are working perfectly!",
                        'voicePersonality': 'nova',
                      },
                    );
                  }
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Appearance Section
          const _SettingsSectionHeader(title: 'Appearance'),
          _SettingsTile(
            title: 'Theme Mode',
            subtitle: themeSubtitle,
            icon: Icons.palette_outlined,
            iconColor: AppColors.cyanLight,
            onTap: () => _showThemeDialog(context, ref, themeMode),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Alarm & Reliability Section
          const _SettingsSectionHeader(
            title: 'Alarm & Notification Reliability',
          ),
          _SettingsTile(
            title: 'Default Snooze Duration',
            subtitle: '$snoozeMins minutes',
            icon: Icons.snooze_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () => _showSnoozeDurationDialog(context, ref, snoozeMins),
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

          // General Preferences Section
          const _SettingsSectionHeader(title: 'General Preferences'),
          _SettingsTile(
            title: 'Time Format',
            subtitle: is24h ? '24-Hour (14:30)' : '12-Hour (2:30 PM)',
            icon: Icons.schedule_rounded,
            iconColor: AppColors.cyanLight,
            trailing: Switch.adaptive(
              value: is24h,
              onChanged: (val) async {
                await ref
                    .read(settingsRepositoryProvider)
                    .setTimeFormat24h(val);
              },
            ),
            onTap: () async {
              await ref
                  .read(settingsRepositoryProvider)
                  .setTimeFormat24h(!is24h);
            },
          ),
          _SettingsTile(
            title: 'First Day of Week',
            subtitle: firstDay.toLowerCase() == 'monday' ? 'Monday' : 'Sunday',
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () => _showFirstDayDialog(context, ref, firstDay),
          ),
          _SettingsTile(
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on button taps & alarm interactions',
            icon: Icons.vibration_rounded,
            iconColor: AppColors.primaryIndigo,
            trailing: Switch.adaptive(
              value: haptic,
              onChanged: (val) async {
                await ref
                    .read(settingsRepositoryProvider)
                    .setHapticFeedback(val);
              },
            ),
            onTap: () async {
              await ref
                  .read(settingsRepositoryProvider)
                  .setHapticFeedback(!haptic);
            },
          ),
          _SettingsTile(
            title: 'Privacy & Offline Guarantee',
            subtitle: '100% offline-first • Zero external telemetry',
            icon: Icons.security_rounded,
            iconColor: AppColors.successLight,
            onTap: () => _showPrivacyDialog(context),
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
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icons/taskly_logo.png',
                    width: 52,
                    height: 52,
                  ),
                ),
                applicationLegalese:
                    '100% Free and Open Source Productivity & Smart Spoken Alarms\n\nTagline: "Don\'t just remind me when. Remind me what."',
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
  final Widget? trailing;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.trailing,
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
          trailing:
              trailing ??
              Icon(
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
