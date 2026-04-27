# Tasks: Spatial Span Game Milestone 1

**Input**: Design documents from `/specs/013-spatial-span-game/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initial project setup for the new game module

- [x] T001 Initialize game entry point and navigation route in lib/screens/home_screen.dart
- [x] T002 Configure base layout for lib/screens/spatial_span_screen.dart with deep purple background

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data structures and basic visual components

- [x] T003 [P] Define `SpatialSpanState` and `GamePhase` enum in lib/state/spatial_span_state.dart
- [x] T004 Implement `ShardPainter` with pentagon/hexagon geometry and radial gradients in lib/widgets/shard_painter.dart
- [x] T005 [P] Setup base `ShardWidget` with simple visibility states in lib/widgets/shard_widget.dart

---

## Phase 3: User Story 1 - Shard Visualization & Interaction (Priority: P1) 🎯 MVP

**Goal**: Deliver a premium, animated interactive component

**Independent Test**: Render the ShardWidget in a test screen and verify the pulse and ring animation trigger correctly.

### Implementation for User Story 1

- [x] T006 [US1] Implement 1.2x scale pulse animation using `AnimationController` in lib/widgets/shard_widget.dart
- [x] T007 [US1] Create "Ring Emission" effect using a separate `CustomPainter` or animated opacity ring in lib/widgets/shard_widget.dart
- [x] T008 [US1] Apply `MaskFilter.blur` to the shard paint for the soft neon glow in lib/widgets/shard_painter.dart
- [x] T009 [US1] Integrate `GestureDetector` with the pulse trigger in lib/widgets/shard_widget.dart

**Checkpoint**: Shard component feels physical and interactive.

---

## Phase 4: User Story 2 - Forward Recall Gameplay (Priority: P1)

**Goal**: Implement the core cognitive training loop

**Independent Test**: Start a trial at Span 3, observe the sequence, and tap correctly to advance.

### Implementation for User Story 2

- [x] T010 [US2] Implement randomized shard placement logic (3x3 grid) in lib/widgets/spatial_span_grid.dart
- [x] T011 [US2] Create sequence demonstration timer (1000ms intervals) in lib/providers/spatial_span_provider.dart
- [x] T012 [US2] Implement recall phase input validation logic in lib/providers/spatial_span_provider.dart
- [x] T013 [US2] Connect `SpatialSpanGrid` to the game provider state for synchronizing pulses and recall status

**Checkpoint**: Core Corsi task loop is functional.

---

## Phase 5: User Story 3 - Adaptive Span Advancement (Priority: P2)

**Goal**: Implement clinical precision in difficulty scaling

**Independent Test**: Complete 2 trials at the current span and verify the sequence length increases.

### Implementation for User Story 3

- [x] T014 [US3] Implement "2-out-of-3" master/fail logic in lib/providers/spatial_span_provider.dart
- [x] T015 [US3] Integrate session persistence to ITrialRepository and ISessionRepository in lib/providers/spatial_span_provider.dart

**Checkpoint**: Game difficulty adapts correctly to user performance.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final aesthetics and validation

- [x] T016 [P] Add drifting neon particle background to lib/screens/spatial_span_screen.dart
- [x] T017 [P] Calibrate CustomPainter performance by adding `RepaintBoundary` around high-blur elements
- [x] T018 Run quickstart.md validation to confirm all Milestone 1 goals are met

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Phase 1 - blocks all User Stories.
- **User Story 1 (Phase 3)**: Depends on Phase 2.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and US1 components.
- **User Story 3 (Phase 5)**: Depends on US2 completion.
- **Polish (Phase 6)**: Depends on US2 completion.

---

## Implementation Strategy

### MVP First (User Story 1 & 2)

1. Complete Setup and Foundational tasks.
2. Deliver the Shard component (US1).
3. Deliver the core recall loop (US2).
4. **STOP and VALIDATE**: Verify the core game is playable before adding adaptive logic.

### Incremental Delivery

1. Foundation + Shard Component.
2. Recall Loop (Forward/Static).
3. Adaptive Engine (2-out-of-3).
4. Visual Polish (Particles/Glows).
