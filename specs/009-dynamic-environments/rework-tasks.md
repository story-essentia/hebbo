# Tasks: Dynamic Level-Based Environments (REWORK)

**Goal**: Redesign environments for simplicity and switch to vertical (Top-to-Bottom) movement to align with the "swimming forward" top-down animation.

## Phase 1: Infrastructure Pivot

- [X] T022 Update `BaseParallaxPainter` to handle vertical (Y) wrapping instead of horizontal (X) wrapping.
- [X] T023 Update `EnvironmentOrchestrator` to drive vertical offsets.

## Phase 2: Simplified Environments (US1 + US3 Rework)

- [X] T024 [P] Redesign `ShallowReefBackground` with simple vertical bubbles and 2 layers.
- [X] T025 [P] Redesign `OpenOceanBackground` with simple vertical micro-particles and 2 layers.
- [X] T026 [P] Redesign `DeepSeaBackground` with simple vertical glowing dots and 2 layers.

## Phase 3: Feedback Rework (US2)

- [X] T027 Verify high-speed vertical downward movement during trial resets.
- [X] T028 Performance profile the simplified painters.
