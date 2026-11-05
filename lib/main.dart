import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Listen to native Android full-screen alarm intents
  const nativeChannel = MethodChannel('taskly/native');
  nativeChannel.setMethodCallHandler((call) async {
    if (call.method == 'onAlarmTriggeredFromNative') {
      final data = call.arguments as Map<dynamic, dynamic>? ?? {};
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.push(
          '/alarm',
          extra: {
            'reminderId': data['reminderId']?.toString() ?? '',
            'title': data['title']?.toString() ?? 'Task Reminder',
            'scheduledTimeText': 'Now',
            'spokenMessage': data['spokenMessage']?.toString() ?? '',
            'voicePersonality': data['voicePersonality']?.toString() ?? 'nova',
          },
        );
      });
    }
  });

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
