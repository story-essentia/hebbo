---

description: "Task list for First-Run Experience & Home Screen feature implementation"
---

# Tasks: First-Run Experience & Home Screen

**Input**: Design documents from `/specs/006-first-run-homescreen/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: No specific tests requested.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 [P] Add `shared_preferences` to `pubspec.yaml`
- [x] T002 [P] Ensure `Plus Jakarta Sans` from `google_fonts` is available in `pubspec.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 Setup global SharedPreferences provider/instance in `lib/providers/database_provider.dart` (or `main.dart` during initialization)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - First-Time User Onboarding (Priority: P1) 🎯 MVP

**Goal**: Display a radical honesty screen on first launch that sets the flag effectively.

**Independent Test**: Uninstall app, reinstall, open app. Honesty screen shows once. Tapping "Let's go" proceeds to an empty Home Screen. Reopening the app skips the honesty screen.

### Implementation for User Story 1

- [x] T004 [P] [US1] Create `lib/screens/honesty_screen.dart` layout adhering to Electric Nocturne guidelines
- [x] T005 [US1] Add `has_seen_honesty_screen` update logic into `HonestyScreen` button press
- [x] T006 [US1] Update `lib/main.dart` boot logic to dynamically load `HonestyScreen` or `HomeScreen` based on the preference flag.

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently (routing to a placeholder Home Screen).

---

## Phase 4: User Story 2 - Home Screen Game Selection (Priority: P1)

**Goal**: Present the menu of games, specifically making Flanker available and visually muting locked games.

**Independent Test**: From Home Screen, verify 3 cards are present. Flanker is tap-enabled and has high-contrast colors, while the other two are muted and inactive.

### Implementation for User Story 2

- [x] T007 [P] [US2] Create base `lib/screens/home_screen.dart` with `#150629` scaffold background
- [x] T008 [P] [US2] Add Flanker active card to `lib/screens/home_screen.dart` with fully rounded (#301a4d) styling 
- [x] T009 [P] [US2] Add Task Switching and Spatial Span locked cards to `lib/screens/home_screen.dart` (50% opacity, non-interactive)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently.

---

## Phase 5: User Story 3 - Complete Navigation Flow (Priority: P1)

**Goal**: Eliminate dead-ends in the app by connecting Flanker, Session End, Progress, and Home screens together.

**Independent Test**: Run a game of Flanker. From Session End screen, test Play again, See progress, and Back to menu. From Progress screen, hit the back button. Verify no dead ends.

### Implementation for User Story 3

- [x] T010 [US3] Update Flanker card `onTap` in `lib/screens/home_screen.dart` to navigate to `FlankerGameScreen`
- [x] T011 [US3] Update `lib/screens/session_end_placeholder.dart` to add "Play again", "See progress", and "Back to menu" buttons
- [x] T012 [US3] Wire "See progress" to `ProgressScreen` and "Back to menu" to `HomeScreen` inside `lib/screens/session_end_placeholder.dart`
- [x] T013 [US3] Wire "Play again" to `FlankerGameScreen` inside `lib/screens/session_end_placeholder.dart`

**Checkpoint**: All P1 user stories should now be independently functional.

---

## Phase 6: User Story 4 - Scientific Transparency (Priority: P2)

**Goal**: Display scientific citations via an "About Hebbo" bottom sheet link on the Home Screen.

**Independent Test**: Load Home Screen, tap "About Hebbo" at the bottom, verify citations sheet opens, swipe it closed.

### Implementation for User Story 4

- [x] T014 [P] [US4] Create bottom sheet widget `lib/widgets/about_hebbo_sheet.dart` with citations
- [x] T015 [US4] Add "About Hebbo" text button below cards in `lib/screens/home_screen.dart` hooked to the bottom sheet

---

## Phase 7: User Story 5 - Development Data Cleanup (Priority: P2)

**Goal**: Purge all pre-existing corrupted development database rows on user update.

**Independent Test**: Seed data, close app, launch app. Database trials/sessions should be completely empty and progress should report zero.

### Implementation for User Story 5

- [x] T016 [P] [US5] Implement `cleanupDevelopmentData()` dropping all rows in `trials`, `sessions`, `difficulty_states` in `lib/database/hebbo_database.dart`
- [x] T017 [US5] Update `lib/main.dart` boot logic to check `has_run_dev_cleanup`. If false, await `database.cleanupDevelopmentData()`, set flag to true.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T018 Code cleanup and formatting (`flutter format lib/`)
- [x] T019 Run static analysis (`flutter analyze`)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Independent
- **User Story 2 (P1)**: Independent, but relies on US1's Home Screen routing for demonstration.
- **User Story 3 (P1)**: Requires US2's Home Screen to navigate to / from.
- **User Story 4 (P2)**: Requires US2's Home Screen to append the link to.
- **User Story 5 (P2)**: Modifies the boot logic established in US1.

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- UI building blocks (HonestyScreen layout, HomeScreen cards, About sheet) can all be built in parallel.
- Database cleanup function (US5) can be authored in parallel with UI work.

---

## Parallel Example: User Story 2

```bash
# Launch components for User Story 2 together:
Task: "Add Flanker active card to lib/screens/home_screen.dart"
Task: "Add Task Switching and Spatial Span locked cards to lib/screens/home_screen.dart"
```

---

## Implementation Strategy

### Incremental Delivery

1. Complete Setup + Foundational (SharedPreferences initialized)
2. Add User Story 1 → App can boot into Honesty routing
3. Add User Story 2 → App renders Home Screen properly (MVP Navigation)
4. Add User Story 3 → Ends the game sessions correctly routing to the new Home Screen
5. Add User Stories 4 & 5 → Final cleanup and scientific transparency overlays added.

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Verify each screen explicitly matches Electric Nocturne tokens (`#150629` BG, `#301a4d` Surface)
