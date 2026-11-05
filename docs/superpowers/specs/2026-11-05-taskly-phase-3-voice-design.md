# TASKLY — Phase 3: Voice Personality System & Device TTS Specification

## 1. Executive Summary

Phase 3 implements TASKLY's core audio identity:
> **Predefined Device TTS Voice Personalities (Nova, Max, Atlas, Echo) with Dynamic Installed Voice Discovery, Voice Preview, and Speech Customization.**

TASKLY strictly utilizes the device's native offline Text-to-Speech engine (`flutter_tts`). Zero paid AI voice models (ElevenLabs, OpenAI Voice, etc.) or cloud dependencies are utilized.

---

## 2. Voice Personalities Definition

Each personality is defined as a typed configuration with signature traits, default speech rate, default pitch, and localized sample previews:

| Personality | Style & Tone | Default Rate | Default Pitch | Sample Preview Prompt |
| :--- | :--- | :--- | :--- | :--- |
| **Nova** | Friendly, calm, encouraging | `0.48` | `1.05` | *"Hey! It's time to get started on your task. You've got this!"* |
| **Max** | Energetic, enthusiastic, motivating | `0.58` | `1.15` | *"Let's go! Time to crush your goals and get things done right now!"* |
| **Atlas** | Professional, clear, direct | `0.50` | `0.90` | *"Attention: your scheduled activity is due now. Commencing task."* |
| **Echo** | Simple, minimal, straightforward | `0.45` | `1.00` | *"Reminder: your task is ready."* |

---

## 3. Dynamic Device TTS Voice Discovery

Because Android device manufacturers (Samsung, Google, Xiaomi, OnePlus) bundle different TTS engines and voice sets:
1. `TtsService.getInstalledVoices()` queries `flutter_tts.getVoices` dynamically.
2. `TtsService.getLanguages()` queries available language codes (e.g. `en-US`, `en-GB`, `en-IN`).
3. If specific voice IDs are missing on a device, TASKLY gracefully falls back to the default system TTS voice and adjusts pitch & rate to mimic the personality profile.
4. Users can open Android TTS Settings directly from TASKLY to install additional high-quality voice packs.

---

## 4. Architecture & Services

```
lib/
├── features/
│   └── voice/
│       ├── domain/
│       │   └── voice_personality.dart   # Model with rate, pitch, traits, preview quotes
│       ├── presentation/
│       │   ├── voice_settings_screen.dart # Voice discovery, test audio player, rate/pitch sliders
│       │   └── widgets/
│       │       └── voice_preview_card.dart # Live TTS playback preview card
│       └── data/
│           └── voice_preference_repository.dart # Persist default personality & custom rates in Drift
└── services/
    └── tts_service.dart                 # FlutterTTS engine wrapper with speak, stop, preview
```

---

## 5. Alarm Screen & Reminder Integration

- In `AlarmScreen`: When the alarm activates, `TtsService.speak(...)` automatically speaks the reminder title and custom message using the selected voice personality.
- In `CreateReminderSheet`: Users can tap a "Preview" icon next to each personality chip to immediately audition the voice output.
