# Implementation Plan: Game detail bottom sheet

**Branch**: `007-game-detail-sheet` | **Date**: 2026-04-16 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/007-game-detail-sheet/spec.md)
**Input**: Feature specification from `/specs/007-game-detail-sheet/spec.md`

## Summary

Implement a slide-up menu for the Flanker game that provides scientific context and user-specific performance statistics. The menu will follow the Electric Nocturne design system, utilizing animated shimmer skeletons for perceived performance and immediate navigation for a refined high-intensity cognitive training experience.

## Technical Context

**Language/Version**: Flutter (Dart)
**Primary Dependencies**: `flutter_riverpod`, `drift` (SQLite), `shimmer`, `google_fonts`
**Storage**: Drift (SQLite) - on-device only, no remote sync.
**Testing**: `flutter test` (Widget and Unit tests)
**Target Platform**: Android (Pixel 6a) / iOS
**Project Type**: Open Source mobile application
**Performance Goals**: Slide-up animation < 300ms, immediate tap-to-game transition.
**Constraints**: 100% offline, privacy-first (no telemetry), scientific citations required.
**Scale/Scope**: Part of the Flanker game module (one of three MVP games).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Scientific Honesty**: Citations for Eriksen & Eriksen (1974) and selective attention summary are properly included in the spec.
- **II. Privacy by Default**: Stats are calculated locally from the on-device Drift database. No external network calls.
- **III. Design**: Implementation will utilize the Electric Nocturne palette (#150629 background, #301a4d surface, #ff8aa7 accent).
- **VI. Scope Discipline**: This feature enhances the existing Flanker game within the 3-game MVP scope.

## Project Structure

### Documentation (this feature)

```text
specs/007-game-detail-sheet/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/          # Validation checklists
└── tasks.md             # Implementation tasks
```

### Source Code (repository root)

```text
lib/
├── database/            # Drift schema and DAOs (update for Best RT logic)
├── models/              # DTOs and entities
├── providers/           # Home and Stats state management
├── screens/             # UI Components (update HomeScreen, add FlankerDetailSheet)
└── widgets/             # Specialized UI (StatChip, ShimmerSkeleton)
```

**Structure Decision**: Standard Flutter project structure. We will enhance the existing `screens/` and `database/` directories.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None      | N/A        | N/A                                 |
