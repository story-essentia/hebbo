# Implementation Plan: Fish Animation Integration

**Feature Branch**: `004-fish-animation-integration`  
**Created**: 2026-04-09  
**Status**: Planning  
**Feature Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/004-fish-animation-integration/spec.md)

## Technical Context

The **Hebbo** application currently implements the Flanker game loop using placeholder rectangles. This feature integrates the `animated_fish.dart` widget, which utilizes `CustomPainter` for 60FPS animations.

### System Overview
- **Flutter Framework**: `CustomPainter` based animations.
- **Dependency**: `path_drawing` for SVG-to-Canvas path rendering.
- **State Management**: Existing Riverpod `FlankerGameNotifier`.

### Known Constraints & Dependencies
- **Asset Constraint**: MUST use existing `/lib/widgets/animated_fish.dart` without rewriting core painter logic.
- **Dependency**: `path_drawing: ^1.0.1` (or latest).
- **Target Hardware**: Pixel 6a (mid-range Android).

### Unknowns (NEEDS CLARIFICATION)
- **Unknown 1**: Does `animated_fish.dart` already handle high-density displays (Device Pixel Ratio)? [NEEDS CLARIFICATION]
- **Unknown 2**: Impact of 5 concurrent `path_drawing` operations on the UI thread for Pixel 6a. [NEEDS CLARIFICATION]

## Constitution Check

| Principle | Impact | Status |
|-----------|--------|--------|
| **I. Scientific Honesty** | Animations are visual-only; cognitive load must remain controlled to avoid distracting from the task. | ✅ ALIGNED |
| **II. Privacy by Default** | All logic and assets are local; no network calls for animations. | ✅ ALIGNED |
| **III. Design as 1st Class** | Replaces rectangles with premium, "delightful" ocean animations. | ✅ ALIGNED |
| **VI. Scope Discipline** | Completes the visual layer of one of the 3 core MVP games. | ✅ ALIGNED |

## Gates & Evaluations

| Gate | Condition | Evaluation |
|------|-----------|------------|
| **Perf Gate** | Must maintain 60 FPS on Pixel 6a. | Planned for validation in Phase 2. |
| **Visual Gate** | No horizontal jitter during mirroring. | Addressed via Canvas translation in FR-004. |

---

## Phase 0: Outline & Research

### Research Tasks
1. **RT-001**: Verify `path_drawing` performance patterns for concurrent painters.
2. **RT-002**: Validate `canvas.scale(-1, 1)` performance behavior on Android Skia/Impeller.
3. **RT-003**: Audit `animated_fish.dart` for bubble animation suppression logic.

### Research Findings (`research.md` results)
*(To be populated after research agents report)*

---

## Phase 1: Design & Contracts

### 1. Data Model (`data-model.md`)
- **Entity**: `FishState` (Enum)
    - `swimLeftNeutral`, `swimRightNeutral`
    - `swimLeftCorrect`, `swimRightCorrect`
    - `swimLeftWrong`, `swimRightWrong`
    - `timeoutNeutral`

### 2. Interface Contracts (`/contracts/`)
- **Widget**: `FishRowWidget`
    - Injected into `FlankerGameScreen`.
    - Reactive to `FlankerSessionState`.
- **Transitions**:
    - Neutral -> Correct/Wrong (400ms duration)
    - Neutral -> Timeout (300ms duration)

### 3. Agent Context Update
- Execute `.specify/scripts/bash/update-agent-context.sh agy` adding `path_drawing`.

---

## Phase 2: Implementation Sequence

> [!IMPORTANT]
> The implementation plan follows a "safe-to-revert" approach. All changes to `animated_fish.dart` must preserve existing logic for other games (if any).

### Step 1: Foundations
- Add `path_drawing` to `pubspec.yaml`.
- Refactor `FishState` enum.

### Step 2: Extended Painter
- Implement horizontal mirroring in `_FishPainter`.
- Implement `timeoutNeutral` opacity/layer rendering.

### Step 3: Layout & Logic
- Build `FishRowWidget`.
- Update `FlankerGameNotifier` to handle the 400ms/300ms feedback timers.

### Step 4: Verification
- Run `flutter analyze`.
- Verify performance on Pixel 6a.
