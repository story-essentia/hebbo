---
description: "Task list for Spatial Span Nebula Map & Track 2"
---

# Tasks: Spatial Span Nebula Map & Track 2

**Input**: Design documents from `/specs/014-spatial-span-nebula-map/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: Project initialization and basic structure

- [x] T001 Initialize Drift table structure in `lib/database/tables/spatial_span_progress.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 Register `SpatialSpanProgressTable` in `lib/database/hebbo_database.dart` and increment schemaVersion
- [x] T003 Implement migration strategy in `lib/database/hebbo_database.dart` for schema version 3
- [x] T004 Generate database code by running `dart run build_runner build`
- [x] T005 Create Data Access Object/Queries in `lib/database/hebbo_database.dart` to read/update track max spans
- [x] T006 Implement `SpatialSpanProgressNotifier` (Riverpod) in `lib/providers/spatial_span_progress_provider.dart` to expose DB state to UI

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 2 - Progression State Persistence (Priority: P1) 🎯 MVP

**Goal**: As a player, I want my progress (max span reached) to be saved automatically upon completing a 2-out-of-3 set.

**Independent Test**: Complete a 2-out-of-3 set and verify the database updates.

### Implementation for User Story 2

- [x] T007 [US2] Update `SpatialSpanNotifier` in `lib/providers/spatial_span_provider.dart` to trigger database write via `SpatialSpanProgressNotifier` upon successful trial phase completion
- [x] T008 [US2] Pass the `trackId` into the `SpatialSpanState` initialization logic in `lib/providers/spatial_span_provider.dart` to ensure progression saves to the correct track

**Checkpoint**: At this point, User Story 2 should be fully functional and testable independently. Progress is saved, even if there is no UI to show it yet.

---

## Phase 4: User Story 1 - Nebula Map Rendering & Interaction (Priority: P1)

**Goal**: As a player, I want to see a visual "Constellation" representing my progression and tap unlocked nodes to play.

**Independent Test**: View the map and verify node logic (Track 1 trunk, Track 2 branch at Span 5).

### Implementation for User Story 1

- [x] T009 [P] [US1] Create `ConstellationNode` state model in `lib/widgets/backgrounds/nebula_map_painter.dart`
- [x] T010 [US1] Implement `NebulaMapPainter` (CustomPainter) in `lib/widgets/backgrounds/nebula_map_painter.dart` to draw lines and nodes based on DB state
- [x] T011 [US1] Create `NebulaMapView` screen in `lib/screens/nebula_map_screen.dart` featuring an `InteractiveViewer`
- [x] T012 [US1] Implement hit-testing and tap logic in `NebulaMapView` to launch `SpatialSpanScreen` with the selected Span and Track
- [x] T013 [US1] Update `HomeScreen` in `lib/screens/home_screen.dart` to route the Spatial Span card to `NebulaMapView` instead of starting a game directly

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently. The map renders and progress updates.

---

## Phase 5: User Story 3 - Track 2: The Pulse (Visual Noise) (Priority: P2)

**Goal**: As a player, I want to experience Track 2, which introduces "Visual Noise" (distractor pulses) during the sequence demonstration.

**Independent Test**: Launch Track 2 and verify non-target shards pulse randomly during the demonstration phase only.

### Implementation for User Story 3

- [x] T014 [US3] Add `noiseShardIndex` and `noiseScale` to `SpatialSpanState` in `lib/state/spatial_span_state.dart`
- [x] T015 [US3] Update `SpatialSpanNotifier._runDemonstration` in `lib/providers/spatial_span_provider.dart` to initialize a secondary noise timer if `trackId == 2`
- [x] T016 [US3] Implement logic to randomly select non-target shards for the noise timer in `lib/providers/spatial_span_provider.dart`
- [x] T017 [US3] Update `SpatialSpanGrid` in `lib/widgets/spatial_span_grid.dart` to listen for and render the `noiseShardIndex` using the `ShardWidget`

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T018 Code cleanup and refactoring in `SpatialSpanNotifier`
- [x] T019 Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion

### User Story Dependencies

- **User Story 2 (P1)**: Foundation (Phase 2)
- **User Story 1 (P1)**: Foundation (Phase 2). (Note: Visuals depend on DB state, so DB must exist, but they can be tested via mocks).
- **User Story 3 (P2)**: Foundation (Phase 2).

### Parallel Opportunities

- T009 can be built in parallel with T007/T008.
