import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

/// Service responsible for native Android alarm scheduling, background speech execution,
/// inexact fallback, and cancellation.
class AlarmService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  static const MethodChannel _platformChannel = MethodChannel('taskly/native');

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

  /// Schedules an exact alarm with background speech and full-screen notification intent.
  Future<bool> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledAt,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
    double speechRate = 1.0,
    double speechPitch = 1.0,
    int speechRepeatCount = 1,
    bool showOverLockScreen = false,
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

    // 1. Primary engine for Android: Native Background Speech & AlarmManager
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final success = await _platformChannel.invokeMethod<bool>(
          'scheduleNativeAlarm',
          {
            'id': id,
            'title': title,
            'spokenMessage': spokenText,
            'scheduledAtMillis': scheduledAt.millisecondsSinceEpoch,
            'voicePersonality': voicePersonality,
            'speechRate': speechRate,
            'speechPitch': speechPitch,
            'language': 'en-US',
            'isEnabled': true,
            'speechRepeatCount': speechRepeatCount,
            'showOverLockScreen': showOverLockScreen,
          },
        );
        if (success == true) {
          debugPrint('TASKLY Native spoken alarm scheduled for $id (repeats: $speechRepeatCount, lockscreen: $showOverLockScreen)');
          return true;
        }
      } catch (nativeError) {
        debugPrint(
          'TASKLY Native alarm schedule failed: $nativeError. Falling back to local notifications.',
        );
      }
    }

    // 2. Fallback / Test-environment engine: flutter_local_notifications
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

  /// Cancels a scheduled reminder by its ID in both native AlarmManager and notification plugin.
  Future<void> cancelReminder(String id) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _platformChannel.invokeMethod('cancelNativeAlarm', {'id': id});
      } catch (e) {
        debugPrint('TASKLY Native cancel error: $e');
      }
    }
    final notificationId = notificationIdFromUuid(id);
    await _notificationsPlugin.cancel(notificationId);
  }

  /// Stops ongoing native background speech if currently active.
  Future<void> stopNativeSpeech() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _platformChannel.invokeMethod('stopNativeSpeech');
      } catch (e) {
        debugPrint('TASKLY Stop native speech error: $e');
      }
    }
  }

  /// Sends the full-screen alarm activity to the background so the device
  /// returns smoothly to its previous or locked state.
  Future<void> dismissAlarmActivity() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _platformChannel.invokeMethod('dismissAlarmActivity');
      } catch (e) {
        debugPrint('TASKLY dismissAlarmActivity error: $e');
      }
    }
  }

  /// Reschedules an alarm for 10 minutes in the future.
  Future<DateTime> snoozeReminder({
    required String id,
    required String title,
    int snoozeMinutes = 10,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
    double speechRate = 1.0,
    double speechPitch = 1.0,
  }) async {
    final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final newMillis = await _platformChannel.invokeMethod<int>(
          'snoozeNativeAlarm',
          {'id': id, 'minutes': snoozeMinutes},
        );
        if (newMillis != null) {
          return DateTime.fromMillisecondsSinceEpoch(newMillis);
        }
      } catch (e) {
        debugPrint('TASKLY Native snooze error: $e');
      }
    }

    await scheduleReminder(
      id: id,
      title: title,
      scheduledAt: snoozeTime,
      customSpokenMessage: customSpokenMessage,
      voicePersonality: voicePersonality,
      speechRate: speechRate,
      speechPitch: speechPitch,
    );
    return snoozeTime;
  }
}
