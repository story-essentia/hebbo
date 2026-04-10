# Tasks: Fish Animation Integration

**Input**: Design documents from `/specs/004-fish-animation-integration/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and dependency setup

- [X] T001 Add `path_drawing` dependency to `pubspec.yaml`
- [X] T002 Extend `FishState` enum in `lib/widgets/animated_fish.dart` to include 7 states per data-model.md

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core rendering logic that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 Implement horizontal mirroring logic in `_FishPainter.paint()` using `canvas.scale(-1, 1)` and `canvas.translate()` in `lib/widgets/animated_fish.dart`
- [X] T004 Implement `timeoutNeutral` rendering in `_FishPainter.paint()` using `canvas.saveLayer` with 0.4 opacity in `lib/widgets/animated_fish.dart`
- [X] T005 [P] Correct `_FishPainter` color palette logic to map the 7 new states to appropriate `bodyColor` and `finColor` in `lib/widgets/animated_fish.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Dynamic Fish Stimuli (Priority: P1) 🎯 MVP

**Goal**: Replace placeholder rectangles with the `AnimatedFish` widget row

**Independent Test**: The Flanker game displays 5 animated fish instead of 5 rectangles.

### Implementation for User Story 1

- [X] T006 Create `FishRowWidget` in `lib/widgets/fish_row_widget.dart` as a layout container for five fish
- [X] T007 Implement 280x280 (center) and 240x240 (flanker) sizing logic in `FishRowWidget` in `lib/widgets/fish_row_widget.dart`
- [X] T008 [US1] Replace placeholder `Row` in `lib/screens/flanker_game_screen.dart` with `FishRowWidget`
- [X] T009 [US1] Map `FlankerSessionState` to `FishRowWidget` properties in `lib/screens/flanker_game_screen.dart`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Clear Directional Cues (Priority: P2)

**Goal**: Ensure fish orientation matches trial assignment (mirroring)

**Independent Test**: Right-side target trials display a fish facing Right.

### Implementation for User Story 2

- [X] T010 [US2] Update `FishRowWidget` to pass the correct `FishState` (Neutral Left vs Neutral Right) based on trial assignment in `lib/widgets/fish_row_widget.dart`
- [X] T011 [US2] Verify mirroring behavior by running a session and observing fish orientation.

---

## Phase 5: User Story 3 - Trial Feedback Animations (Priority: P3)

**Goal**: Implement Correct/Wrong feedback and Timeout feedback logic

**Independent Test**: Tapping correct shows green center fish; timeouts show dimmed fish for 300ms.

### Implementation for User Story 3

- [X] T012 [US3] Implement 400ms feedback timer logic in `FlankerGameNotifier._handleResponse()` in `lib/providers/flanker_game_provider.dart`
- [X] T013 [US3] Update `FlankerGameNotifier` to set `FishState` to `Correct`/`Wrong` upon input in `lib/providers/flanker_game_provider.dart`
- [X] T014 [US3] Implement 300ms timeout transition logic in `FlankerGameNotifier` in `lib/providers/flanker_game_provider.dart`

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Refinements and final verification

- [X] T015 Suppress bubble animations in `_onTick()` when state is not Neutral in `lib/widgets/animated_fish.dart`
- [X] T016 Run `flutter analyze` and resolve all warnings
- [X] T017 Run full 75-trial session on Pixel 6a and confirm 60FPS using Flutter Performance Overlay.
- [X] T018 Run `quickstart.md` validation checklist

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: Depends on T001, T002 - BLOCKS all user stories.
- **User Stories (Phase 3+)**: All depend on Phase 2 completion.
- **Polish (Final Phase)**: Depends on all user stories being complete.

### User Story Dependencies

- **US1 (P1)**: Foundation ready (Phase 2).
- **US2 (P2)**: Depends on US1 (layout needed).
- **US3 (P3)**: Depends on US1 (layout needed).

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup + Foundational logic.
2. Complete US1 to get fish on screen.
3. **STOP and VALIDATE**: Verify fish appear and animate.

### Incremental Delivery

1. Add US2 (Mirroring orientation).
2. Add US3 (Feedback timing).
3. Polish (Bubbles + Perf).

---

## Notes

- [P] tasks = different files or decoupled logic within `animated_fish.dart`.
- [Story] label maps task to specific user story for traceability.
- Verify animations don't "jump" when state changes.
