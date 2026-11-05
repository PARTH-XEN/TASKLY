import 'package:flutter_tts/flutter_tts.dart';

import '../features/voice/domain/voice_personality.dart';

/// Service managing on-device Text-to-Speech synthesis and voice discovery.
class TtsService {
  final FlutterTts _flutterTts;
  bool _isPlaying = false;
  void Function(bool isPlaying)? onPlayingStateChanged;

  TtsService([FlutterTts? tts]) : _flutterTts = tts ?? FlutterTts() {
    _initHandlers();
  }

  bool get isPlaying => _isPlaying;

  void _initHandlers() {
    _flutterTts.setStartHandler(() {
      _isPlaying = true;
      onPlayingStateChanged?.call(true);
    });

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      onPlayingStateChanged?.call(false);
    });

    _flutterTts.setCancelHandler(() {
      _isPlaying = false;
      onPlayingStateChanged?.call(false);
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
      onPlayingStateChanged?.call(false);
    });
  }

  /// Speaks text aloud using device TTS engine.
  Future<void> speak({
    required String text,
    VoicePersonality personality = VoicePersonality.nova,
    double? customRate,
    double? customPitch,
    String? voiceName,
    String language = 'en-US',
  }) async {
    try {
      await _flutterTts.stop();

      final rate = customRate ?? personality.defaultRate;
      final pitch = customPitch ?? personality.defaultPitch;

      await _flutterTts.setLanguage(language);
      await _flutterTts.setSpeechRate(rate);
      await _flutterTts.setPitch(pitch);

      if (voiceName != null && voiceName.isNotEmpty) {
        await _flutterTts.setVoice({'name': voiceName, 'locale': language});
      }

      await _flutterTts.speak(text);
    } catch (_) {
      _isPlaying = false;
      onPlayingStateChanged?.call(false);
    }
  }

  /// Previews a voice personality using its signature preview quote.
  Future<void> previewPersonality(VoicePersonality personality) async {
    await speak(text: personality.previewQuote, personality: personality);
  }

  /// Immediately stops any active spoken audio.
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
      onPlayingStateChanged?.call(false);
    } catch (_) {}
  }

  /// Retrieves dynamically installed TTS voices from device.
  Future<List<Map<String, String>>> getInstalledVoices() async {
    try {
      final dynamic voices = await _flutterTts.getVoices;
      if (voices is List) {
        return voices
            .whereType<Map>()
            .map(
              (v) => {
                'name': v['name']?.toString() ?? '',
                'locale': v['locale']?.toString() ?? '',
              },
            )
            .where((v) => v['name']!.isNotEmpty)
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Retrieves dynamically supported languages.
  Future<List<String>> getLanguages() async {
    try {
      final dynamic languages = await _flutterTts.getLanguages;
      if (languages is List) {
        return languages.map((l) => l.toString()).toList();
      }
      return ['en-US'];
    } catch (_) {
      return ['en-US'];
    }
  }
}
