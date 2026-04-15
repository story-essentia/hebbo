# hebbo Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-04-14

## Active Technologies
- Flutter 3.x, Dart 3.x + `flutter_riverpod` (state), `drift` (persistence), `test` (unit verification) (002-adaptive-difficulty-engine)
- Persistence via the existing `DifficultyRepository` (Drift/SQLite). (002-adaptive-difficulty-engine)
- Flutter 3.x, Dart 3.x + `flutter_riverpod`, `drift`, `mocktail` (003-flanker-game-loop)
- Results persisted via `TrialRepository` and `SessionRepository`. (003-flanker-game-loop)
- Dart / Flutter + `fl_chart` (to be added), Drift (existing SQLite DB), Riverpod (existing state management) (005-progress-screen)
- On-device only (local Drift database), no remote sync for MVP (005-progress-screen)
- [MANDATORY: On-device only (localStorage/IndexedDB), no remote sync for MVP] (006-first-run-homescreen)

- Flutter 3.x, Dart 3.x + `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`, `drift_dev` (dev), `build_runner` (dev) (001-scaffold-local-storage)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Flutter 3.x, Dart 3.x

## Code Style

Flutter 3.x, Dart 3.x: Follow standard conventions

## Recent Changes
- 006-first-run-homescreen: Added [MANDATORY: On-device only (localStorage/IndexedDB), no remote sync for MVP]
- 005-progress-screen: Added Dart / Flutter + `fl_chart` (to be added), Drift (existing SQLite DB), Riverpod (existing state management)


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
