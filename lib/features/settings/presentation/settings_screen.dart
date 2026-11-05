import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../services/permission_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Voice Personalities Section Preview
          _SettingsSectionHeader(title: 'Voice Personalities (USP)'),
          _SettingsTile(
            title: 'TTS Voice Engines',
            subtitle: 'Nova, Max, Atlas, Echo (Offline Device TTS)',
            icon: Icons.record_voice_over_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),

          // Appearance Section
          _SettingsSectionHeader(title: 'Appearance'),
          _SettingsTile(
            title: 'Theme Mode',
            subtitle: isDark ? 'Dark Mode' : 'Light Mode',
            icon: Icons.palette_outlined,
            iconColor: AppColors.cyanLight,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),

          // Alarm & Permissions Section
          _SettingsSectionHeader(title: 'Alarm & Notification Reliability'),
          _SettingsTile(
            title: 'Alarm History & Logs',
            subtitle: 'View triggered, snoozed, and completed reminders',
            icon: Icons.history_rounded,
            iconColor: AppColors.indigoLight,
            onTap: () => context.push('/alarm-history'),
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
                    'Please disable Battery Optimization for TASKLY in Android Settings for 100% reliable alarms.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // About Section
          _SettingsSectionHeader(title: 'About TASKLY'),
          _SettingsTile(
            title: 'Version',
            subtitle: '1.0.0+1 (Offline First • Zero AI APIs)',
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.darkTextTertiary,
            onTap: () {},
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: AppColors.indigoLight,
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: AppRadius.roundedMd,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
