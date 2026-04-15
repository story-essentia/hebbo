# Research & Decisions

## Technical Context
- **Framework**: Flutter
- **State Management**: Riverpod (existing)
- **Data Persistence**: `shared_preferences` for the flag (new), `drift` for SQLite (existing)
- **Design System**: Electric Nocturne (`DESIGN.md`)

## Unknowns & Clarifications
There were zero `[NEEDS CLARIFICATION]` markers in the feature specification. The requirements were explicitly defined by the user.

### Decision 1: Flag Persistence
- **Decision**: Use the `shared_preferences` package to store the `has_seen_honesty_screen` flag.
- **Rationale**: The user explicitly requested this package for simple boolean storage. It is the industry standard for lightweight key-value pairs in Flutter, perfectly suited for an onboarding flag without polluting the complex `drift` SQLite database used for game trials.

### Decision 2: Data Cleanup Mechanism
- **Decision**: Implement a one-off cleanup function using the existing `drift` database provider (`HebboDatabase`).
- **Rationale**: The user specified that existing development data must be cleared on first launch. We can add a method to the database class (or execute a raw query) to drop all records from `trials`, `sessions`, and `difficulty_states`, called during app initialization before the honesty screen check.

### Decision 3: App Navigation Flow
- **Decision**: Use standard Flutter `Navigator 2.0` or `Navigator.pushReplacement` for the simple transitions described.
- **Rationale**: The app currently uses basic routing. The transitions (Honesty Screen -> Home Screen -> Flanker Game) are linear and simple. No complex routing library (`go_router`) is strictly necessary yet, keeping the technical footprint small.
