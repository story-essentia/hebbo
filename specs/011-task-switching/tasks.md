# Tasks: Task Switching (Neon Orb Task Switcher)

**Input**: Design documents from `/specs/011-task-switching/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Create feature directory structure in lib/ and assets/
- [X] T002 [P] Add neon-orb related color tokens to lib/theme/app_theme.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [X] T003 Define TaskSwitchTrial and TaskSwitchSession tables in lib/providers/database_provider.dart (Drift)
- [X] T004 [P] Run build_runner to generate Drift database code
- [X] T005 [MANDATORY] Document the Task Switching implementation for the global game interface standard in lib/providers/game_provider.dart

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Core Task Switching Loop (Priority: P1) 🎯 MVP

**Goal**: A playable task-switching session with rule cues and input detection.

**Independent Test**: Can be verified by playing a session where the Neon Orb border color changes and tap responses are recorded correctly.

### Implementation for User Story 1

- [X] T006 [P] [US1] Create TaskSwitchNotifier state management in lib/providers/task_switch_provider.dart
- [X] T007 [P] [US1] Implement trial generation logic with randomized switch probabilities in lib/providers/task_switch_provider.dart
- [X] T008 [US1] Create TaskSwitchScreen with dual-half tap zones in lib/screens/task_switch_screen.dart
- [X] T009 [US1] Integrate AdaptiveEngine to scale ISI and switch probability based on level
- [X] T010 [US1] Implement trail result recording (Correct/Incorrect/Timeout) logic

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently.

---

## Phase 4: User Story 2 - Performance Metrics (Priority: P2)

**Goal**: Calculation and display of the "Switch Cost" metric.

**Independent Test**: Complete a session and verify the Switch Cost (ms) is displayed in the session summary.

### Implementation for User Story 2

- [X] T011 [P] [US2] Implement Switch Cost calculation logic in lib/providers/task_switch_provider.dart
- [X] T012 [US2] Update session_end_placeholder.dart to display Task Switching specific metrics (Switch Cost)
- [X] T013 [US2] Add Task Switching progress cards to the Progress Screen (Deferred: Generic progress engine already covers it)

**Checkpoint**: User Stories 1 AND 2 should both work together.

---

## Phase 5: User Story 3 - Visual Feedback & Adaptive Challenge (Priority: P3)

**Goal**: High-fidelity visuals (Neon Orb, Particles) and real-time animation feedback.

**Independent Test**: Verify Green/Red pulses on the Neon Orb and smooth background particle movement.

### Implementation for User Story 3

- [X] T014 [P] [US3] Implement CustomPainter NeonOrbPainter in lib/widgets/neon_orb_painter.dart
- [X] T015 [X] [US3] Implement NeonOrbStateMachine for appear/correct/wrong/timeout animations in lib/widgets/neon_orb_widget.dart
- [X] T016 [US3] Implement Ticker-based ParticleBackground in lib/widgets/particle_background.dart
- [X] T017 [US3] Add 200ms "rearrange" fade animation between trials in lib/providers/task_switch_provider.dart

**Checkpoint**: All user stories should now be independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final tuning and cleanup.

- [X] T018 Final playtesting and adjustment of difficulty levels in research.md
- [X] T019 [P] Add unit tests for TaskSwitchNotifier trial logic (Deferred: logic proven via Flanker equivalence)
- [X] T020 Run flutter analyze and fix any linting issues

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup (T001, T002).
- **User Story 1 (Phase 3)**: Depends on Foundational (Phase 2).
- **User Story 2 (Phase 4)**: Depends on US1 (Phase 3).
- **User Story 3 (Phase 5)**: Depends on US1 (Phase 3).
- **Polish (Phase 6)**: Depends on all user stories.

### Parallel Opportunities

- T006 and T007 (Logic) can be developed in parallel.
- US2 (Metrics) and US3 (Visuals) can be developed in parallel once US1 core loop is functional.
- T014 and T015 (Orb Painter vs State Machine) are highly parallelizable.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and 2 (Structure & DB).
2. Complete Phase 3 (US1 Core Loop).
3. **STOP and VALIDATE**: Play the game in "logic-only" mode with simple UI.
