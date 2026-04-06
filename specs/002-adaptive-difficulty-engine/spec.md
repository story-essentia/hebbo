# Feature Specification: Adaptive Difficulty Engine

**Feature Branch**: `002-adaptive-difficulty-engine`  
**Created**: 2026-04-05  
**Status**: Draft  
**Input**: User description: "Build the adaptive difficulty engine for Hebbo. Logic only, Riverpod state management, 20-trial up-window, 10-trial down-window."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic Difficulty Calibration (Priority: P1)

As a user training my brain, I want the game to automatically get harder when I'm performing well and easier when I'm struggling, so that I stay in the "Goldilocks zone" of optimal cognitive challenge.

**Why this priority**: Core engine logic that directly implements the Hebbo principle of effective training. It is the heart of the "Brain Training" value proposition.

**Independent Test**: Can be fully tested via unit tests by simulating sequences of correct/incorrect trials and verifying the current level changes according to the defined thresholds.

**Acceptance Scenarios**:

1. **Given** a new session starting at Level 1, **When** I complete 20 consecutive correct trials, **Then** the level increments to 2 and both tracking windows are cleared.
2. **Given** I am at Level 5 with a full 10-trial window, **When** the accuracy in that window drops below 60% after an incorrect trial, **Then** the level decrements to 4 and both tracking windows are cleared.
3. **Given** I have just leveled up to Level 3, **When** I complete 19 more correct trials, **Then** the level remains at 3 (it must wait for the full 20-trial window again).
4. **Given** I have 9 incorrect trials in a row, **When** the 10th trial is correct, **Then** the level does not decrement (threshold evaluation only happens after failures).

---

### Edge Cases

- **Lower Bound**: What happens when accuracy drops below 60% while at Level 1?
  - *Behavior*: The level remains at 1 (min floor), but windows are still cleared (Slate Reset).
- **Upper Bound**: What happens when accuracy reaches 80% while at Level 10?
  - *Behavior*: The level remains at 10 (max ceiling), but windows are still cleared (Slate Reset).
- **Partial Windows**: How does the system handle evaluations before the windows are full?
  - *Behavior*: No evaluation triggers are fired until the `upWindow` has 20 entries or `downWindow` has 10 entries respectively.
- **Incorrect Peak**: If the 20th trial for a level-up evaluation is incorrect, does it block progress?
  - *Behavior*: Yes, because the average drops below 80% across the 20-trial window.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST maintain a `currentLevel` integer bounded between 1 and 10.
- **FR-002**: System MUST maintain a rolling `upWindow` of the last 20 trial results (booleans).
- **FR-003**: System MUST maintain a rolling `downWindow` of the last 10 trial results (booleans).
- **FR-004**: System MUST increment level IF `upWindow` is full AND accuracy is ≥ 80%.
- **FR-005**: System MUST decrement level IF `downWindow` is full AND accuracy is < 60% AND the last trial reported was incorrect/timeout.
- **FR-006**: System MUST perform a "Slate Reset" (clearing both windows) immediately after any level change.
- **FR-007**: System MUST read the initial level from local storage at the start of a session.
- **FR-008**: System MUST write the final level to local storage ONLY at the end of a session.

### Key Entities *(include if feature involves data)*

- **DifficultyState**: Represents the current engine state.
  - `currentLevel`: int (1-10)
  - `upWindow`: List<bool> (max 20)
  - `downWindow`: List<bool> (max 10)
- **DifficultyRepository**: Interface to persist/retrieve the `currentLevel` between sessions.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of defined logic paths (level up, level down, boundaries, slate reset) are covered by automated unit tests.
- **SC-002**: Engine state updates (reportTrial) complete in under 1ms to ensure zero frame-drop during game loops.
- **SC-003**: Data is persisted exactly once per session (on exit) to avoid unnecessary SQLite overhead during gameplay.
- **SC-004**: No UI components or animation logic are introduced in this milestone.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Dependency on local-first architecture for all data persistence]
- [Assumption: A "timeout" is reported to the engine as a `correct: false` trial result.]
- [Assumption: Rolling windows strictly use the last N trials; if a window is not full, the level cannot change.]
