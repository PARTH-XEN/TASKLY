import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification service handling channel initialization, timezone resolution, and notification responses.
class NotificationService {
  static const String alarmChannelId = 'taskly_alarm_channel_v2';
  static const String reminderChannelId = 'taskly_reminder_channel_v2';

  static const MethodChannel _platformChannel = MethodChannel('taskly/native');

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  void Function(String reminderId)? onAlarmNotificationTapped;

  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;

  /// Resolves the device's actual IANA local timezone so scheduled alarms fire at the correct local moment.
  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();

    // 1. First attempt: Query native Android ZoneId
    try {
      final String? timeZoneName = await _platformChannel.invokeMethod<String>(
        'getLocalTimezone',
      );
      if (timeZoneName != null && timeZoneName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        debugPrint(
          'TASKLY Timezone configured via Android native: $timeZoneName',
        );
        return;
      }
    } catch (e) {
      debugPrint('TASKLY Native timezone query exception: $e');
    }

    // 2. Second attempt: Match timezone offset from DateTime.now()
    try {
      final offsetMs = DateTime.now().timeZoneOffset.inMilliseconds;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == offsetMs) {
          tz.setLocalLocation(loc);
          debugPrint(
            'TASKLY Timezone matched by system offset: ${loc.name} (${loc.currentTimeZone.offset}ms)',
          );
          return;
        }
      }
    } catch (e) {
      debugPrint('TASKLY Offset match exception: $e');
    }

    debugPrint('TASKLY Timezone using default local');
  }

  Future<void> initialize() async {
    await configureLocalTimeZone();

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
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

    // Create high-priority alarm notification channel with alarm audio usage and distinct vibration
    final vibrationPattern = Int64List.fromList([
      0,
      1000,
      500,
      1000,
      500,
      1000,
    ]);
    final alarmChannel = AndroidNotificationChannel(
      alarmChannelId,
      'TASKLY Spoken Alarms',
      description:
          'Full-screen high-priority alarms with spoken task reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    // Create standard reminder notification channel
    const reminderChannel = AndroidNotificationChannel(
      reminderChannelId,
      'TASKLY Reminders',
      description: 'Standard task reminders and scheduled updates',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      // Request Android 13+ POST_NOTIFICATIONS permission
      await androidImpl.requestNotificationsPermission();
      await androidImpl.createNotificationChannel(alarmChannel);
      await androidImpl.createNotificationChannel(reminderChannel);
    }
  }
}
