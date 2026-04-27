# Feature Specification: Spatial Span Game Milestone 1

**Feature Branch**: `013-spatial-span-game`  
**Created**: 2026-04-27  
**Status**: Draft  
**Input**: User description: "I am building Game 003: Spatial Span. This is a cognitive training game based on the Corsi Block-Tapping task, but styled with a premium 'Electric Nocturne' 2D aesthetic. Objective for Milestone 1: Build the 'Luminous Shard' visual component and the core gameplay loop for 'Track 1: Foundation' (Forward Recall + Static Field)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Shard Visualization & Interaction (Priority: P1)

As a player, I want to see "Luminous Shards" that feel physical and premium. When a shard is part of a sequence, it should pulse vividly, and when I tap it, it should provide visceral visual feedback.

**Why this priority**: Essential for the "Electric Nocturne" aesthetic and user engagement. The shard is the primary interactive element.

**Independent Test**: Can be fully tested by rendering a single shard and triggering a "pulse" state via a test toggle, observing the 1.2x scale and ring emission.

**Acceptance Scenarios**:

1. **Given** a Shard widget, **When** it is in the 'idle' state, **Then** it shows a geometric shape with a soft radial glow.
2. **Given** a Shard widget, **When** it is 'activated' or 'tapped', **Then** it scales up to 1.2x and emits a visual "ring" animation before returning to idle.

---

### User Story 2 - Forward Recall Gameplay (Priority: P1)

As a player, I want to observe a sequence of shards lighting up one-by-one and then attempt to tap them back in the exact same order. This is the core cognitive challenge of the game.

**Why this priority**: This is the core MVP loop of the Spatial Span task.

**Independent Test**: Can be tested by starting a trial, observing a sequence of 3 shards, and tapping them in order.

**Acceptance Scenarios**:

1. **Given** a sequence of N shards, **When** the demonstration phase begins, **Then** each shard in the sequence pulses sequentially with a 1000ms interval.
2. **Given** the recall phase is active, **When** the user taps the shards in the correct sequence, **Then** the trial is marked as successful.
3. **Given** the recall phase is active, **When** the user taps an incorrect shard, **Then** the trial is marked as failed immediately.

---

### User Story 3 - Adaptive Span Advancement (Priority: P2)

As a player, I want the game to get harder only when I demonstrate mastery. The game should follow the "2-out-of-3" clinical standard to ensure I am challenged but not overwhelmed.

**Why this priority**: Essential for the "Adaptive Difficulty" principle of the app.

**Independent Test**: Play 3 trials at Span 3. If 2 are correct, verify the next trial is Span 4. If only 1 is correct, verify the session ends or remains at Span 3 (depending on session rules).

**Acceptance Scenarios**:

1. **Given** Span N, **When** the user completes 2 trials successfully within a block of 3, **Then** the game advances to Span N + 1.
2. **Given** Span N, **When** the user fails 2 trials within a block of 3, **Then** the session terminates or levels down (matching project difficulty rules).

---

### Edge Cases

- **Tap Overlap**: What happens if shards are positioned too close to each other? (Ensure randomized bounding box logic prevents overlap).
- **Session Interruption**: What happens if the user leaves the screen during a sequence? (Engine must stop timers and clean up state).
- **Rapid Tapping**: What happens if the user taps shards before the demonstration phase is over? (Interaction must be disabled during demonstration).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST implement a `ShardPainter` using `CustomPainter` to render geometric (pentagon/hexagon) shards.
- **FR-002**: Shards MUST feature a radial gradient and `MaskFilter.blur` to create a soft neon glow effect.
- **FR-003**: System MUST implement a "Pulse" animation (1.2x scale + ring emission) for shard activation.
- **FR-004**: System MUST use a `SpatialSpanEngine` (Riverpod) to manage the game state, sequence generation, and input validation.
- **FR-005**: The engine MUST generate sequences of $N$ shards randomly within a 3x3 bounding grid (default behavior).
- **FR-006**: The engine MUST enforce a 1000ms interval between sequence pulses during the demonstration phase.
- **FR-007**: System MUST enforce the "2-out-of-3" success rule for span advancement.
- **FR-008**: The game background MUST use color `#150629` with subtle, drifting neon particles.
- **FR-009**: The UI MUST follow the "No-Line Rule"—no distinct borders; shapes defined by tonal shifts and glows.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of shards render at 60fps even with multiple blur layers on the target hardware.
- **SC-002**: Sequence demonstration timing is accurate within +/- 50ms of the 1000ms target.
- **SC-003**: Input validation correctly identifies correctness in 100% of recall attempts.
- **SC-004**: Users report the shard interaction feels "responsive" and "premium" (qualitative).

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No complex animations or 3D transformations for Milestone 1 beyond simple 2D scaling and ring emission]
- [MANDATORY SCIENTIFIC HONESTY: The "2-out-of-3" rule is implemented following standard neuropsychological testing protocols for the Corsi task]
- [Assumption about shard positions: For Milestone 1, shards are positioned in a static but randomized field per trial, rather than moving during the trial]
- [Dependency on `just_audio`: Audio feedback for correct/incorrect taps will reuse existing SFX assets]
