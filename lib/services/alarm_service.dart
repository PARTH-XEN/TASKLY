import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

/// Service responsible for exact Android alarm scheduling, inexact fallback, and cancellation.
class AlarmService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  AlarmService([FlutterLocalNotificationsPlugin? plugin])
    : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin() {
    tz.initializeTimeZones();
  }

  /// Hashes a UUID string into a positive 31-bit integer for Android PendingIntents.
  static int notificationIdFromUuid(String uuid) {
    return uuid.hashCode.abs() & 0x7FFFFFFF;
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

  /// Schedules an exact alarm with full-screen notification intent, automatically
  /// falling back to inexactAllowWhileIdle if exact alarm permission is restricted.
  Future<bool> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledAt,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
  }) async {
    // If time is in the past by more than 10 seconds, do not schedule
    if (scheduledAt.isBefore(
      DateTime.now().subtract(const Duration(seconds: 10)),
    )) {
      return false;
    }

    final notificationId = notificationIdFromUuid(id);
    final spokenText = generateSpokenMessage(
      title: title,
      customMessage: customSpokenMessage,
    );

    final androidDetails = AndroidNotificationDetails(
      NotificationService.alarmChannelId,
      'TASKLY Spoken Alarms',
      channelDescription: 'High-priority full-screen alarm notification',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      playSound: true,
      enableVibration: true,
      actions: const [
        AndroidNotificationAction(
          'stop_action',
          'Stop',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze_action',
          'Snooze (10m)',
          showsUserInterface: false,
        ),
      ],
      styleInformation: BigTextStyleInformation(
        '"$spokenText"\nVoice: ${voicePersonality.toUpperCase()}',
        contentTitle: title,
        summaryText: 'TASKLY Spoken Alarm',
      ),
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    // Ensure tzDateTime is localized and not in the past
    var tzDateTime = tz.TZDateTime.from(scheduledAt, tz.local);
    final tzNow = tz.TZDateTime.now(tz.local);
    if (tzDateTime.isBefore(tzNow)) {
      tzDateTime = tzNow.add(const Duration(seconds: 1));
    }

    final payload = jsonEncode({
      'id': id,
      'title': title,
      'message': spokenText,
      'voice': voicePersonality,
      'time': DateFormat('h:mm a').format(scheduledAt),
    });

    try {
      // First attempt: Exact alarm with wake-up
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        spokenText,
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      debugPrint(
        'TASKLY Alarm scheduled (exactAllowWhileIdle) for $tzDateTime',
      );
      return true;
    } catch (exactError) {
      debugPrint(
        'TASKLY Exact alarm restricted ($exactError). Falling back to inexactAllowWhileIdle...',
      );
      try {
        // Fallback attempt: Inexact alarm (does not require SCHEDULE_EXACT_ALARM permission)
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          spokenText,
          tzDateTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
        debugPrint(
          'TASKLY Alarm scheduled (inexactAllowWhileIdle fallback) for $tzDateTime',
        );
        return true;
      } catch (fallbackError) {
        debugPrint('TASKLY Fatal alarm scheduling failure: $fallbackError');
        return false;
      }
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
