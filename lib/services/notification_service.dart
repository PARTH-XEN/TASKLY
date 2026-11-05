import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification service handling channel initialization and notification responses.
class NotificationService {
  static const String alarmChannelId = 'taskly_alarm_channel';
  static const String reminderChannelId = 'taskly_reminder_channel';

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  void Function(String reminderId)? onAlarmNotificationTapped;

  NotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;

  Future<void> initialize() async {
    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onAlarmNotificationTapped?.call(payload);
        }
      },
    );

    // Create high-priority alarm notification channel
    const alarmChannel = AndroidNotificationChannel(
      alarmChannelId,
      'TASKLY Spoken Alarms',
      description: 'Full-screen high-priority alarms with spoken task reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    // Create standard reminder notification channel
    const reminderChannel = AndroidNotificationChannel(
      reminderChannelId,
      'TASKLY Reminders',
      description: 'Standard task reminders and scheduled updates',
      importance: Importance.defaultImportance,
      playSound: true,
    );

    final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(alarmChannel);
      await androidImpl.createNotificationChannel(reminderChannel);
    }
  }
}
