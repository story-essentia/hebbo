# Implementation Plan: Dynamic Level-Based Environments

**Branch**: `009-dynamic-environments` | **Date**: 2026-04-17 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/009-dynamic-environments/spec.md)

## Summary
Implement three modular background widgets (`ShallowReefBackground`, `OpenOceanBackground`, `DeepSeaBackground`) that change dynamically based on the current level in the Flanker game. These backgrounds use `CustomPainter` with three parallax layers to create depth. Forward progression is simulated by accelerating these animations during the game's trial-reset phase.

## Technical Context

**Language/Version**: Flutter / Dart
**Primary Dependencies**: `flutter_riverpod` (state management)
**Storage**: Drift (On-device Only)  
**Testing**: `flutter_test` (Widget/Unit tests), `integration_test`
**Target Platform**: Android (Pixel 6a) / Linux
**Project Type**: Open Source Application
**Performance Goals**: Consistent 60fps animations, <10MB canvas memory overhead
**Constraints**: Offline-only, Privacy-first (bundled assets)
**Scale/Scope**: Enhancement to Flanker game (Game 1 of 3)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Scientific Honesty**: Success signals (background shifts) are framed as training milestones, not diagnostic improvements.
- **II. Privacy by Default**: All animation assets are generated programmatically (CustomPainter) or bundled locally (Fonts). No remote fetching.
- **III. Design**: Adheres to "Rich Aesthetics" using parallax and HSL-tailored underwater themes.
- **VI. Scope Discipline**: Completes the Flanker game feature set; no new games or social features added.

**Status**: ✅ PASS

## Project Structure

### Documentation (this feature)

```text
specs/009-dynamic-environments/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── widgets/
│   ├── backgrounds/
│   │   ├── base_parallax_painter.dart    # Abstract base for wrapping logic
│   ├── environment_orchestrator.dart # Logic for speed/syncing
│   ├── shallow_reef_background.dart  # FR-002
│   │   ├── open_ocean_background.dart    # FR-003
│   │   └── deep_sea_background.dart      # FR-004
└── screens/
    └── flanker_game_screen.dart          # Integration point
```

**Structure Decision**: Using a dedicated `widgets/backgrounds/` directory to modularize the painters and keep the `flanker_game_screen.dart` clean.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| CustomPainter | Rich animated background | Static images lack the "forward movement" feedback requested. |
| Environment Orchestrator | Sync parallax layers | Independent timers would lead to visual drift over time. |
