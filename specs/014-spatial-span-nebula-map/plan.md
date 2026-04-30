# Implementation Plan: Spatial Span Nebula Map & Track 2

**Branch**: `014-spatial-span-nebula-map` | **Date**: 2026-04-28 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/014-spatial-span-nebula-map/spec.md`

## Summary

Implement the progression UI and advanced mechanics for the Spatial Span game. This involves building the "Nebula Map", an interactive node-based view of the player's unlocked Spans (Track 1) and Branches (Track 2). The map will be backed by a new Drift database entity tracking `max_span_reached`. Additionally, Track 2 will introduce "Visual Noise"—distractor shards pulsing during the demonstration phase.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: flutter_riverpod, drift, sqlite3_flutter_libs, path_provider  
**Storage**: Drift (SQLite) for on-device persistence  
**Testing**: Widget tests for map rendering, unit tests for Drift queries  
**Target Platform**: Linux/Mobile (offline-first, premium aesthetic)  
**Project Type**: Open Source, mobile/desktop application  
**Performance Goals**: 60fps animations for map panning and visual noise  
**Constraints**: Offline-only, Privacy-first (no data collection), Scientific evidence for games  
**Scale/Scope**: Progression UI for Spatial Span, Database persistence, 1 new game mechanic.  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Scientific Honesty**: Visual distractors are a common variant in working memory tasks (e.g., Corsi with interference). **PASS**.
- **II. Privacy by Default**: All progression data is stored locally via Drift SQLite. **PASS**.
- **III. Design**: Nebula map and signature pink branches align with the Electric Nocturne aesthetic. **PASS**.
- **VI. Scope Discipline**: Scope is constrained to the requested MVP tracking and mechanics. **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/014-spatial-span-nebula-map/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (created by /speckit-tasks)
```

### Source Code (repository root)

```text
lib/
├── database/
│   ├── database.dart                 # Drift DB updates
│   ├── tables/
│   │   └── spatial_span_progress.dart # New entity
├── providers/
│   ├── spatial_span_provider.dart    # Logic updates for Track 2 noise
│   └── spatial_span_progress_provider.dart # DB State management
├── screens/
│   └── nebula_map_screen.dart        # Main UI
└── widgets/
    └── nebula_map_painter.dart       # CustomPainter for constellation
```

**Structure Decision**: Integrated into existing Flutter architecture, extending the database layer and introducing new screens/providers.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | -          | -                                   |
