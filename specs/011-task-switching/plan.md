# Implementation Plan: Task Switching (Neon Orb Task Switcher)

**Branch**: `011-task-switching` | **Date**: 2026-04-22 | **Spec**: [specs/011-task-switching/spec.md](file:///home/samuelmorse/Projects/hebbo/specs/011-task-switching/spec.md)
**Input**: Feature specification from `/specs/011-task-switching/spec.md`

## Summary

Implement the Task Switching cognitive training game using the Rogers & Monsell (1995) paradigm. The game features a centered "Neon Orb" stimulus that alternates between Parity (Odd/Even) and Magnitude (High/Low) rules with color-coded border cues. It tracks "Switch Cost" as the primary improvement metric and uses an adaptive engine to modulate switch probability and response deadlines.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: `flutter_riverpod`, `just_audio`, `drift`, `audio_session`  
**Storage**: Drift (SQLite) on-device persistence  
**Testing**: `flutter_test` (Unit/Widget)  
**Target Platform**: Android/iOS (Mobile native via Flutter)
**Project Type**: Open Source Brain Training App  
**Performance Goals**: 60fps jitter-free animations for CustomPainter Neon Orb and background particles.  
**Constraints**: Offline-only, Privacy-first (no analytics/remote sync).  
**Scale/Scope**: 2nd core game of the 3-game MVP.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

1. **Scientific Honesty**: PARITY-MAGNITUDE task switching is a robustly researched paradigm with peer-reviewed evidence for switch-cost reduction (Rogers & Monsell, 1995). **PASS**
2. **Privacy**: Data stored locally in SQLite via Drift. No network requests. **PASS**
3. **Design**: Neon Orb/Electric Nocturne aesthetic adheres to premium visuals requirement. **PASS**
4. **Scope Discipline**: Part of the 3-game MVP. No social or remote features. **PASS**

## Project Structure

### Documentation (this feature)

```text
specs/011-task-switching/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (future)
```

### Source Code

```text
lib/
├── providers/
│   ├── task_switch_provider.dart  # Business logic & state management
│   └── audio_provider.dart        # Audio feedback integration
├── models/
│   ├── task_switch_models.dart    # Drift table definitions & DTOs
├── screens/
│   ├── task_switch_screen.dart    # UI & Tap zones
│   └── session_end_placeholder.dart (Reuse existing)
└── widgets/
    ├── neon_orb_painter.dart      # CustomPainter implementation
    └── particle_background.dart    # Particle system implementation
```

**Structure Decision**: Single project structure following existing feature patterns established in the Flanker implementation.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |
