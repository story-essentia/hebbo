# Feature Specification: Game Start Countdown

**Feature Branch**: `012-game-start-countdown`  
**Created**: 2026-04-27  
**Status**: Draft  
**Input**: User description: "we need to add a countdown (3, 2, 1) to both games Flanker and Task Switching because when a player taps play they jump in the game too sharply. Dont do anything else, only countdown"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Flanker Countdown (Priority: P1)

When a player starts a Flanker session, they should see a clear visual countdown before the first stimulus appears. This allows the player to prepare their focus and avoid being "jumped" by an immediate trial.

**Why this priority**: High. Prevents user frustration and high initial error rates due to lack of preparation.

**Independent Test**: Can be fully tested by tapping "Play" in the Flanker detail sheet and observing the countdown before the fish appearance.

**Acceptance Scenarios**:

1. **Given** the Flanker detail sheet, **When** I tap "Play", **Then** I see a large "3", then "2", then "1" centered on the screen.
2. **Given** the countdown is active, **When** "1" disappears, **Then** the first Flanker trial begins immediately.

---

### User Story 2 - Task Switching Countdown (Priority: P1)

When a player starts a Task Switching session, they should see the same 3-2-1 countdown sequence. Standardizing this behavior across games ensures a predictable UX.

**Why this priority**: High. Essential for maintaining consistent cognitive preparation across different training modules.

**Independent Test**: Can be fully tested by tapping "Play" in the Task Switching detail sheet and observing the countdown before the first number appears.

**Acceptance Scenarios**:

1. **Given** the Task Switching detail sheet, **When** I tap "Play", **Then** I see the "3, 2, 1" sequence.
2. **Given** the countdown is active, **When** the sequence finishes, **Then** the first Task Switching trial begins.

---

### Edge Cases

- What happens if the user leaves the screen during countdown? (Countdown should stop, resources should be cleaned up).
- What happens if the game is paused during countdown? (Countdown should pause or be ignored until resume).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a full-screen or large centered overlay showing "3", "2", and "1" sequentially.
- **FR-002**: Each number in the countdown MUST remain visible for exactly 1 second.
- **FR-003**: The game logic (trial timers, stimulus presentation) MUST NOT start until the countdown has reached zero.
- **FR-004**: The countdown MUST be visually consistent with the existing "Electric Nocturne" theme (neon colors, premium typography).
- **FR-005**: The transition between countdown numbers MUST be smooth (e.g., subtle fade or scale animation).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of game sessions for Flanker and Task Switching start with the countdown sequence.
- **SC-002**: The transition from countdown to first trial happens in less than 100ms after "1" finishes.
- **SC-003**: Users report a "smoother" and more "prepared" start to training sessions (qualitative).

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user-configurable countdown length; fixed at 3-2-1 for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Behavioral preparation time of 2-3 seconds is standard in psychometric testing to minimize "noise" in reaction time data]
- [Assumption about style: The countdown will use the PlusJakartaSans font already present in the project]
- [Dependency on existing game states: The countdown will be implemented as a new state (e.g., `isCountingDown`) or a wrapper widget that holds trial execution]
