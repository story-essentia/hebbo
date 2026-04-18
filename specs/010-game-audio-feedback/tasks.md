# Tasks: Game Audio Feedback

**Input**: Design documents from `/specs/010-game-audio-feedback/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Tests are OPTIONAL. I will include verification steps within the independent test criteria.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and asset registration

- [X] T001 Add `just_audio` and `audio_session` dependencies to `pubspec.yaml`
- [X] T002 Register `sounds/` audio assets in the `flutter.assets` section of `pubspec.yaml`
- [X] T003 Execute `flutter pub get` to install new dependencies

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core audio player infrastructure and system focus management

**⚠️ CRITICAL**: All audio playback depends on this provider and the exclusive focus logic.

- [X] T004 Create `GameAudioNotifier` provider in `lib/providers/audio_provider.dart`
- [X] T005 Implement `AudioSession` configuration to request exclusive focus (Solo Mode) in `lib/providers/audio_provider.dart`
- [X] T006 Implement basic `dispose()` logic to release audio resources in `lib/providers/audio_provider.dart`

**Checkpoint**: Foundation ready - audio engine can now be integrated into the game loop.

---

## Phase 3: User Story 1 - Immersive Audio Ambience (Priority: P1) 🎯 MVP

**Goal**: Seamless, looping underwater ambience during gameplay.

**Independent Test**: Start a Flanker session. Verify `underwater-ambience.mp3` starts playing immediately on loop and other apps' audio stops.

### Implementation for User Story 1

- [X] T007 [US1] Load `underwater-ambience.mp3` and configure `LoopMode.one` in `lib/providers/audio_provider.dart`
- [X] T008 [US1] Implement `playAmbience`, `pauseAmbience`, and `stopAmbience` methods in `lib/providers/audio_provider.dart`
- [X] T009 [US1] Integrate `GameAudioNotifier` into `lib/screens/flanker_game_screen.dart` to trigger ambience on session start/pause/resume
- [X] T010 [US1] Ensure total cleanup (stop audio + release focus) in `dispose()` of `lib/screens/flanker_game_screen.dart`

**Checkpoint**: At this point, the game has its primary ambient atmosphere and exclusive focus handling.

---

## Phase 4: User Story 2 - Mastery Audio Feedback (Priority: P2)

**Goal**: Satisfying audio feedback when gaining levels.

**Independent Test**: Play Flanker. Reach a new level (e.g., 2 -> 3). Verify `level-up.mp3` plays exactly once.

### Implementation for User Story 2

- [X] T011 [US2] Initialize a secondary player or sound pool for `level-up.mp3` in `lib/providers/audio_provider.dart`
- [X] T012 [US2] Implement `playLevelUp()` method in `lib/providers/audio_provider.dart`
- [X] T013 [US2] Add a listener in `lib/screens/flanker_game_screen.dart` to trigger `playLevelUp()` when the adaptive level increases

**Checkpoint**: Mastery signals are now audibly reinforced.

---

## Phase 5: User Story 3 - Session Completion Reward (Priority: P3)

**Goal**: Audio closure when the 75th trial is finished.

**Independent Test**: Complete a full session. Verify `session-complete.mp3` plays once the final trial ends.

### Implementation for User Story 3

- [X] T014 [US3] Load `session-complete.mp3` in `lib/providers/audio_provider.dart`
- [X] T015 [US3] Implement `playSessionComplete()` method in `lib/providers/audio_provider.dart`
- [X] T016 [US3] Update `_persistSession` logic in `lib/providers/flanker_game_provider.dart` to trigger completion audio

**Checkpoint**: All specified audio feedback loops are complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Quality assurance and volume normalization

- [X] T017 Normalize background ambience volume to -12dB in `lib/providers/audio_provider.dart`
- [ ] T018 [P] Verify silence fallback by temporarily renaming asset paths and checking for crash-free execution
- [ ] T019 Run validation against `quickstart.md` testing checklist
- [ ] T020 [P] Update `docs/audio_architecture.md` if necessary (N/A for MVP)

---

## Dependencies & Execution Order

### Phase Dependencies

1. **Setup (Phase 1)**: Must run first to fetch packages.
2. **Foundational (Phase 2)**: Depends on Phase 1. Blocks all US implementation.
3. **User Stories (Phase 3-5)**: All depend on Phase 2.
    - US1 (Ambience) should be implemented first as it handles the session-long lifecycle.
    - US2 and US3 can be worked on in parallel once US1 is scaffolded.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and 2.
2. Complete US1 (Immersive Ambience).
3. **STOP and VALIDATE**: Verify immersion and exclusive Focus works.

### Incremental Delivery

1. Foundation + US1 -> **V1: Ambient Game**
2. Add US2 -> **V2: Audio Mastery Signals**
3. Add US3 -> **V3: Complete Reward Loop**
