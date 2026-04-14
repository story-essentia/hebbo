---
description: "Task list for Progress Screen feature implementation"
---

# Tasks: Progress Screen

**Input**: Design documents from `/specs/005-progress-screen/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 [P] Run `flutter pub add fl_chart` to update `pubspec.yaml`
- [x] T002 Create base file structures in `lib/screens/progress_screen.dart`, `lib/widgets/progress_chart.dart`, `lib/models/progress_models.dart`, and `lib/providers/progress_provider.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 Create `ProgressMetrics` and `SessionChartData` models in `lib/models/progress_models.dart`
- [x] T004 Implement aggregation SQL queries (personal best, averages per session group) in `lib/database/hebbo_database.dart` (or DAO)
- [x] T005 Implement test session seeding logic in `lib/database/hebbo_database.dart` with 8 mock sessions
- [x] T006 Implement `ProgressProvider` in `lib/providers/progress_provider.dart` as a Riverpod `AsyncNotifier` producing the UI state

**Checkpoint**: Foundation ready - DB methods and provider exist. User story implementation can now begin.

---

## Phase 3: User Story 1 - View Overall Performance Metrics (Priority: P1) 🎯 MVP

**Goal**: Show a high-level summary of overall progress with three stat cards

**Independent Test**: The top row shows accurate values for Best RT, Total Sessions, and Environment based on seed data.

### Implementation for User Story 1

- [x] T007 [P] [US1] Create a resuable metrics card component in `lib/widgets/progress_metrics_widget.dart`
- [x] T008 [US1] Integrate `ProgressProvider` in `lib/screens/progress_screen.dart` and render the three metric cards when loaded

**Checkpoint**: At this point, the initial stat cards populate correctly.

---

## Phase 4: User Story 2 - Visualize Session-by-Session Growth (Priority: P1)

**Goal**: Plot reaction time and difficulty on a multi-axis line chart over sessions.

**Independent Test**: Chart plots a solid blue line (congruent), dashed orange line (incongruent), and a stepped green line (difficulty).

### Implementation for User Story 2

- [x] T009 [P] [US2] Scaffold `fl_chart` LineChart widget in `lib/widgets/progress_chart.dart`
- [x] T010 [US2] Connect RT data to left Y-axis (blue/orange lines) in `lib/widgets/progress_chart.dart`
- [x] T011 [US2] Connect Difficulty data to right Y-axis (stepped green line) and map scale in `lib/widgets/progress_chart.dart`
- [x] T012 [US2] Mount the chart inside `lib/screens/progress_screen.dart` beneath the metric cards

**Checkpoint**: At this point, the chart correctly renders all three lines.

---

## Phase 5: User Story 3 - Toggle Chart View Range (Priority: P2)

**Goal**: Default to showing only 10 recent sessions, allowing toggle for "All Time".

**Independent Test**: Tapping the top-right text button toggles the chart's X-axis subset.

### Implementation for User Story 3

- [x] T013 [P] [US3] Add a toggle state (e.g. `showAllTime`) to `ProgressProvider` in `lib/providers/progress_provider.dart`
- [x] T014 [US3] Add text button toggle UI to `lib/screens/progress_screen.dart` and update chart filtering based on provider state

**Checkpoint**: Toggling limits data accurately on chart.

---

## Phase 6: User Story 4 - Navigate Back Safely (Priority: P2)

**Goal**: Allow returning back to the previous screen.

**Independent Test**: App back button properly closes the progress screen.

### Implementation for User Story 4

- [x] T015 [P] [US4] Add `AppBar` with `leading` back button to `lib/screens/progress_screen.dart`
- [x] T016 [US4] Update `lib/screens/session_end_placeholder.dart` to navigate directly to `ProgressScreen` on `See progress` tap

**Checkpoint**: Application navigation fully integrated.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T017 Remove call to seeding script after visual tests are validated
- [x] T018 Ensure 60fps scrolling and verify `flutter analyze` passes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- Data model and layout creation tasks marked [P] can run in parallel
- Once Foundational phase completes, User Story 1 and User Story 4 can technically start in parallel.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 & 2
2. Complete Phase 3: User Story 1
3. **STOP and VALIDATE**: Verify Metric Cards via direct mounting
4. Proceed to Phase 4 (Chart visualization)

### Incremental Delivery

1. Complete Setup + Foundational
2. Add User Story 1 → Stats working
3. Add User Story 2 → Chart working
4. Add User Story 3 → Toggle working
5. Add User Story 4 → Navigation working
