# Tasks: Dynamic Level-Based Environments

**Input**: Design documents from `/specs/009-dynamic-environments/`
**Prerequisites**: [plan.md](file:///home/samuelmorse/Projects/hebbo/specs/009-dynamic-environments/plan.md), [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/009-dynamic-environments/spec.md), [research.md](file:///home/samuelmorse/Projects/hebbo/specs/009-dynamic-environments/research.md), [data-model.md](file:///home/samuelmorse/Projects/hebbo/specs/009-dynamic-environments/data-model.md)

**Tests**: Widget tests for painter logic and environment swapping logic.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Create project structure `lib/widgets/backgrounds/` per implementation plan
- [X] T002 Update `pubspec.yaml` to verify all assets and dependencies are ready

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure for parallax drawing and speed control

- [X] T003 Implement `BaseParallaxPainter` with infinite wrapping logic in `lib/widgets/backgrounds/base_parallax_painter.dart`
- [X] T004 Define `EnvironmentOrchestrator` to manage speed multipliers and sync with `AnimationController` in `lib/widgets/backgrounds/environment_orchestrator.dart`
- [X] T005 [P] Create level-to-environment mapping logic (FR-001) in `lib/widgets/backgrounds/environment_factory.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Environment Progression (Priority: P1) 🎯 MVP

**Goal**: Deliver the basic background swap logic for all three depth levels.

**Independent Test**: Can be verified by changing the game level and confirming the background widget and colors update correctly (Shallow → Open → Deep).

### Tests for User Story 1

- [ ] T006 [P] [US1] Unit test for environment selection logic in `test/widgets/environment_selection_test.dart`
- [ ] T007 [P] [US1] Widget test for background widget swapping in `test/widgets/flanker_background_swap_test.dart`

### Implementation for User Story 1

- [X] T008 [P] [US1] Implement `ShallowReefBackground` (FR-002) with teal gradient in `lib/widgets/backgrounds/shallow_reef_background.dart`
- [X] T009 [P] [US1] Implement `OpenOceanBackground` (FR-003) with blue gradient in `lib/widgets/backgrounds/open_ocean_background.dart`
- [X] T010 [P] [US1] Implement `DeepSeaBackground` (FR-004) with dark gradient in `lib/widgets/backgrounds/deep_sea_background.dart`
- [X] T011 [US1] Integrate `EnvironmentFactory` in `lib/screens/flanker_game_screen.dart` to display the correct background per current level.

**Checkpoint**: At this point, User Story 1 is functional. The app will swap backgrounds when levels change, though they will be static gradients initially.

---

## Phase 4: User Story 2 - Forward Movement Feedback (Priority: P2)

**Goal**: Implement the "swimming" feedback via temporal acceleration during trial resets.

**Independent Test**: Complete a trial and confirm the background animation speed significantly increases for the duration of the reset phase.

### Implementation for User Story 2

- [X] T012 [US2] Implement `speedMultiplier` ramping (8x-10x) in `EnvironmentOrchestrator` based on `isResetting` state.
- [X] T013 [US2] Synchronize background acceleration with `resetDurationMs` in `lib/screens/flanker_game_screen.dart`.

**Checkpoint**: User Stories 1 and 2 are complete. Backgrounds now provide active feedback during gameplay.

---

## Phase 5: User Story 3 - Immersive Visuals (Priority: P3)

**Goal**: Add detailed parallax layers (kelp, rays, bio-glow) to each environment.

**Independent Test**: Confirm all 3 parallax layers are visible and moving at distinct speeds in each environment.

### Implementation for User Story 3

- [X] T014 [US3] Add caustic ellipses, swaying kelp, and bubble layers to `ShallowReefBackground` (FR-002).
- [X] T015 [US3] Add horizontal waves and light shaft layers to `OpenOceanBackground` (FR-003).
- [X] T016 [US3] Add bioluminescent glow circles and micro-particle layers to `DeepSeaBackground` (FR-004).
- [X] T017 [US3] Randomize particle initialization across screen dimensions (Spec Clarification).

**Checkpoint**: All visual requirements are met. Environments are fully immersive.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Performance optimization and final UI refinement.

- [X] T018 Code cleanup and removal of any debug colors used during development.
- [X] T019 [P] Profile animation performance on Pixel 6a to ensure 60fps / <10MB memory usage (SC-002, SC-004).
- [X] T020 [P] Verify background pause behavior during manual game pause (FR-005).
- [X] T021 Run final validation against `quickstart.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup.
- **User Story 1 (Phase 3)**: Depends on Foundational. BLOCKS UI integration.
- **User Story 2 (Phase 4)**: Depends on US1 integration.
- **User Story 3 (Phase 5)**: Depends on US1 widgets being ready.
- **Polish (Phase 6)**: Depends on all stories.

### Parallel Opportunities

- T008, T009, T010 [US1] can be implemented in parallel.
- All tasks marked [P] can run independently of other tasks in the same phase.

---

## Parallel Example: User Story 3 Visuals

```bash
# Developer A:
Task: "Add detailed layers to ShallowReefBackground"

# Developer B:
Task: "Add detailed layers to OpenOceanBackground"

# Developer C:
Task: "Add detailed layers to DeepSeaBackground"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup + Foundational.
2. Implement basic background selection and gradients (US1).
3. **STOP and VALIDATE**: Verify level-to-color mapping behaves as expected.

### Incremental Delivery

1. Add "Forward Movement" (US2) to provide immediate gameplay feedback.
2. Polish layers (US3) one environment at a time (Shallow → Open → Deep).
3. Perform final performance profiling.
