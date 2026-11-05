import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

/// Service responsible for exact Android alarm scheduling and cancellation.
class AlarmService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  AlarmService([FlutterLocalNotificationsPlugin? plugin])
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin() {
    tz.initializeTimeZones();
  }

  /// Hashes a UUID string into a positive 31-bit integer for Android PendingIntents.
  static int notificationIdFromUuid(String uuid) {
    final bytes = md5.convert(utf8.encode(uuid)).bytes;
    final intValue = bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24);
    return intValue & 0x7FFFFFFF; // Ensure positive 31-bit int
  }

  /// Computes target DateTime from a relative duration in minutes.
  static DateTime calculateRelativeDateTime({
    required int durationMinutes,
    DateTime? fromTime,
  }) {
    final base = fromTime ?? DateTime.now();
    return base.add(Duration(minutes: durationMinutes));
  }

  /// Dynamically produces the USP spoken task message.
  static String generateSpokenMessage({
    required String title,
    String? customMessage,
  }) {
    if (customMessage != null && customMessage.trim().isNotEmpty) {
      return customMessage.trim();
    }
    return "Hey! It's time to $title. Let's get started!";
  }

  /// Schedules an exact alarm with full-screen notification intent.
  Future<bool> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledAt,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
  }) async {
    // If time is in the past, do not schedule
    if (scheduledAt.isBefore(DateTime.now())) {
      return false;
    }

    final notificationId = notificationIdFromUuid(id);
    final spokenText = generateSpokenMessage(title: title, customMessage: customSpokenMessage);

    final androidDetails = AndroidNotificationDetails(
      NotificationService.alarmChannelId,
      'TASKLY Spoken Alarms',
      channelDescription: 'High-priority full-screen alarm notification',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      actions: const [
        AndroidNotificationAction('stop_action', 'Stop', showsUserInterface: true),
        AndroidNotificationAction('snooze_action', 'Snooze (10m)', showsUserInterface: false),
      ],
      styleInformation: BigTextStyleInformation(
        '"$spokenText"\nVoice: ${voicePersonality.toUpperCase()}',
        contentTitle: title,
        summaryText: 'TASKLY Spoken Alarm',
      ),
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final tzDateTime = tz.TZDateTime.from(scheduledAt, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        spokenText,
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: id,
      );
      return true;
    } catch (_) {
      // Inexact fallback or permission restricted
      return false;
    }
  }

  /// Cancels a scheduled reminder by its ID.
  Future<void> cancelReminder(String id) async {
    final notificationId = notificationIdFromUuid(id);
    await _notificationsPlugin.cancel(notificationId);
  }

  /// Reschedules an alarm for 10 minutes in the future.
  Future<DateTime> snoozeReminder({
    required String id,
    required String title,
    int snoozeMinutes = 10,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
  }) async {
    final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
    await scheduleReminder(
      id: id,
      title: title,
      scheduledAt: snoozeTime,
      customSpokenMessage: customSpokenMessage,
      voicePersonality: voicePersonality,
    );
    return snoozeTime;
  }
}
