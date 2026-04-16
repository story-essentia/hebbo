# Tasks: Game detail bottom sheet

**Feature Branch**: `007-game-detail-sheet` | **Date**: 2026-04-16 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/007-game-detail-sheet/spec.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependency management and project initialization

- [X] T001 [P] Add `shimmer: ^3.0.0` dependency to `pubspec.yaml` and run `flutter pub get`
- [X] T002 Update `HebboDatabase` in `lib/database/hebbo_database.dart` with refined `getPersonalBestRt` (session average) and `getTotalSessionsCompleted` (ended sessions) queries
- [X] T003 Run `flutter pub run build_runner build` to regenerate Drift database code

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data structures and mapping logic

**⚠️ CRITICAL**: Database refinements must be complete before UI iteration

- [X] T004 Create `StatDisplayModel` DTO in `lib/models/stat_display_model.dart` to hold best RT, session count, and played status
- [X] T005 [P] Implement `StatChip` reusable widget in `lib/widgets/stat_chip.dart` using Electric Nocturne surface colors
- [X] T006 [P] Implement `StatChipSkeleton` animated shimmer widget in `lib/widgets/stat_chip_skeleton.dart` using the `shimmer` package

**Checkpoint**: Foundation ready - UI implementation can now begin

---

## Phase 3: User Story 1 & 2 - Core Detail Sheet (Priority: P1) 🎯 MVP

**Goal**: Show a slide-up sheet with scientific context, citations, and functional Play/Progress actions.

**Independent Test**: Tap the Flanker card; verify the sheet appears with the science summary, citation, and functional buttons.

### Implementation for User Story 1 & 2

- [X] T007 [P] [US1] Create the base `FlankerDetailSheet` widget structure with Title (Headline style) and Science Summary in `lib/widgets/flanker_detail_sheet.dart`
- [X] T008 [P] [US1] Add the "Based on Eriksen & Eriksen (1974)" citation in muted label style to `lib/widgets/flanker_detail_sheet.dart`
- [X] T009 [US1] Implement the full-width pink gradient "Play" button in `lib/widgets/flanker_detail_sheet.dart` with immediate navigation to `FlankerGameScreen`
- [X] T010 [US1] Implement conditional layout logic to show "First session — we'll find your level" for new players in `lib/widgets/flanker_detail_sheet.dart`
- [X] T011 [US2] Create `flankerStatsProvider` in `lib/providers/flanker_stats_provider.dart` to fetch data from `HebboDatabase`
- [X] T012 [US2] Connect `flankerStatsProvider` to `FlankerDetailSheet` to display `StatChip` components with actual user statistics
- [X] T013 [US2] Implement the "View your progress" text link in `lib/widgets/flanker_detail_sheet.dart` for returning users

**Checkpoint**: User Story 1 & 2 are functional - users can see context and start games from the sheet

---

## Phase 4: User Story 3 & 4 - UX Polish & Dismissal (Priority: P2/P3)

**Goal**: Ensure smooth loading transitions and standard dismiss behavior.

**Independent Test**: Verify shimmer skeletons appear during data fetch; confirm sheet dismisses on tap-out or swipe-down.

### Implementation for User Story 3 & 4

- [X] T014 [US3] Configure `showModalBottomSheet` in `lib/screens/home_screen.dart` with 32dp rounded corners and background-tap dismissal
- [X] T015 [US4] Update `FlankerDetailSheet` to display `StatChipSkeleton` widgets when the `flankerStatsProvider` is in a loading state
- [X] T016 [P] [US4] Ensure transition from skeleton to actual `StatChip` does not cause layout jumping in `lib/widgets/flanker_detail_sheet.dart`

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final integration and responsiveness verification

- [X] T017 Integrate the `FlankerDetailSheet` trigger into the Flanker card in `lib/screens/home_screen.dart`
- [X] T018 [P] Verify contrast ratios for muted text/citations against the `#150629` sheet background
- [X] T019 Final testing of "Immediate Transition" and animation speed (SC-001 <300ms) on physical device

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Must run first to ensure the SQL logic is ready and the library is available.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all UI work.
- **User Stories (Phase 3-4)**: Depend on Foundational.
- **Polish (Final Phase)**: Runs after all stories are implemented.

### Parallel Opportunities

- T001 and T002 can run in parallel (Pubspec vs Database code).
- T005 and T006 (Widgets) can be developed independently once `StatDisplayModel` is defined.
- T007 and T008 (Sheet content) can run in parallel.

---

## Implementation Strategy

### MVP First (User Story 1 & 2)

1. Finalize the Database query for session averages.
2. Build the `FlankerDetailSheet` with the "Play" button (immediate navigation).
3. Connect the stats provider.
4. Verify the basic "Card -> Sheet -> Play" journey works.

### Incremental Delivery

1. Foundation: Database + Base Widgets.
2. Increment 1: Sheet with Intro mode and Play button.
3. Increment 2: Stats integration and Shimmer loading.
4. Increment 3: Dismissal and Progress navigation polish.
