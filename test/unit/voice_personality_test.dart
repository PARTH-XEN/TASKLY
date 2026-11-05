import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/voice/domain/voice_personality.dart';

void main() {
  group('Voice Personality Domain Model Tests', () {
    test(
      'All 4 predefined voice personalities exist with distinct IDs and traits',
      () {
        expect(VoicePersonality.all.length, equals(4));

        final ids = VoicePersonality.all.map((p) => p.id).toSet();
        expect(ids, equals({'nova', 'max', 'atlas', 'echo'}));

        for (final p in VoicePersonality.all) {
          expect(p.name, isNotEmpty);
          expect(p.trait, isNotEmpty);
          expect(p.description, isNotEmpty);
          expect(p.previewQuote, isNotEmpty);
          // Rates and pitches must be within standard audio ranges
          expect(p.defaultRate, inInclusiveRange(0.2, 1.0));
          expect(p.defaultPitch, inInclusiveRange(0.5, 1.5));
        }
      },
    );

    test(
      'fromId correctly matches case-insensitively and falls back to Nova',
      () {
        expect(VoicePersonality.fromId('MAX').id, equals('max'));
        expect(VoicePersonality.fromId('Atlas').id, equals('atlas'));
        expect(VoicePersonality.fromId('echo').id, equals('echo'));
        expect(VoicePersonality.fromId('unknown_voice').id, equals('nova'));
        expect(VoicePersonality.fromId(null).id, equals('nova'));
      },
    );

    test('Each voice has signature traits matching brand identity', () {
      expect(VoicePersonality.nova.name, equals('Nova'));
      expect(VoicePersonality.max.name, equals('Max'));
      expect(VoicePersonality.atlas.name, equals('Atlas'));
      expect(VoicePersonality.echo.name, equals('Echo'));

      expect(VoicePersonality.nova.defaultPitch, greaterThan(1.0));
      expect(VoicePersonality.atlas.defaultPitch, lessThan(1.0));
    });
  });
}
