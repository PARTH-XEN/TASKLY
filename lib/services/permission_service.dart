import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service managing Android runtime alarm and notification permissions.
class PermissionService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  static const MethodChannel _platformChannel = MethodChannel('taskly/native');

  PermissionService([FlutterLocalNotificationsPlugin? plugin])
    : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Requests notification permission on Android 13+ (POST_NOTIFICATIONS)
  Future<bool> requestNotificationPermission() async {
    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return false;
    final granted = await androidImpl.requestNotificationsPermission();
    return granted ?? false;
  }

  /// Requests exact alarm scheduling permission on Android 12+ (SCHEDULE_EXACT_ALARM)
  Future<bool> requestExactAlarmPermission() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final result = await _platformChannel.invokeMethod<bool>(
          'requestExactAlarmPermission',
        );
        if (result == true) return true;
      } catch (_) {}
    }

    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return false;
    final granted = await androidImpl.requestExactAlarmsPermission();
    return granted ?? false;
  }

  /// Checks whether exact alarms can currently be scheduled
  Future<bool> canScheduleExactAlarms() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final result = await _platformChannel.invokeMethod<bool>(
          'canScheduleExactAlarms',
        );
        if (result != null) return result;
      } catch (_) {}
    }

    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return false;
    final canSchedule = await androidImpl.canScheduleExactNotifications();
    return canSchedule ?? false;
  }
}
