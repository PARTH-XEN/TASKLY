import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/core/database/database_provider.dart';
import 'package:taskly/features/voice/domain/voice_personality.dart';
import 'package:taskly/features/voice/presentation/voice_settings_screen.dart';
import 'package:taskly/services/tts_service.dart';

class FakeTtsService extends TtsService {
  @override
  Future<List<Map<String, String>>> getInstalledVoices() async => [
        {'name': 'en-us-x-sfg#female_1-local', 'locale': 'en-US'},
      ];

  @override
  Future<List<String>> getLanguages() async => ['en-US', 'en-GB'];

  @override
  Future<void> speak({
    required String text,
    VoicePersonality personality = VoicePersonality.nova,
    double? customRate,
    double? customPitch,
    String? voiceName,
    String language = 'en-US',
  }) async {}

  @override
  Future<void> stop() async {}
}

void main() {
  testWidgets('VoiceSettingsScreen displays 4 personalities, preview triggers, and tuning sliders',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => testDb.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          ttsServiceProvider.overrideWithValue(FakeTtsService()),
        ],
        child: const MaterialApp(
          home: VoiceSettingsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Title
    expect(find.text('Voice Personalities & TTS'), findsOneWidget);

    // Verify all 4 Voice Personalities
    expect(find.text('Nova'), findsOneWidget);
    expect(find.text('Max'), findsOneWidget);
    expect(find.text('Atlas'), findsOneWidget);
    expect(find.text('Echo'), findsOneWidget);

    // Verify Default badge on Nova
    expect(find.text('DEFAULT'), findsOneWidget);

    // Verify Preview Voice buttons
    expect(find.text('Preview Voice'), findsWidgets);

    // Scroll to reveal speech tuning sliders
    await tester.scrollUntilVisible(find.text('Speech Rate'), 300);
    expect(find.text('Speech Rate'), findsOneWidget);
    expect(find.text('Speech Pitch'), findsOneWidget);
  });
}
