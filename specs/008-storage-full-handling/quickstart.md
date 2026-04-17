# Quickstart: Testing Storage Full Graceful Handling

This guide explains how to verify the storage-full error handling without actually filling your device storage.

## Simulated Testing using Mock Repositories

### 1. Mock the Repository
In your test or a temporary debug build, create a wrapper that throws the target exception:

```dart
class FullStorageSessionRepository implements ISessionRepository {
  @override
  Future<int> insertSession(SessionEntity session) {
    // Simulate SQLITE_FULL error
    throw SqliteException(13, 'database or disk is full');
  }
  // ... other overrides
}
```

### 2. Trigger the Error
1. Launch Hebbo.
2. Complete any 75-trial game session (e.g., Flanker).
3. Observe the persistence phase.

### 3. Expected Observations
- **Snackbar**: A snackbar appearing with the message: "Could not save session data. Your device storage may be full."
- **Action**: The snackbar should have an "OK" button.
- **Interactivity**: Tapping "OK" should dismiss the snackbar, and you should still be on the "Session Complete" screen.
- **Navigation Guard**: Try to navigate "Back to menu". You should see a confirmation dialog warning that your progress will be lost.
- **Crash Check**: Ensure the terminal does not show any unhandled exceptions or app termination.
