# Quickstart: App Scaffold and Local Storage Layer

## Overview
How to launch and verify the Hebbo foundational scaffold.

## Setup Requirements
- Flutter SDK (latest stable)
- Android SDK / Emulator (for validation)
- Dart SDK

## Installation

1.  **Initialize Features**: Ensure all project dependencies are updated.
    ```bash
    flutter pub get
    ```

2.  **Generate Database Code**: Execute code generation for the Drift models.
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

## Development Run

1.  **Start Android Emulator**: Ensure your emulator is running.
2.  **Launch App**:
    ```bash
    # Verify build & launch
    flutter run
    ```

## Verification & Testing

### Static Analysis
Verify that the project adheres to clean architecture rules.
```bash
flutter analyze
```

### Integration Persistence Test
Execute the automated test for data persistence across restarts.
```bash
# Run integration tests on the running emulator
flutter test integration_test/persistence_test.dart
```

## Key Tasks for this Milestone
- Confirm zero network requests in app console during database operations.
- Verify `lib/models`, `lib/repositories`, and `lib/providers` directories exist.
- Verify the 3-table Drift schema in `lib/database/`.
