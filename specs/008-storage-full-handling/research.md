# Research: Storage Full Handling

## Decision 1: Identification of Storage Errors
### Decision
We will catch `SqliteException` from the `drift` package and inspect the `extendedErrorCode`.
### Rationale
SQLite defines code `13` (`SQLITE_FULL`) for disk full errors. Modern Drift (using `drift/native.dart`) wraps these underlying errors in a `SqliteException`.
### Alternatives considered
- Catching generic `Exception`: Too broad, might hide bugs.
- Catching `FileSystemException`: Disk full errors at the database layer usually manifest as database-specific exceptions before they hit the file system API directly in Flutter.

## Decision 2: Triggering Non-Blocking UI Notifications
### Decision
Implement a `GlobalKey<ScaffoldMessengerState>` in the main app structure to allow non-contextual snackbar triggering from the `SessionProvider` or `Repository` layer.
### Rationale
The requirement (FR-002) specifies a non-blocking snackbar. Since database saves often happen in background providers (Riverpod), we need a way to show feedback without passing `BuildContext` deep into the data layer. 
### Alternatives considered
- Passing `BuildContext` to data methods: Violates clean architecture.
- Using a separate `errorProvider` that the UI watches: Possible, but `ScaffoldMessengerState` is the standard Flutter way for global, one-off notifications like Snackbars.

## Decision 3: Data Preservation during Failure
### Decision
Retain the session data in the `FlankerSessionState` buffer if the persistence call throws.
### Rationale
The spec (FR-005) mandates that state MUST NOT be lost. By not clearing the `bufferedTrials` and keeping the `isSessionComplete` flag in a state that allows navigation but warns before deletion, we meet the requirement.
### Alternatives considered
- Auto-retry: Risky if storage remains full; might lead to an infinite loop of snackbars.
- Local Storage fallback: If the main DB is full, `localStorage` or `SharedPreferences` is likely close to full as well. Memory is the safest temporary buffer.
