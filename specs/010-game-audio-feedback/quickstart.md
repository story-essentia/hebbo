# Quickstart: Game Audio Feedback

This guide provides a rapid overview of how to integrate and test the audio feedback system.

## Setup Instructions

1. **Update pubspec.yaml**:
    ```yaml
    dependencies:
      just_audio: ^0.9.36
      audio_session: ^0.1.18

    flutter:
      assets:
        - sounds/underwater-ambience.mp3
        - sounds/level-up.mp3
        - sounds/session-complete.mp3
    ```

2. **Run Pub Get**:
    ```bash
    flutter pub get
    ```

## Integration Points

### `GameAudioNotifier`
- Located in `lib/providers/audio_provider.dart`.
- Uses `AudioPlayer` for ambience (loop mode) and a pool for sfx.
- Automatically handles focus request on initialization.

### `FlankerGameScreen`
- Wrap the main stack or use a listener to trigger sfx based on state changes.

## Testing Checklist

- [ ] Start Flanker: Verify ambience plays and external music stops.
- [ ] Level Up: Verify distinct sfx plays once.
- [ ] Session Complete: Verify distinct sfx plays at the very end.
- [ ] Pause: Verify ambience pauses.
- [ ] Exit: Verify all sound stops.
