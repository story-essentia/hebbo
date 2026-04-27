# hebbo Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-04-27

## Active Technologies
- Flutter 3.x, Dart 3.x + `flutter_riverpod` (state), `drift` (persistence), `test` (unit verification) (002-adaptive-difficulty-engine)
- Persistence via the existing `DifficultyRepository` (Drift/SQLite). (002-adaptive-difficulty-engine)
- Flutter 3.x, Dart 3.x + `flutter_riverpod`, `drift`, `mocktail` (003-flanker-game-loop)
- Results persisted via `TrialRepository` and `SessionRepository`. (003-flanker-game-loop)
- Dart / Flutter + `fl_chart` (to be added), Drift (existing SQLite DB), Riverpod (existing state management) (005-progress-screen)
- On-device only (local Drift database), no remote sync for MVP (005-progress-screen)
- [MANDATORY: On-device only (localStorage/IndexedDB), no remote sync for MVP] (006-first-run-homescreen)
- Flutter (Dart) + `flutter_riverpod`, `drift` (SQLite), `shimmer`, `google_fonts` (007-game-detail-sheet)
- Drift (SQLite) - on-device only, no remote sync. (007-game-detail-sheet)
- Dart / Flutter + Drift (sqlite), flutter_riverpod, google_fonts (008-storage-full-handling)
- On-device SQLite (Drift), No remote sync for MVP. (008-storage-full-handling)
- Flutter / Dart + `flutter_riverpod` (state management) (009-dynamic-environments)
- Drift (On-device Only) (009-dynamic-environments)
- Dart 3.x / Flutter 3.x + `flutter_riverpod`, `just_audio`, `drift`, `audio_session` (011-task-switching)
- Drift (SQLite) on-device persistence (011-task-switching)
- Dart 3.x / Flutter 3.x + flutter_riverpod, just_audio (012-game-start-countdown)
- On-device only (persist nothing for countdown) (012-game-start-countdown)

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
- 012-game-start-countdown: Added Dart 3.x / Flutter 3.x + flutter_riverpod, just_audio
- 011-task-switching: Added Dart 3.x / Flutter 3.x + `flutter_riverpod`, `just_audio`, `drift`, `audio_session`
- 009-dynamic-environments: Added Flutter / Dart + `flutter_riverpod` (state management)


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
