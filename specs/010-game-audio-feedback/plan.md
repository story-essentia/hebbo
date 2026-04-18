# Implementation Plan: Game Audio Feedback

This plan outlines the design and integration of audio feedback (ambience, level-up, and completion sounds) for the Flanker game session.

**Feature ID**: 010-game-audio-feedback
**Status**: Planning
**Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/010-game-audio-feedback/spec.md)

## Technical Context

### Existing Architecture
- **Framework**: Flutter.
- **State Management**: Riverpod (`StateNotifierProvider`).
- **Game Screen**: `FlankerGameScreen` (ConsumerStatefulWidget).
- **Game Logic**: `FlankerGameNotifier` manages session states (`isResetting`, `isSessionComplete`).
- **Difficulty Logic**: `AdaptiveEngineNotifier` manages level changes.

### Dependencies
- **Research Needed**: Need to select a robust Flutter audio library (likely `audioplayers`).
- **Audio Focus**: Research required for obtaining exclusive audio focus (Solo mode) on Android/iOS.
- **File Assets**: `underwater-ambience.mp3`, `level-up.mp3`, `session-complete.mp3` located in `sounds/`.

### Constraints
- Must play audio offline.
- Low latency (<150ms) for feedback sounds.
- Seamless looping for ambience.

---

## Constitution Check

| Principle | Evaluation |
|-----------|------------|
| I. Scientific Honesty | Audio is purely aesthetic/feedback and makes no cognitive claims. Compliant. |
| II. Privacy by Default | All audio is processed locally. No data leaves the device. Compliant. |
| III. Design First | Audio feedback is a primary tool for "retention and delight". Compliant. |
| V. Community | Initial audio implementation should be modular enough to be reusable by future games. Compliant. |
| VI. Scope Discipline | Adding audio feedback to the training loop is within the "delight" design goals. Compliant. |

---

## Phase 0: Research

- [ ] [R01] Research the best Flutter audio library for gapless looping and low-latency effects.
- [ ] [R02] Research implementation of exclusive audio focus (Solo mode) to interrupt other media.
- [ ] [R03] Identify performance impact of concurrent playback of loops (bgm) and effects (sfx).

**Goal**: resolve all NEEDS CLARIFICATION by producing `research.md`.

---

## Phase 1: Foundation & Contracts

### Data Model updates
- No changes to PERSISTENT database fields requested.
- State updates for "Audio Ready" or volume levels might be needed in memory.

### Quickstart / Integration
- Update `pubspec.yaml` to include the `sounds/` directory.

---

## Phase 2: Design

### Components
1. **`GameAudioNotifier`**: A Riverpod provider to manage audio playback.
2. **`SoloFocusManager`**: Logic to handle exclusive audio focus for the session duration.
3. **`FlankerAudioIntegration`**: Update `FlankerGameScreen` to listen to game state changes and trigger audio effects.

### Data Flow
1. `FlankerGameScreen` watches `level` and `isSessionComplete`.
2. On change, it signals `GameAudioNotifier` to play `level-up.mp3` or `session-complete.mp3`.
3. `GameAudioNotifier` manages the active instances of `AudioPlayer`.

---

## Risks

- **Resource Leaks**: `AudioPlayer` instances must be strictly disposed when the session ends.
- **Asset Paths**: Ensure correct relative paths in `pubspec.yaml` vs filesystem.
- **OS Focus Rules**: Variation in how Android vs iOS handle audio focus requests.

---

## Gate Checklist

- [ ] Audio assets are confirmed present in the `sounds/` directory.
- [ ] Selected audio library supports gapless looping.
- [ ] Exclusive focus logic is verified for both mobile platforms.
