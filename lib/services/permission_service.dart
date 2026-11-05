import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service managing Android runtime alarm and notification permissions.
class PermissionService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

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
    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return false;
    final canSchedule = await androidImpl.canScheduleExactNotifications();
    return canSchedule ?? false;
  }
}
