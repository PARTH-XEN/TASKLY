import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Android notification channels and alarm triggers
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const ProviderScope(child: TasklyApp()));
}
