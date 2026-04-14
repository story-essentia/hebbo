# Implementation Plan: Progress Screen

**Branch**: `005-progress-screen` | **Date**: 2026-04-10 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/005-progress-screen/spec.md`

## Summary

Build a progress screen accessed from the session end screen. It visualizes local Drift DB data using `fl_chart`, featuring 3 top-level metric cards and a multi-axis chart plotting congruent/incongruent RT averages and session difficulties over time.

## Technical Context

**Language/Version**: Dart / Flutter
**Primary Dependencies**: `fl_chart` (to be added), Drift (existing SQLite DB), Riverpod (existing state management)
**Storage**: On-device only (local Drift database), no remote sync for MVP
**Testing**: Flutter widget tests, unit tests for data transformation
**Target Platform**: Android / iOS Mobile App (Offline-first)
**Project Type**: Open Source Mobile App
**Performance Goals**: Instantaneous load of aggregate data, 60fps chart rendering
**Constraints**: Offline-only, Privacy-first (no data collection or network requests)
**Scale/Scope**: Single new screen for tracking progression across local sessions

## Constitution Check

*GATE PASS: Checked against Constitution.*
- **Scope Discipline**: Does not introduce user accounts, server sync, or any network requests.
- **Privacy by Default**: Data is entirely local.
- **Design**: The progress screen provides immediate value and motivates the user, adhering to "Design as a First-Class Requirement".

## Project Structure

### Documentation (this feature)

```text
specs/005-progress-screen/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
└── quickstart.md        # Phase 1 output
```

### Source Code (repository root)

```text
lib/
├── screens/
│   └── progress_screen.dart       # The new UI screen
├── widgets/
│   └── progress_chart.dart        # Reusable chart component incorporating fl_chart
├── providers/
│   └── progress_provider.dart     # Riverpod notifier to fetch and hold aggregated data
└── database/
    └── hebbo_database.dart        # Existing DB, might need extension methods for analytics queries
```

**Structure Decision**: The logic will reside alongside the existing Flutter project. The database layer (`hebbo_database.dart` or repository implementations) will handle group-by aggregations. A provider (`progress_provider.dart`) will expose this to the UI (`progress_screen.dart` and `progress_chart.dart`).
