import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/services/alarm_service.dart';

void main() {
  group('Alarm Calculation & Helper Tests', () {
    test('notificationIdFromUuid produces consistent positive 31-bit integer', () {
      const uuid1 = 'b45c71d6-857c-48be-85b4-d576a6b57913';
      const uuid2 = '98df4567-e89b-12d3-a456-426614174000';

      final id1 = AlarmService.notificationIdFromUuid(uuid1);
      final id1Repeat = AlarmService.notificationIdFromUuid(uuid1);
      final id2 = AlarmService.notificationIdFromUuid(uuid2);

      // Consistent for same UUID
      expect(id1, equals(id1Repeat));
      // Distinct for different UUIDs
      expect(id1, isNot(equals(id2)));
      // Fits within positive 31-bit integer for Android PendingIntent
      expect(id1, greaterThanOrEqualTo(0));
      expect(id1, lessThan(0x7FFFFFFF));
    });

    test('calculateRelativeDateTime accurately offsets from current time', () {
      final now = DateTime(2026, 11, 5, 10, 0);
      final after2Hours = AlarmService.calculateRelativeDateTime(
        durationMinutes: 120,
        fromTime: now,
      );

      expect(after2Hours, equals(DateTime(2026, 11, 5, 12, 0)));
    });

    test('generateSpokenMessage provides default friendly prompt when custom text is empty', () {
      final defaultPrompt = AlarmService.generateSpokenMessage(
        title: 'Study Flutter',
        customMessage: null,
      );

      expect(
        defaultPrompt,
        equals("Hey! It's time to Study Flutter. Let's get started!"),
      );
    });

    test('generateSpokenMessage preserves custom spoken message when provided', () {
      final custom = AlarmService.generateSpokenMessage(
        title: 'Study Flutter',
        customMessage: 'Flutter study session starting right now.',
      );

      expect(custom, equals('Flutter study session starting right now.'));
    });
  });
}
