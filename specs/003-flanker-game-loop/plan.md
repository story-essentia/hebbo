# Implementation Plan: Flanker Game Loop

**Branch**: `003-flanker-game-loop` | **Date**: 2026-04-06 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/003-flanker-game-loop/spec.md)
**Input**: Feature specification from `/specs/003-flanker-game-loop/spec.md`

## Summary

This feature implements the core **Flanker Game** loop. It builds a fully playable 75-trial session using placeholder visuals. The game integrates with the previously built `AdaptiveEngineNotifier` to adjust difficulty (congruency ratios and timing) in real-time. Performance data is buffered in memory and persisted to the Drift database only upon successful session completion. Verification is handled via unit tests for the game logic and manual verification on a physical device for timing and responsiveness.

## Technical Context

**Language/Version**: Flutter 3.x, Dart 3.x  
**Primary Dependencies**: `flutter_riverpod`, `drift`, `mocktail`  
**Storage**: Results persisted via `TrialRepository` and `SessionRepository`.  
**Architecture**: Riverpod State Management.
**Complexity**: High (precise timing, adaptive integration, safe persistence).
**Constraints**: [MANDATORY: Offline-only, Logic-first, No Rive animations yet]  
**Scale/Scope**: [MANDATORY: 1 Game Screen, 1 Game Notifier, 75 Trials]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Rationale |
|-----------|--------|-----------|
| I. Scientific Honesty | ✅ Pass | Flanker task is a gold-standard executive function assessment. |
| II. Privacy by Default | ✅ Pass | Data stays strictly on-device in the local Drift database. |
| III. Design | ✅ Pass | Responsive tap zones and visual feedback ensure a "Goldilocks zone" trainee experience. |
| IV. Open Source | ✅ Pass | Open methodology for trial generation and scoring. |
| V. Community | ✅ Pass | Game logic is isolated, following the modular interface principle. |
| VI. Scope Discipline | ✅ Pass | Focused strictly on the 75-trial loop and persistence; no extra screens or animations. |

## Project Structure

### Documentation

```text
specs/003-flanker-game-loop/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code

```text
lib/
├── screens/
│   ├── flanker_game_screen.dart        # Main game UI
│   └── session_end_placeholder.dart    # Simple post-session screen
├── providers/
│   └── flanker_game_provider.dart      # In-session state management
└── logic/
    └── flanker_trial_generator.dart    # Pure trial generation logic

test/
└── logic/
    └── flanker_game_test.dart          # Logic and scoring unit tests
```

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

*No violations identified.*
