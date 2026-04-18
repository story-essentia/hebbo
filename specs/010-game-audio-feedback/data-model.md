# Data Model: Game Audio Feedback

This document describes the in-memory state and configurations for the audio feedback system.

## Entities (In-Memory)

### GameAudioState
Represents the current status of the audio engine during a session.

| Field | Type | Description |
|-------|------|-------------|
| isAmbiencePlaying | bool | True if the background loop is active. |
| isMuted | bool | User preference for sound (fetched from global settings). |
| currentSessionFocus | bool | True if the app has successfully claimed exclusive audio focus. |

## Lifecycle Transitions

1. **Session Start**: 
    - Request exclusive audio focus via `audio_session`.
    - Signal: Success → Initialize and play `underwater-ambience.mp3`.
2. **Trial Loop**:
    - Listen to `AdaptiveEngineState.currentLevel`.
    - If level increments → Trigger `level-up.mp3`.
3. **Session End**:
    - Trigger `session-complete.mp3`.
    - Release audio focus to the system.
    - Stop all playback instances.
