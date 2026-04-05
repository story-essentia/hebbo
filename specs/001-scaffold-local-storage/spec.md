# Feature Specification: App Scaffold and Local Storage Layer

**Feature Branch**: `001-scaffold-local-storage`  
**Created**: 2026-04-04  
**Status**: Draft  
**Input**: User description: "Build the foundation for Hebbo, a brain training app. This milestone creates only the Flutter project scaffold and the local storage layer. Nothing else. What to build: Flutter project named Hebbo, clean architecture with separate folders for models, repositories, and providers Drift database with exactly three tables: trials, sessions, difficulty_state A repository class with insert and read methods for each table One integration test: insert a mock session with mock trials, read it back, confirm data persists across hot restart Data model: trials — id, session_id, trial_num, type (congruent/incongruent), correct (0/1), reaction_ms, difficulty, timestamp sessions — id, session_num, started_at, ended_at, starting_level, ending_level, environment_tier difficulty_state — game_id (text, primary key), current_level, updated_at Done when: App launches on Android emulator Mock session and trial data readable from Drift database Data persists across hot restart Zero network requests made at any point flutter analyze returns no errors Do not build: any UI, any game logic, any animation, any navigation, anything not listed above."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Project Scaffolding (Priority: P1)

As a developer, I want a clean and structured Flutter project so that I can implement features in a modular and maintainable way.

**Why this priority**: Foundational prerequisite for all future development.

**Independent Test**: Verify file system structure matches the clean architecture requirements (models, repositories, providers).

**Acceptance Scenarios**:

1. **Given** a new project root, **When** initialized, **Then** a Flutter app named 'Hebbo' exists with directories for `models`, `repositories`, and `providers`.
2. **Given** the scaffolded project, **When** running `flutter analyze`, **Then** no errors are reported.

---

### User Story 2 - Local Data Persistence (Priority: P1)

As a developer, I want to store trial and session data locally so that the app respects user privacy and functions entirely offline.

**Why this priority**: Essential for the "Privacy by Default" and "Offline-First" principles of the Hebbo constitution.

**Independent Test**: Run an integration test that inserts a mock session and trials, performs a hot restart, and verifies the data is still present and correct.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** a mock session and multiple mock trials are inserted via the repository, **Then** they are persisted to the Drift database.
2. **Given** persisted data in the database, **When** the app is hot restarted, **Then** the repository can read back the exact same data.

---

### Edge Cases

- **Database Initialization**: Ensure the database is created correctly on first launch without errors.
- **Concurrent Access**: Ensure basic repository operations don't fail if called in rapid succession (though not critical for this milestone).
- **Empty Database**: Reading from tables when no data exists should return empty lists, not crash the app.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST be initialized as a Flutter project named Hebbo.
- **FR-002**: System MUST implement a clean architecture with separate folders for `models`, `repositories`, and `providers`.
- **FR-003**: System MUST implement a local SQLite database using the `drift` package.
- **FR-004**: Database MUST contain exactly three tables: `trials`, `sessions`, and `difficulty_state`.
- **FR-005**: `trials` table MUST have columns: `id` (int, pk), `session_id` (int), `trial_num` (int), `type` (text), `correct` (bool), `reaction_ms` (int), `difficulty` (int), `timestamp` (datetime).
- **FR-006**: `sessions` table MUST have columns: `id` (int, pk), `session_num` (int), `started_at` (datetime), `ended_at` (datetime), `starting_level` (int), `ending_level` (int), `environment_tier` (int).
- **FR-007**: `difficulty_state` table MUST have columns: `game_id` (text, pk), `current_level` (int), `updated_at` (datetime).
- **FR-008**: System MUST provide repository classes for interacting with each table (insert/read).
- **FR-009**: System MUST make ZERO network requests.

### Key Entities *(include if feature involves data)*

- **Trial**: Represents an individual response event in a game. Attributes include response accuracy and speed.
- **Session**: Groups a collection of trials together, representing a single training period.
- **DifficultyState**: Tracks the user's current mastery level for each game to allow for adaptive difficulty.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Flutter application launches and runs on an Android emulator without crashing.
- **SC-002**: 100% data persistence across hot restarts (verified by integration test).
- **SC-003**: ZERO errors returned by the static analysis tool.
- **SC-004**: ZERO network permissions or libraries included in the project.


## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game (applies to future game implementation)]
- [Assumption about target users: 25-35, tech-savvy, skeptic of pseudoscience]
- [Dependency on local-first architecture for all data persistence]
- Drift will be the primary database ORM as requested.
- Clean architecture focuses on folder separation for this milestone.
