# Feature Specification: Dynamic Level-Based Environments

**Feature Branch**: `009-dynamic-environments`  
**Created**: 2026-04-17  
**Status**: Draft  
**Input**: User description: "A user who has sustained high performance across multiple sessions sees their environment change at the start of a new session — from shallow reef to open ocean, or open ocean to deep sea. Environment unlocks are the mastery signal and long-term retention mechanic. Levels 1-3: Shallow reef; 4-7: Open ocean; 8-10: Deep sea. Build three animated backgrounds with CustomPainter + parallax layers. Transitions should feel like forward movement."

## Clarifications

### Session 2026-04-17
- Q: How should the parallax layers visually behave during the trial-reset animation to create this effect? → A: Temporal Acceleration: Dramatically increase the vertical speed of the current parallax particles for the duration of the reset.
- Q: How should these particles be positioned when a game session first starts? → A: Global Randomization: Particles are initialized at random X and Y coordinates across the full screen dimensions.
- Q: Should the background animations continue playing when the game is manually paused by the user? → A: Synchronous Pause: Background animations stop completely when the game is paused.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Environment Progression (Priority: P1)

As a player, I want to see my training environment transform as I reach higher difficulty levels, so that I feel a tangible sense of mastery and progression in the game.

**Why this priority**: Environment unlocks are the primary mastery signal and long-term retention mechanic for the cognitive training suite.

**Independent Test**: Can be fully tested by simulating level changes (Level 3 -> Level 4, Level 7 -> Level 8) and confirming the background widget swaps correctly.

**Acceptance Scenarios**:

1. **Given** I am at Level 3, **When** I start a new session at Level 4, **Then** the background must transition from Shallow Reef to Open Ocean.
2. **Given** I am at Level 7, **When** I start a new session at Level 8, **Then** the background must transition from Open Ocean to Deep Sea.
3. **Given** a new session starts at any level, **When** the game screen loads, **Then** the background must persist throughout the session.

---

### User Story 2 - Forward Movement Feedback (Priority: P2)

As a player, I want to feel like I am swimming forward into the ocean when the game resets between trials, so that the training loop feels dynamic and immersive.

**Why this priority**: Enhances the "game-feel" and provides a satisfying visual reward for completing a trial, reinforcing the training loop.

**Independent Test**: Can be tested by completing a trial and observing the parallax speed increase during the dynamic reset animation (duration controlled by `resetDurationMs`).

**Acceptance Scenarios**:

1. **Given** a trial is complete, **When** the fish enters the "top-down" state and swims forward (towards the top), **Then** the background particles must move rapidly downwards (e.g., 8-10x speed) to simulate vertical depth progression for the duration of the reset phase.

---

### User Story 3 - Immersive Visuals (Priority: P3)

As a player, I want high-quality, animated backgrounds with parallax depth, so that the training experience feels premium and reduces visual fatigue during long sessions.

**Why this priority**: Aligns with Hebbo's "Rich Aesthetics" design principle to wow the user at first glance.

**Independent Test**: Can be tested by observing the background for 10 seconds and confirming all 3 parallax layers (foreground, midground, background) are moving at different speeds.

**Acceptance Scenarios**:

1. **Given** any environment, **When** animating, **Then** I must see simple, non-distracting vertical particles (bubbles or micro-glows) moving Top-to-Bottom at two distinct parallax speeds.

---

## Edge Cases

- **Level Boundary Jumps**: What happens if a user jumps from Level 2 to Level 5 (e.g., via rapid mastery)? The system must correctly select the Level 5 environment (Open Ocean).
- **Session Interruption**: If a session is paused and resumed, the background animation controller must maintain its state or resume smoothly without a visual "jump" in particle positions.
- **Device Rotation/Resize**: How does the `CustomPainter` handle sudden changes in canvas size? All parallax layers must wrap relative to the new width without breaking the looping pattern.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST dynamically select a background widget based on the current level:
  - Levels 1-3: `ShallowReefBackground`
  - Levels 4-7: `OpenOceanBackground`
  - Levels 8-10: `DeepSeaBackground`
- **FR-002**: `ShallowReefBackground` MUST implement:
  - Background Gradient: `#007a8a` (Top) to `#004050` (Bottom).
  - Layers: Max 2 parallax layers.
  - Elements: Small translucent bubbles (radius 1-2.5, white alpha 0.2), moving Top-to-Bottom.
- **FR-003**: `OpenOceanBackground` MUST implement:
  - Background Gradient: `#04285a` (Top) to `#021438` (Bottom).
  - Layers: Max 2 parallax layers.
  - Elements: Micro-particles (size 1, white alpha 0.3), moving Top-to-Bottom.
- **FR-004**: `DeepSeaBackground` MUST implement:
  - Background Gradient: `#010810` (Top) to `#000205` (Bottom).
  - Layers: Max 2 parallax layers.
  - Elements: Bioluminescent glowing dots (radius 1.5-3.0, cyan/blue alpha 0.4), moving Top-to-Bottom.
- **FR-005**: All backgrounds MUST use a single looping `AnimationController` to drive vertical parallax positions. The animation MUST pause when the game is in a paused state.
- **FR-006**: Background layers MUST implement vertical screen wrapping logic (resetting Y position when it passes Height) to ensure infinite looping.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Background widget swaps occur within 1 frame (sub-16ms) of session initialization once a level requirement is met.
- **SC-002**: Animation rendering MUST maintain 60 FPS (or device refresh rate) on target hardware (Pixel 6a) during full game play.
- **SC-003**: Background transition during the level-specific trial-reset phase MUST use temporal acceleration (multiplied parallax speed) to create a cohesive sense of forward movement.
- **SC-004**: Memory usage for the `CustomPainter` layers MUST not exceed 10MB across all active layers.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Assumption about performance: Parallax calculations are simple enough for standard Canvas drawing without requiring a dedicated game engine like Flame]
- [Dependency on local-first architecture for all data persistence]
