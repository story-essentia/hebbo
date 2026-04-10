# Feature Specification: Fish Animation Integration

**Feature Branch**: `004-fish-animation-integration`  
**Created**: 2026-04-09  
**Status**: Draft  
**Input**: User description: "Integrate /lib/widgets/animated_fish.dart into the Flanker game loop from Milestone 3. The file is complete and working — do not rewrite it."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Immersive Ocean stimuli (Priority: P1)

As a user, I want to see beautifully animated fish instead of placeholder rectangles so that the brain training experience feels like a high-quality game rather than a medical tool.

**Why this priority**: This upgrade fulfills the "Design is a First-Class Requirement" principle of the Hebbo constitution.

**Independent Test**: Launch the Flanker game and verify that five animated fish are displayed on a dark background, with the center fish being slightly larger and distinct from the flankers.

**Acceptance Scenarios**:

1. **Given** a new trial begins, **When** the stimuli appear, **Then** I see five fish swimming in neutral states with subtle bubble animations.
2. **Given** I am looking at the stimuli, **When** I observe the center fish, **Then** it is visually larger (280x280) compared to the flanking fish (240x240).

---

### User Story 2 - Responsive Directional Feedback (Priority: P1)

As a user, I want the fish to react to my taps and provide clear visual confirmation of my performance so that I can adjust my focus in real-time.

**Why this priority**: Direct feedback is essential for reinforcing the cognitive training goal of the Flanker task.

**Independent Test**: Complete a series of trials and verify that the center fish reacts differently to correct vs. incorrect taps, and that all fish transition together after a timeout.

**Acceptance Scenarios**:

1. **Given** the stimulu is active, **When** I tap the correct side, **Then** the center fish enters a "Correct" swimming state (with ripples/glow) for 400ms before the next trial.
2. **Given** the stimulu is active, **When** I tap the wrong side, **Then** the center fish enters a "Wrong" swimming state for 400ms.
3. **Given** the stimuli is active, **When** the 2000ms timer expires without input, **Then** all five fish enter a "Timeout" state (40% opacity, no ripples) for 300ms.

---

### User Story 3 - Bi-directional Animation (Priority: P1)

As a user, I want the fish to face naturally in both directions (left and right) so that the game loop accurately reflects the randomized trial configurations.

**Why this priority**: The Flanker task requires stimuli to face both directions; horizontal mirroring is a technical requirement for visual consistency.

**Independent Test**: Verify that in a session with mixed trials, fish can face both left and right without looking distorted or "jumping" positions.

**Acceptance Scenarios**:

1. **Given** a trial with a "Right" target, **When** the target fish appears, **Then** it is horizontally mirrored (facing right) compared to its default left-facing state.
2. **Given** a "Left" flanking fish, **When** it appears, **Then** it faces left naturally.

### Edge Cases

- **Fast Sequential Tapping**: If a user taps during the 400ms feedback window, the input must be ignored until the next trial begins.
- **State Transition Race**: If a timeout occurs exactly as a user taps, the system must prioritize the user input if it was registered within the 2000ms window.
- **Low Power Mode**: Animations must degrade gracefully if the device cannot maintain 60FPS, ensuring directional cues remain visible even if frame rate drops.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST integrate the existing `animated_fish.dart` widget into the Flanker game loop.
- **FR-002**: System MUST add the `path_drawing` dependency to `pubspec.yaml`.
- **FR-003**: System MUST extend the `FishState` enum to support 7 states:
    - Neutral: `swimLeftNeutral`, `swimRightNeutral`
    - Correct: `swimLeftCorrect`, `swimRightCorrect`
    - Wrong: `swimLeftWrong`, `swimRightWrong`
    - Timeout: `timeoutNeutral`
- **FR-004**: System MUST implement horizontal mirroring for "Right" states using `canvas.scale(-1, 1)` and `canvas.translate(-size.width, 0)` in the `_FishPainter`.
- **FR-005**: System MUST implement a `timeoutNeutral` visual: 40% opacity, no ripples, no glow, using `canvas.saveLayer`.
- **FR-006**: System MUST create a `FishRowWidget` to manage the layout of five fish stimuli.
- **FR-007**: System MUST size the center target fish at 280x280 and flanking fish at 240x240.
- **FR-008**: System MUST suppress bubble animations during feedback (Correct/Wrong) states to reduce visual clutter.
- **FR-009**: System MUST update the game state machine to transition through:
    - Stimulus (Neutral) -> Input -> Feedback (400ms) -> Next Trial.
    - Stimulus (Neutral) -> Timeout -> Feedback (300ms) -> Next Trial.

### Key Entities *(include if feature involves data)*

- **FishState**: The state machine driving the individual fish animation and color palette.
- **FishRowWidget**: The UI component for the horizontal stimuli row.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Application maintains 60 FPS on the Pixel 6a during stimulus animation.
- **SC-002**: Feedback animation duration is accurate to within ±16ms (one frame).
- **SC-003**: Zero visual "jitter" when transitioning from Neutral to mirrored Right variants.
- **SC-004**: Memory usage increase after adding animations is less than 50MB.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Assumption: The `animated_fish.dart` file provided is compatible with standard Flutter CustomPainter patterns.]
- [Assumption: Target device Pixel 6a has sufficient GPU headroom for five concurrent custom animations.]
