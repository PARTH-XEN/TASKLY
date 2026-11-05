import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../domain/voice_personality.dart';

final voicePreferenceRepositoryProvider = Provider<VoicePreferenceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return VoicePreferenceRepository(db);
});

class VoicePreferenceRepository {
  final AppDatabase _db;

  VoicePreferenceRepository(this._db);

  static const String keyDefaultPersonality = 'default_voice_personality';
  static const String keySpeechRate = 'speech_rate';
  static const String keySpeechPitch = 'speech_pitch';
  static const String keyLanguage = 'selected_language';
  static const String keyVoiceName = 'selected_voice_name';

  Future<String?> _getSetting(String key) async {
    final entry = await (_db.select(_db.appSettings)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    return entry?.value;
  }

  Future<void> _setSetting(String key, String value) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<VoicePersonality> getDefaultPersonality() async {
    final id = await _getSetting(keyDefaultPersonality);
    return VoicePersonality.fromId(id);
  }

  Future<void> setDefaultPersonality(String personalityId) async {
    await _setSetting(keyDefaultPersonality, personalityId.toLowerCase());
  }

  Future<double> getSpeechRate() async {
    final value = await _getSetting(keySpeechRate);
    if (value != null) {
      return double.tryParse(value) ?? 0.5;
    }
    return 0.5;
  }

  Future<void> setSpeechRate(double rate) async {
    await _setSetting(keySpeechRate, rate.toString());
  }

  Future<double> getSpeechPitch() async {
    final value = await _getSetting(keySpeechPitch);
    if (value != null) {
      return double.tryParse(value) ?? 1.0;
    }
    return 1.0;
  }

  Future<void> setSpeechPitch(double pitch) async {
    await _setSetting(keySpeechPitch, pitch.toString());
  }

  Future<String> getLanguage() async {
    final value = await _getSetting(keyLanguage);
    return value ?? 'en-US';
  }

  Future<void> setLanguage(String language) async {
    await _setSetting(keyLanguage, language);
  }

  Future<String?> getSelectedVoiceName() async {
    return _getSetting(keyVoiceName);
  }

  Future<void> setSelectedVoiceName(String? voiceName) async {
    if (voiceName == null) {
      await (_db.delete(_db.appSettings)..where((tbl) => tbl.key.equals(keyVoiceName))).go();
    } else {
      await _setSetting(keyVoiceName, voiceName);
    }
  }
}
