import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'services/notification_service.dart';

void _routeToAlarm(String rawPayload) {
  try {
    if (rawPayload.startsWith('{')) {
      final data = jsonDecode(rawPayload) as Map<String, dynamic>;
      appRouter.push(
        '/alarm',
        extra: {
          'reminderId': data['id'] ?? '',
          'title': data['title'] ?? 'Task Reminder',
          'scheduledTimeText': data['time'] ?? 'Now',
          'spokenMessage': data['message'] ?? '',
          'voicePersonality': data['voice'] ?? 'nova',
        },
      );
      return;
    }
  } catch (e) {
    debugPrint('Error parsing alarm payload: $e');
  }

  // Fallback for simple ID payload
  appRouter.push(
    '/alarm',
    extra: {
      'reminderId': rawPayload,
      'title': 'Task Reminder',
      'scheduledTimeText': 'Now',
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Android notification channels, timezone, and alarm triggers
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Handle in-app and background notification taps
  notificationService.onAlarmNotificationTapped = (payload) {
    _routeToAlarm(payload);
  };

  // Handle cold-start launch from alarm notification
  final launchDetails = await notificationService.plugin
      .getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final payload = launchDetails?.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _routeToAlarm(payload);
      });
    }
  }

  runApp(const ProviderScope(child: TasklyApp()));
}
