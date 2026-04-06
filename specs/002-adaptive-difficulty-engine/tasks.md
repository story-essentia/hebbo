# Tasks: Adaptive Difficulty Engine

**Input**: Design documents from `/specs/002-adaptive-difficulty-engine/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: This milestone is verified strictly through automated unit tests.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of the core logic engine.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files/directories)
- **[Story]**: Which user story this task belongs to (e.g., US1)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `test/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 [P] Ensure `flutter_riverpod` and `riverpod_annotation` are in `pubspec.yaml`
- [X] T002 [P] Create directory structure: `lib/state/`, `lib/providers/`, `test/providers/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before the adaptive logic can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] Create immutable state class `AdaptiveDifficultyState` in `lib/state/adaptive_difficulty_state.dart` with `currentLevel`, `upWindow`, and `downWindow`
- [X] T004 [P] Mark `DifficultyRepository` as a dependency in the provider initialization plan

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Adaptive Engine Logic (Priority: P1) 🎯 MVP

**Goal**: Implement the core StateNotifier logic that handles rolling windows and level adjustments.

**Independent Test**: All unit tests in `test/providers/adaptive_engine_test.dart` pass.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T005 [US1] Create unit test suite in `test/providers/adaptive_engine_test.dart` covering 20-correct level up, 10-incorrect level down, boundary levels (1 and 10), and "Slate Reset" confirmation

### Implementation for User Story 1

- [X] T006 [US1] Implement `AdaptiveEngineNotifier` skeleton in `lib/providers/adaptive_engine_provider.dart` with `reportTrial(bool correct)` method
- [X] T007 [US1] Implement rolling window logic (trimming to 20/10 entries) and accuracy calculation in `reportTrial`
- [X] T008 [US1] Implement level-up logic (80% accuracy over 20 trials) and Slate Reset
- [X] T009 [US1] Implement level-down logic (< 60% accuracy over 10 trials, triggered only on failure) and Slate Reset
- [X] T010 [US1] Integrate `DifficultyRepository` to load initial level and save level on session end

**Checkpoint**: At this point, the Adaptive Difficulty Engine should be fully functional and passing all unit tests.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Improvements and final validation

- [X] T011 Run `flutter analyze` and resolve all warnings/errors
- [X] T012 [P] Verify SC-002: Ensure `reportTrial` logic handles updates efficiently without complex iterations
- [X] T013 Update `quickstart.md` with final test execution instructions if needed

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - starts immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational phase completion. 
- **Polish (Phase 4)**: Depends on User Story 1 completion.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T003 and T004 can run in parallel within Phase 2.

---

## Implementation Strategy

### MVP First (Core Engine)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL)
3. Complete Phase 3: User Story 1 (The core engine)
4. **STOP and VALIDATE**: Run all unit tests to ensure 100% logic coverage.

### Incremental Delivery

1. Foundation ready (State class)
2. Tests ready (failing)
3. Core logic ready (passing tests)
4. Persistence integrated (saved results)
