# Tasks: Game Start Countdown

**Input**: Design documents from `/specs/012-game-start-countdown/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: State model updates and initial definitions

- [x] T001 [P] Add `isCountingDown` and `countdownValue` to `FlankerSessionState` in lib/state/flanker_session_state.dart
- [x] T002 [P] Add `isCountingDown` and `countdownValue` to `TaskSwitchState` in lib/state/task_switch_state.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core UI for the countdown overlay

- [x] T003 Create `GameCountdownOverlay` widget with "Electric Nocturne" styling and animations in lib/widgets/game_countdown_overlay.dart

---

## Phase 3: User Story 1 - Flanker Countdown (Priority: P1) 🎯 MVP

**Goal**: Implement countdown logic and UI for the Flanker game

**Independent Test**: Start a Flanker session and verify the 3-2-1 sequence appears before the first fish trial.

### Implementation for User Story 1

- [x] T004 [US1] Update `FlankerGameNotifier.startSession` to manage the countdown timer in lib/providers/flanker_game_provider.dart
- [x] T005 [US1] Integrate `GameCountdownOverlay` into `FlankerGameScreen` triggered by `isCountingDown` state in lib/screens/flanker_game_screen.dart

**Checkpoint**: Flanker game now has a functional pre-trial countdown.

---

## Phase 4: User Story 2 - Task Switching Countdown (Priority: P2)

**Goal**: Implement countdown logic and UI for the Task Switching game

**Independent Test**: Start a Task Switching session and verify the 3-2-1 sequence appears before the first number trial.

### Implementation for User Story 2

- [x] T006 [US2] Update `TaskSwitchGameNotifier.startSession` to manage the countdown timer in lib/providers/task_switch_provider.dart
- [x] T007 [US2] Integrate `GameCountdownOverlay` into `TaskSwitchScreen` triggered by `isCountingDown` state in lib/screens/task_switch_screen.dart

**Checkpoint**: Task Switching game now has a functional pre-trial countdown.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and refinement

- [x] T008 [P] Ensure countdown is cancelled if the screen is disposed before it finishes in both notifiers
- [x] T009 [P] Performance check: Ensure stimulus generation happens in the background during countdown so phase transition is under 100ms
- [x] T010 [P] Run quickstart.md validation across both games

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - blocks Phase 3 and 4.
- **Foundational (Phase 2)**: No dependencies - blocks Phase 3 and 4 integration.
- **User Story 1 (Phase 3)**: Depends on T001 and T003.
- **User Story 2 (Phase 4)**: Depends on T002 and T003.
- **Polish (Phase 5)**: Depends on Phase 3 and 4.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- Phase 3 and Phase 4 can run in parallel once Phase 1 and 2 are complete.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001, T003, T004, T005.
2. Validate Flanker countdown.

### Incremental Delivery

1. Foundation + Flanker (MVP).
2. Task Switching added next.
3. Polish and final refinements.
