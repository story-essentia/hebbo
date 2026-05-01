# Implementation Plan: Premium Progression Map

**Branch**: `015-premium-progression-map` | **Date**: 2026-05-01 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/015-premium-progression-map/spec.md`

## Summary

This feature updates the Progression Map to permanently display all three tracks from the beginning (Tracks 1, 2, and 3), providing visibility into the full game scope. It also significantly upgrades the visual aesthetic of the map, replacing simple flat lines and solid circles with premium gradients, outer glows, and richer node rendering that aligns with the game's high-fidelity neon aesthetic.

## Technical Context

**Language/Version**: Dart / Flutter  
**Primary Dependencies**: Flutter SDK, riverpod  
**Storage**: Drift (SQLite) / SharedPreferences (Existing on-device persistence, no changes needed for this feature)  
**Testing**: Flutter test  
**Target Platform**: Android/iOS (Mobile offline-first)  
**Project Type**: Open Source Mobile App  
**Performance Goals**: 60fps rendering in `CustomPainter`  
**Constraints**: Offline-only, Privacy-first, pure UI refactoring without altering game logic.  
**Scale/Scope**: Progression Map UI visual enhancements.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Scientific Honesty**: N/A (UI change only).
- **Privacy by Default**: Passes (No data collection or transmission added).
- **Design is a First-Class Requirement**: Passes heavily (This feature directly fulfills this principle by upgrading the UI to feel premium and engaging).
- **Open Source**: Passes (Code remains open source).
- **Scope Discipline**: Passes (Operates entirely within the MVP 3-game boundary).

## Project Structure

### Documentation (this feature)

```text
specs/015-premium-progression-map/
├── plan.md              
├── research.md          
├── data-model.md        
├── quickstart.md        
└── contracts/           
```

### Source Code (repository root)

```text
lib/
├── screens/
│   └── progression_map_screen.dart (Modifying logic for rendering nodes)
└── widgets/
    └── backgrounds/
        └── progression_map_painter.dart (Upgrading painting routines)
```

**Structure Decision**: Single Flutter project structure modifying the specific UI painting logic.
