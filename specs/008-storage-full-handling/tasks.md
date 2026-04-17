# Tasks: Storage full edge case

**Input**: Design documents from `/specs/008-storage-full-handling/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

**Organization**: Tasks are grouped by user story to ensure independent delivery of the storage-full resilience logic for the game session flow.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the global notification mechanism required for data-layer feedback.

- [X] T001 Define and register a `GlobalKey<ScaffoldMessengerState>` in `lib/main.dart` to enable snackbars from any layer.
- [X] T002 Update the root `MaterialApp` in `lib/main.dart` to use the defined `scaffoldMessengerKey`.
- [X] T003 [P] Create a global `snackbar_service.dart` or provider in `lib/providers/notification_provider.dart` to wrap the `showSnackBar` functionality for reuse.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared utilities for detecting and identifying storage-specific failures.

- [X] T004 Implement a `DatabaseErrorExtractor` utility in `lib/database/error_handler.dart` that specifically identifies `SQLITE_FULL` (code 13) from `SqliteException`.
- [X] T004a [P] Ensure error utility includes a check for active transactions or connection status to prevent "orphaned" locks. [SC-004]
- [X] T005 [P] Add an `isPersisted` boolean field and a `saveError` string field to the `FlankerSessionState` in `lib/state/flanker_session_state.dart`.

---

## Phase 3: User Story 1 - Recovery from Persistence Failure (Priority: P1) 🎯 MVP

**Goal**: Implement graceful catch-and-notify logic for the Flanker game session persistence.

**Independent Test**: Simulate a disk-full error in the repository mock (per `quickstart.md`) and verify the snackbar appears on the session completion screen without an app crash.

### Implementation for User Story 1

- [X] T006 [US1] Wrap the `_persistSession` logic in `lib/providers/flanker_game_provider.dart` with a try-catch block utilizing the utility from T004.
- [X] T006a [US1] Extend try-catch guards to `lib/repositories/drift_difficulty_repository.dart` to cover level-persistence failure scenarios. [FR-001]
- [X] T007 [US1] On save failure, update the state in `lib/providers/flanker_game_provider.dart` to set `isPersisted: false` and trigger the notification service from T003.
- [X] T008 [US1] Update the "Session Complete" snackbar trigger in `lib/providers/flanker_game_provider.dart` to show the EXACT message: "Could not save session data. Your device storage may be full."
- [X] T009 [US1] Add an "OK" or "Dismiss" action button to the snackbar in the trigger logic (referencing T008).
- [X] T010 [US1] Update `lib/screens/session_end_placeholder.dart` to consume the `isPersisted` flag from the game provider.
- [X] T011 [US1] Implement a `WillPopScope` or `PopScope` navigation guard in `lib/screens/session_end_placeholder.dart` that shows a confirmation dialog if `isPersisted` is false.
- [X] T012 [US1] Design and implement the confirmation dialog in `lib/screens/session_end_placeholder.dart` warning that unsaved progress will be lost.

**Checkpoint**: At this point, the Flanker game session flow is crash-resilient against storage exhaustion.

---

## Phase N: Polish & Cross-Cutting Concerns

- [X] T013 [P] Review `TaskSwitching` and `SpatialSpan` providers (if implemented) for similar `try-catch` consistency.
- [X] T014 [P] Verify that the "See progress" navigation in `lib/screens/session_end_placeholder.dart` handles the absence of a just-played session session gracefully (AS-3).
- [X] T015 Run the full validation suite described in `specs/008-storage-full-handling/quickstart.md`.
- [X] T015a Verify SC-002 requirement (Snackbar visible within 300ms of failure) during simulation via timestamp logs or manual verification. [SC-002]

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 completions (for state and error handling utils).
- **User Story 1 (Phase 3)**: Depends on Foundational (T004, T005).

### Implementation Strategy

1. **MVP**: Complete US1. This covers the most critical user pain point (losing game progress on crash).
2. **Sequential**: All tasks within US1 should be done in order (Logic → Notification → Navigation Guard).
