import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/services/alarm_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Native Alarm & Background Speech Engine Tests', () {
    test('notificationIdFromUuid produces consistent positive 31-bit integer', () {
      const uuid1 = 'd83c270e-3b2a-4318-8f8f-c30076a59ec1';
      const uuid2 = '987fcdeb-51a2-4321-ba98-76543210fedc';

      final id1 = AlarmService.notificationIdFromUuid(uuid1);
      final id2 = AlarmService.notificationIdFromUuid(uuid2);

      expect(id1, isPositive);
      expect(id2, isPositive);
      expect(id1, lessThanOrEqualTo(0x7FFFFFFF));
      expect(id2, lessThanOrEqualTo(0x7FFFFFFF));
      expect(id1, equals(AlarmService.notificationIdFromUuid(uuid1)));
      expect(id1, isNot(equals(id2)));
    });

    test('generateSpokenMessage formats default prompt with title', () {
      final msg = AlarmService.generateSpokenMessage(
        title: 'Complete mathematics homework',
      );
      expect(
        msg,
        equals("Hey! It's time to Complete mathematics homework. Let's get started!"),
      );
    });

    test('generateSpokenMessage uses custom message verbatim when provided', () {
      final msg = AlarmService.generateSpokenMessage(
        title: 'Study Physics',
        customMessage: "It's time to complete your physics problems now.",
      );
      expect(msg, equals("It's time to complete your physics problems now."));
    });

    test('calculateRelativeDateTime offsets accurately from base time', () {
      final base = DateTime(2026, 11, 5, 10, 0, 0);
      final target = AlarmService.calculateRelativeDateTime(
        durationMinutes: 15,
        fromTime: base,
      );
      expect(target, equals(DateTime(2026, 11, 5, 10, 15, 0)));
    });

    test('snoozeReminder schedules for 10 minutes by default', () async {
      final alarmService = AlarmService();
      final scheduledTime = await alarmService.snoozeReminder(
        id: 'snooze_test_1',
        title: 'Call Doctor',
        snoozeMinutes: 10,
      );

      final diff = scheduledTime.difference(DateTime.now()).inMinutes;
      expect(diff, inInclusiveRange(9, 10));
    });
  });
}
