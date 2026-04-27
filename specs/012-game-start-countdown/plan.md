# Implementation Plan: Game Start Countdown

**Branch**: `012-game-start-countdown` | **Date**: 2026-04-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/012-game-start-countdown/spec.md`

## Summary

Add a 3-2-1 visual countdown sequence to the Flanker and Task Switching games. This sequence will trigger immediately after the user taps "Play" and before the first stimulus appears. The implementation will involve adding a `countdown` state to the session providers and displaying a high-fidelity overlay using the "Electric Nocturne" design system.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: flutter_riverpod, just_audio  
**Storage**: On-device only (persist nothing for countdown)  
**Testing**: Widget tests for countdown sequence, integration tests for game start delay.  
**Target Platform**: Cross-platform (Linux/Mobile focus), offline-first  
**Project Type**: Open Source, mobile/desktop application  
**Performance Goals**: 60fps animations, sub-100ms transition to trial.  
**Constraints**: Visual consistency with premium theme, no data collection.  
**Scale/Scope**: Flanker and Task Switching modules.  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Scientific Honesty**: Countdown is a standard psychological testing pattern (preparing set) to minimize reaction time artifacts. **PASS**.
- **II. Privacy by Default**: No network/storage activity involved. **PASS**.
- **III. Design**: Countdown will use Plus Jakarta Sans and neon gradients/glows. **PASS**.
- **VI. Scope Discipline**: Limited strictly to Flanker and Task Switching as requested. **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/012-game-start-countdown/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── providers/
│   ├── flanker_game_provider.dart    # Update state for countdown
│   └── task_switch_provider.dart     # Update state for countdown
├── state/
│   ├── flanker_session_state.dart    # Add isCountingDown field
│   └── task_switch_state.dart        # Add isCountingDown field
├── widgets/
│   └── game_countdown_overlay.dart   # NEW: Shared overlay widget
└── screens/
    ├── flanker_game_screen.dart      # Integration
    └── task_switch_screen.dart       # Integration
```

**Structure Decision**: Single project structure within the existing Flutter `lib/` directory.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | -          | -                                   |
