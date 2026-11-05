import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/alarms/presentation/alarm_history_screen.dart';
import '../../features/alarms/presentation/alarm_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/voice/presentation/voice_settings_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../shared/widgets/main_scaffold_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffoldShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home / Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        // Tab 1: Tasks
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              name: 'tasks',
              builder: (context, state) => const TasksScreen(),
            ),
          ],
        ),
        // Tab 2: Calendar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              name: 'calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        // Tab 3: Wishlist
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wishlist',
              name: 'wishlist',
              builder: (context, state) => const WishlistScreen(),
            ),
          ],
        ),
        // Tab 4: Profile & Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    // Dedicated Full-Screen Alarm Interface
    GoRoute(
      path: '/alarm',
      name: 'alarm',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return AlarmScreen(
          reminderId: extra['reminderId'] as String? ?? 'default_reminder',
          title: extra['title'] as String? ?? 'Scheduled Reminder',
          scheduledTimeText: extra['scheduledTimeText'] as String? ?? 'Now',
          voicePersonality: extra['voicePersonality'] as String? ?? 'nova',
          spokenMessage:
              extra['spokenMessage'] as String? ??
              "Hey! It's time for your task. Let's get started!",
        );
      },
    ),
    // Alarm Trigger & Snooze History Log
    GoRoute(
      path: '/alarm-history',
      name: 'alarm_history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AlarmHistoryScreen(),
    ),
    // Voice Personalities & TTS Engine Settings
    GoRoute(
      path: '/voice-settings',
      name: 'voice_settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VoiceSettingsScreen(),
    ),
  ],
);
