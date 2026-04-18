# Research: Game Audio Feedback

This document outlines the research findings and technical decisions for adding audio feedback to Hebbo.

## Decision: `just_audio` + `audio_session`

- **Choice**: Use the `just_audio` package for playback and `audio_session` for managing audio focus.
- **Rationale**:
    - **Gapless Looping**: `just_audio` provides first-class support for gapless loops via `LoopMode.one`, which is critical for the `underwater-ambience.mp3`.
    - **Audio Session Management**: `audio_session` allows the app to request exclusive audio focus (Solo mode), which satisfies the requirement to stop other media when the game begins.
    - **Architecture**: Supports concurrent playback of multiple audio sources (ambience on one instance, sound effects on others).
    - **Reliability**: More robust than `audioplayers` for long-running ambient loops and precise state control.

## Decision: Audio Focus Strategy (Solo Mode)

- **Execution**: Use `audio_session` to intercept the system audio focus.
- **Configuration**:
    - Set the session to `AudioSessionConfiguration.speech()` or `music()` with `avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.interruptSpokenAudioAndMixWithOthers`? No, the requirement is **Solo**.
    - For Solo mode, we will use a configuration that requests exclusive focus (interrupting others).
    - On Android, this involves the `AUDIOFOCUS_GAIN` request.

## Alternatives Considered

### `audioplayers`
- **Pros**: Very easy to use for simple sfx.
- **Cons**: Gapless looping is notoriously difficult and often results in clicking sounds on mobile. Limited built-in support for advanced `audio_session` management.

### `flutter_soloud`
- **Pros**: Extreme low latency, designed for games.
- **Cons**: Might be overkill for a cognitive training app that only uses 3 sounds. C++ bindings add some build complexity.

---

## Technical Tasks (Phase 0)

1. **Dependency Analysis**: Add `just_audio: ^0.9.x` and `audio_session: ^0.1.x` to `pubspec.yaml`.
2. **Asset Registration**: Add `sounds/` folder to the `assets` section of `pubspec.yaml`.
3. **Session Setup**: Initialize `AudioSession` in the `GameAudioNotifier` to handle focus request/release.
