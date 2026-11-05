import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Android notification channels and alarm triggers
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Handle in-app and background notification taps
  notificationService.onAlarmNotificationTapped = (reminderId) {
    appRouter.push(
      '/alarm',
      extra: {
        'reminderId': reminderId,
        'title': 'Task Reminder',
        'scheduledTimeText': 'Now',
      },
    );
  };

  // Handle cold-start launch from alarm notification
  final launchDetails = await notificationService.plugin
      .getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final payload = launchDetails?.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.push(
          '/alarm',
          extra: {
            'reminderId': payload,
            'title': 'Task Reminder',
            'scheduledTimeText': 'Now',
          },
        );
      });
    }
  }

  runApp(const ProviderScope(child: TasklyApp()));
}
