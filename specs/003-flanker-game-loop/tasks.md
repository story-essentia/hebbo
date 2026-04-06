# Tasks: Flanker Game Loop

**Input**: Design documents from `/specs/003-flanker-game-loop/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Verification via unit tests for logic and manual testing for timing/UI.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of the core game loop.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files/directories)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `test/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 [P] Create directory structure: `lib/screens/`, `lib/providers/`, `lib/logic/`, `lib/state/`
- [X] T002 [P] Define `Side` and `FeedbackType` enums in `lib/logic/flanker_domain.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] Implement `FlankerTrialGenerator` in `lib/logic/flanker_trial_generator.dart` with Congruence/Incongruence ratio logic
- [X] T004 [P] Create immutable `FlankerSessionState` in `lib/state/flanker_session_state.dart` per data-model.md
- [X] T005 [P] Create base logic unit tests in `test/logic/flanker_game_test.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Core Playing Experience (Priority: P1) 🎯 MVP

**Goal**: A playable game loop with placeholder visuals and responsive tap zones.

**Independent Test**: User can complete a trial and see green/red feedback on the center rectangle.

### Implementation for User Story 1

- [X] T006 [P] [US1] Implement placeholder `FlankerGameScreen` in `lib/screens/flanker_game_screen.dart` with 5 rectangles
- [X] T007 [US1] Create `FlankerGameNotifier` in `lib/providers/flanker_game_provider.dart` for basic stimulus rotation
- [X] T008 [US1] Implement full-screen Left/Right tap zones in `FlankerGameScreen`
- [X] T009 [US1] Connect tap inputs to `FlankerGameNotifier.reportResponse()`
- [X] T010 [US1] Add basic visual feedback (flash center rectangle) in `FlankerGameScreen`

**Checkpoint**: At this point, User Story 1 should be fully functional as a basic game session without adaptive scaling.

---

## Phase 4: User Story 2 - Real-time Difficulty Adaptation (Priority: P1)

**Goal**: Link the game loop to the Adaptive Engine for dynamic challenge scaling.

**Independent Test**: Game speed (ISI) and Congruency ratio adjust as the level changes.

### Implementation for User Story 2

- [X] T011 [US2] Integrate `AdaptiveEngineNotifier` into `FlankerGameNotifier` to read current level
- [X] T012 [US2] Implement ISI (inter-stimulus interval) delay logic in `FlankerGameNotifier`
- [X] T013 [US2] Implement 2000ms Timeout logic in `FlankerGameNotifier`
- [X] T014 [US2] Implement millisecond Reaction Time (RT) measurement using `Stopwatch` in `FlankerGameNotifier`

**Checkpoint**: User Story 2 adds the "adaptive" part of the engine, visible through changing speeds and difficulty.

---

## Phase 5: User Story 3 - Persistence of Training Data (Priority: P1)

**Goal**: Ensure every trial and session is recorded correctly in the local database.

**Independent Test**: Exactly 75 trials and 1 session record appear in Drift after a successful session.

### Implementation for User Story 3

- [X] T015 [US3] Implement trial buffering logic within `FlankerGameNotifier` state
- [X] T016 [US3] Implement `persistSession` logic using `TrialRepository` and `SessionRepository` in `FlankerGameNotifier`
- [X] T017 [US3] Add completion check: trigger persistence only at trial 75

**Checkpoint**: All user stories are now functional and integrated.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements and final validation

- [X] T018 [P] Create `SessionEndPlaceholder` screen in `lib/screens/session_end_placeholder.dart`
- [X] T019 [P] Verify SC-004: Ensure aborted sessions do not write to the database
- [X] T020 [P] Update `quickstart.md` with final verification steps
- [X] T021 Run `flutter analyze` and resolve all warnings

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories.
- **User Stories (Phase 3-5)**: All depend on Foundational completion.
- **Polish (Phase 6)**: Depends on completion of all user stories.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Play a manual session to confirm tap zones and feedback work.

### Parallel Opportunities

- T001, T002, T003, T004, T005, and T006 can all be started in parallel as they touch different files.
- Once Foundational is done, UI (T006) and Logic (T007) for US1 can proceed together.
