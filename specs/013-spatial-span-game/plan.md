# Implementation Plan: Spatial Span Game Milestone 1

**Branch**: `013-spatial-span-game` | **Date**: 2026-04-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/013-spatial-span-game/spec.md`

## Summary

Build the foundational milestone for Game 003: Spatial Span. This involves creating a custom-painted "Luminous Shard" component with organic neon glows and a Riverpod-driven gameplay engine that implements the "2-out-of-3" Corsi Block logic. The implementation will focus on high-performance 2D rendering and smooth state transitions between the demonstration and recall phases.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: flutter_riverpod, just_audio, path_provider (standard stack)  
**Storage**: On-device only (SQLite via established repo patterns)  
**Testing**: Unit tests for sequence generation, performance profiling for CustomPainter effects.  
**Target Platform**: Linux/Mobile (offline-first, premium aesthetic)  
**Project Type**: Open Source, mobile/desktop application  
**Performance Goals**: 60fps animations, sub-100ms response to taps.  
**Constraints**: No external 3D engines, "No-Line Rule" for UI boundaries.  
**Scale/Scope**: Milestone 1: Shard component, Core Loop, Adaptive Engine.  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Scientific Honesty**: Corsi Block-Tapping is a validated measure of visual-spatial working memory. **PASS**.
- **II. Privacy by Default**: Local-only execution and storage. **PASS**.
- **III. Design**: High-fidelity shard components and "Electric Nocturne" particles. **PASS**.
- **VI. Scope Discipline**: Milestone 1 focuses strictly on the 2D foundation and core loop. **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/013-spatial-span-game/
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
│   ├── spatial_span_provider.dart    # Game logic & state
├── state/
│   ├── spatial_span_state.dart       # State classes & enums
├── widgets/
│   ├── shard_widget.dart             # Shard container & animation logic
│   ├── shard_painter.dart            # CustomPainter for Shard geometry
│   └── spatial_span_grid.dart        # Grid layout & tap handling
└── screens/
    ├── spatial_span_screen.dart      # Main game view
```

**Structure Decision**: Integrated into existing Flutter architecture under appropriate directories.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | -          | -                                   |
