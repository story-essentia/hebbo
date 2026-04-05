# Tasks: App Scaffold and Local Storage Layer

**Input**: Design documents from `/specs/001-scaffold-local-storage/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: This milestone includes one critical integration test for the local persistence layer.

**Organization**: Tasks are grouped into setup, foundational infrastructure, and user stories.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files/directories)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `integration_test/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Initialize Flutter project named `hebbo` using `flutter create hebbo`
- [X] T002 [P] Create clean architecture directory structure: `lib/models/`, `lib/repositories/`, `lib/providers/`
- [X] T003 Configure `pubspec.yaml` with required dependencies: `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`
- [X] T004 Configure `pubspec.yaml` with dev dependencies: `drift_dev`, `build_runner`, `integration_test`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 [P] Create Drift database schema definition in `lib/database/hebbo_database.dart` with `trials`, `sessions`, and `difficulty_state` tables
- [X] T006 [P] Create domain entities in `lib/models/trial_entity.dart`, `lib/models/session_entity.dart`, and `lib/models/difficulty_entity.dart`
- [X] T007 Generate database code using `dart run build_runner build --delete-conflicting-outputs`
- [X] T008 [MANDATORY PRINCIPLE V] Document the modular game interface standard at `docs/modularity_standard.md` to enable future external contributions.

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Project Scaffolding (Priority: P1) 🎯 MVP

**Goal**: Establish the clean architecture structure and dependency injection stubs.

**Independent Test**: Verify file system structure matches clean architecture requirements and app compiles.

### Implementation for User Story 1

- [X] T009 [US1] Implement repository interfaces in `lib/repositories/i_trial_repository.dart`, `lib/repositories/i_session_repository.dart`, and `lib/repositories/i_difficulty_repository.dart`
- [X] T010 [US1] Create provider stubs in `lib/providers/session_provider.dart` and `lib/providers/difficulty_provider.dart` for dependency injection
- [X] T011 [US1] Configure `main.dart` with basic dependency injection setup for the persistence layer

**Checkpoint**: At this point, the project structure is fully established and ready for implementation.

---

## Phase 4: User Story 2 - Local Data Persistence (Priority: P1)

**Goal**: Implement the local persistence layer and verify data integrity across app restarts.

**Independent Test**: Run `integration_test/persistence_test.dart` on an Android emulator.

### Implementation for User Story 2

- [X] T012 [P] [US2] Implement Drift-backed `TrialRepository` in `lib/repositories/drift_trial_repository.dart`
- [X] T013 [P] [US2] Implement Drift-backed `SessionRepository` in `lib/repositories/drift_session_repository.dart`
- [X] T014 [US2] Implement Drift-backed `DifficultyRepository` in `lib/repositories/drift_difficulty_repository.dart`
- [X] T015 [US2] Create integration test in `integration_test/persistence_test.dart` that inserts a mock session/trials and verifies persistence after hot restart simulation

**Checkpoint**: Persistence layer is fully functional and verified.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements and final validation

- [X] T016 Run `flutter analyze` and resolve all warnings/errors
- [X] T017 [P] Self-audit: Verify ZERO network requests or networking library imports (`http`, `dio`, etc.)
- [X] T018 [P] Update `README.md` with architectural documentation and quickstart instructions

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - starts immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories.
- **User Stories (Phases 3 and 4)**: Depend on Foundational phase completion. Can be worked on in parallel.

### Parallel Opportunities

- T002, T005, T006 can start concurrently once the project is initialized.
- T012, T013 can be implemented in parallel.
- Polish tasks T017, T018 can start once Story phases hit 50% completion.

---

## Implementation Strategy

### MVP First (Core Foundation)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL)
3. Complete Phase 3: Project Scaffold
4. Complete Phase 4: Data Persistence
5. **STOP and VALIDATE**: Run integration tests to ensure 100% data fidelity.
