# Feature Specification: Flanker Game Loop

**Feature Branch**: `003-flanker-game-loop`  
**Created**: 2026-04-06  
**Status**: Draft  
**Input**: User description: "Build the Flanker game loop for Hebbo. This milestone builds a fully working game session with placeholder visuals — no Rive animation yet. The game must be completely playable and all trial data must be correctly recorded."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Core Playing Experience (Priority: P1)

As a user, I want to play a full session of the Flanker game with clear visual indicators and responsive tap zones so that I can focus entirely on the cognitive task.

**Why this priority**: This is the core interactive component of the milestone. Without the game loop, there is no application.

**Independent Test**: A user can launch the Flanker game, complete all 75 trials using screen taps, see immediate correct/incorrect feedback, and reach the end screen.

**Acceptance Scenarios**:

1. **Given** the stimuli are displayed, **When** I tap the side matching the center arrow within 2000ms, **Then** the center rectangle flashes green and the next trial begins after a pause.
2. **Given** the stimuli are displayed, **When** I tap the opposite side, **Then** the center rectangle flashes red and the next trial begins after a pause.
3. **Given** the stimuli are displayed, **When** I do not tap within 2000ms, **Then** all rectangles dim and the trial is recorded as a timeout.

---

### User Story 2 - Real-time Difficulty Adaptation (Priority: P1)

As a user, I want the difficulty and speed of the game to adjust to my performance during the session so that I am consistently challenged at my current skill level.

**Why this priority**: Implements the fundamental brain training mechanism of adaptive challenge.

**Independent Test**: After a series of 20 correct trials, the user should observe the inter-stimulus interval decreasing and/or the frequency of incongruent trials increasing (per the level-to-ratio mapping).

**Acceptance Scenarios**:

1. **Given** I am at Level 1, **When** a new trial is generated, **Then** it has a 30% chance of being incongruent.
2. **Given** the difficulty has scaled to Level 5, **When** a new trial is generated, **Then** the inter-stimulus interval between trials is exactly 800ms.

---

### User Story 3 - Persistence of Training Data (Priority: P1)

As a user, I want my performance data to be saved automatically at the end of a session so that I can track my improvement over time.

**Why this priority**: Essential for the value proposition of longitudinal cognitive tracking.

**Independent Test**: After completing trial 75, the application is closed and reopened, and the data remains available in the local database.

**Acceptance Scenarios**:

1. **Given** I complete trial 75, **When** the session ends, **Then** exactly 75 records are written to the `trials` table and one record is written to the `sessions` table.
2. **Given** I force-close the app during a session, **When** I check the database later, **Then** no partial session data or trials from that session were recorded (Force-quit safety).

### Edge Cases

- **Premature Tapping**: Taps made during the inter-stimulus interval or before the stimuli appear must be ignored to prevent accidental inputs.
- **Extreme Latency**: If the device slows down, the reaction time calculation must correctly use the absolute stimulus appearance timestamp to maintain millisecond accuracy.
- **Database Failure**: While rare for local SQLite, the session state must be handled gracefully to avoid corrupting the difficulty level if the save operation fails.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display five horizontal rectangles; the center rectangle is the target featuring a left/right arrow or letter.
- **FR-002**: System MUST implement two screen-wide tap zones (Left/Right) covering the entire interactive area.
- **FR-003**: System MUST support 10 levels of difficulty with specific Congruent/Incongruent ratios:
    - Level 1: 30% Incongruent ... Level 5: 50% Incongruent ... Level 10: 70% Incongruent.
- **FR-004**: System MUST support 10 levels of inter-stimulus intervals:
    - Level 1: 1500ms ... Level 5: 800ms ... Level 10: 400ms.
- **FR-005**: System MUST measure Reaction Time (RT) in milliseconds from stimulus onset to tap.
- **FR-006**: System MUST record trials as "Timeout" after 2000ms of inactivity, counting as incorrect.
- **FR-007**: System MUST provide visual feedback: Center rectangle flashes Green (Success) or Red (Failure) for 200ms after input.
- **FR-008**: System MUST write all 75 trials and the session summary to the `TrialRepository` and `SessionRepository` ONLY upon completion of the 75th trial.
- **FR-009**: System MUST navigate to a session end screen featuring: "Play again", "See progress", and "Back to menu" buttons.

### Key Entities *(include if feature involves data)*

- **AdaptiveEngineNotifier**: Manager of the current difficulty state (Level 1-10).
- **TrialRecord**: Persistent data for a single trial (RT, correctness, level, stimulus type).
- **SessionRecord**: Persistent metadata for a 75-trial sequence.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of trials in a completed session are persisted with matching timestamps and levels.
- **SC-002**: Transition between trials (Inter-stimulus interval) is accurate to within ±20ms of the target duration for the current level.
- **SC-003**: The application maintains 60 FPS during stimuli display to ensure precise visual timing for the user.
- **SC-004**: Zero data is written to persistence if the user exits the session before reaching the 75th trial.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Every game has independent evidence for cognitive transfer before shipping]
- [Dependency on local-first architecture for all data persistence]
- [Assumption: Visual feedback flash duration is fixed at 200ms and does not overlap with the inter-stimulus interval calculation.]
