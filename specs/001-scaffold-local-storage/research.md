# Research: App Scaffold and Local Storage Layer

## Decision: Drift/SQLite for Local Storage

### Rationale
- **User Mandate**: Explicitly requested in the feature prompt.
- **Privacy By Default**: Functions fully offline with no remote sync.
- **Strong Typing**: Dart's Drift package provides compile-time safety and code generation for SQLite schemas.
- **Maturity**: Well-documented best practices and stable performance in Flutter ecosystems.

### Alternatives Considered
- **Isar/Hive**: Faster for simple NoSQL, but user specified Drift + tables. SQLite is more robust for session-trial relations.
- **Shared Preferences**: Too simple; lacks relational features needed for cognitive training metrics.

## Decision: Clean Architecture (Simplified)

### Rationale
- **Folder separation**: `lib/models`, `lib/repositories`, `lib/providers` satisfies the user's specific request.
- **Principle V (Community)**: Separation of models from data access makes the code modular and easier for external game contributions.

### Alternatives Considered
- **Feature-first folders**: Better for large apps, but overkill for a 3-table scaffold.
- **Single directory**: Rejected because it violates the "Clean Architecture" requirement.

## Decision: Integration Testing for Hot Restart

### Rationale
- **verification**: Flutter's `integration_test` package supports testing on real devices/emulators.
- **Hot Restart Simulation**: Validated by inserting data, triggering a re-launch/hot-restart equivalent in the test sequence, and reading back.

### Alternatives Considered
- **Unit/Widget tests**: Insufficient for confirming database file persistence across app lifecycle events.
- **Manual testing**: Unreliable and not repeatable for success criteria.

## Dependencies

- **Drift/drift_dev**: Mandatory for the database layer.
- **sqlite3_flutter_libs**: Required for SQLite on Android/iOS.
- **path_provider**: Required to locate the correct on-device directory for the .sqlite file.
- **build_runner**: Required to execute code generation for Drift.
