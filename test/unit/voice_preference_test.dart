import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/voice/data/voice_preference_repository.dart';

void main() {
  late AppDatabase database;
  late VoicePreferenceRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = VoicePreferenceRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('VoicePreferenceRepository Tests', () {
    test(
      'Default personality returns Nova initially, updates to Max',
      () async {
        final initial = await repository.getDefaultPersonality();
        expect(initial.id, equals('nova'));

        await repository.setDefaultPersonality('max');
        final updated = await repository.getDefaultPersonality();
        expect(updated.id, equals('max'));
        expect(updated.name, equals('Max'));
      },
    );

    test('Speech rate and pitch persist and update accurately', () async {
      expect(await repository.getSpeechRate(), equals(0.5));
      expect(await repository.getSpeechPitch(), equals(1.0));

      await repository.setSpeechRate(0.65);
      await repository.setSpeechPitch(1.20);

      expect(await repository.getSpeechRate(), equals(0.65));
      expect(await repository.getSpeechPitch(), equals(1.20));
    });

    test('Selected language and voice name persist and update', () async {
      expect(await repository.getLanguage(), equals('en-US'));
      expect(await repository.getSelectedVoiceName(), isNull);

      await repository.setLanguage('en-GB');
      await repository.setSelectedVoiceName('en-gb-x-rjs-network');

      expect(await repository.getLanguage(), equals('en-GB'));
      expect(
        await repository.getSelectedVoiceName(),
        equals('en-gb-x-rjs-network'),
      );
    });
  });
}
