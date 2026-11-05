import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../services/tts_service.dart';
import '../data/voice_preference_repository.dart';
import '../domain/voice_personality.dart';
import 'widgets/voice_preview_card.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

class VoiceSettingsScreen extends ConsumerStatefulWidget {
  const VoiceSettingsScreen({super.key});

  @override
  ConsumerState<VoiceSettingsScreen> createState() =>
      _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends ConsumerState<VoiceSettingsScreen> {
  VoicePersonality _defaultPersonality = VoicePersonality.nova;
  double _speechRate = 0.5;
  double _speechPitch = 1.0;
  String _selectedLanguage = 'en-US';
  String? _selectedVoiceName;
  String? _currentlyPreviewingId;

  List<Map<String, String>> _installedVoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferencesAndVoices();
  }

  Future<void> _loadPreferencesAndVoices() async {
    final repo = ref.read(voicePreferenceRepositoryProvider);
    final tts = ref.read(ttsServiceProvider);

    final defaultP = await repo.getDefaultPersonality();
    final rate = await repo.getSpeechRate();
    final pitch = await repo.getSpeechPitch();
    final lang = await repo.getLanguage();
    final voiceName = await repo.getSelectedVoiceName();

    final voices = await tts.getInstalledVoices();

    if (mounted) {
      setState(() {
        _defaultPersonality = defaultP;
        _speechRate = rate;
        _speechPitch = pitch;
        _selectedLanguage = lang;
        _selectedVoiceName = voiceName;
        _installedVoices = voices;
        _isLoading = false;
      });
    }
  }

  Future<void> _onPreview(VoicePersonality personality) async {
    final tts = ref.read(ttsServiceProvider);

    if (_currentlyPreviewingId == personality.id) {
      await tts.stop();
      setState(() => _currentlyPreviewingId = null);
    } else {
      setState(() => _currentlyPreviewingId = personality.id);
      tts.onPlayingStateChanged = (isPlaying) {
        if (!isPlaying && mounted) {
          setState(() => _currentlyPreviewingId = null);
        }
      };

      await tts.speak(
        text: personality.previewQuote,
        personality: personality,
        customRate: _speechRate,
        customPitch: _speechPitch,
        voiceName: _selectedVoiceName,
        language: _selectedLanguage,
      );
    }
  }

  Future<void> _onSetDefault(VoicePersonality personality) async {
    final repo = ref.read(voicePreferenceRepositoryProvider);
    await repo.setDefaultPersonality(personality.id);
    setState(() => _defaultPersonality = personality);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${personality.name} is now your default voice personality',
          ),
          backgroundColor: personality.signatureColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Personalities & TTS')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.indigoLight.withValues(
                      alpha: isDark ? 0.15 : 0.08,
                    ),
                    borderRadius: AppRadius.roundedLg,
                    border: Border.all(
                      color: AppColors.indigoLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        color: AppColors.indigoLight,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          '100% Offline Device TTS. Voice synthesis runs locally on your phone with zero AI APIs or cloud costs.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Predefined Personalities Section
                Text(
                  'PREDEFINED VOICE PERSONALITIES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.indigoLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...VoicePersonality.all.map((p) {
                  return VoicePreviewCard(
                    personality: p,
                    isDefault: _defaultPersonality.id == p.id,
                    isPlaying: _currentlyPreviewingId == p.id,
                    onPreview: () => _onPreview(p),
                    onSetDefault: () => _onSetDefault(p),
                  );
                }),
                const SizedBox(height: AppSpacing.lg),

                // Speech Customization Sliders
                Text(
                  'SPEECH TUNING & HARDWARE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.indigoLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Speech Rate Slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Speech Rate',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              '${_speechRate.toStringAsFixed(2)}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.indigoLight,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _speechRate,
                          min: 0.2,
                          max: 1.0,
                          divisions: 16,
                          onChanged: (val) {
                            setState(() => _speechRate = val);
                            ref
                                .read(voicePreferenceRepositoryProvider)
                                .setSpeechRate(val);
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Speech Pitch Slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Speech Pitch',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              '${_speechPitch.toStringAsFixed(2)}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.indigoLight,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _speechPitch,
                          min: 0.5,
                          max: 1.5,
                          divisions: 20,
                          onChanged: (val) {
                            setState(() => _speechPitch = val);
                            ref
                                .read(voicePreferenceRepositoryProvider)
                                .setSpeechPitch(val);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Dynamic Installed Voices
                        Text(
                          'Installed Device Engine Voices',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _installedVoices.isEmpty
                              ? 'Using default Android system voice. Additional voice packs can be downloaded in Android Settings.'
                              : '${_installedVoices.length} native voices detected on your device.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        if (_installedVoices.isNotEmpty)
                          DropdownButtonFormField<String?>(
                            initialValue: _selectedVoiceName,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Active Engine Voice',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('Device Default Voice'),
                              ),
                              ..._installedVoices.take(15).map((v) {
                                return DropdownMenuItem<String?>(
                                  value: v['name'],
                                  child: Text(
                                    '${v['name']} (${v['locale']})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: (val) {
                              setState(() => _selectedVoiceName = val);
                              ref
                                  .read(voicePreferenceRepositoryProvider)
                                  .setSelectedVoiceName(val);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
    );
  }
}
