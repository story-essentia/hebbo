# Feature Specification: Task Switching (Neon Orb Task Switcher)

**Feature Branch**: `011-task-switching`  
**Created**: 2026-04-22  
**Status**: Draft  
**Input**: Integrated user vision from Grok interaction. Paradigm: Cued Parity-Magnitude (Rogers & Monsell, 1995). Visuals: Electric Nocturne Neon Orb.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Immersive Task Switching (Priority: P1)

As a player, I want a centered Neon Orb that displays digits and changes border colors (Blue for Parity, Pink for Magnitude), so I can respond to alternating rules using simple left/right tap zones.

**Why this priority**: Core game loop. Reuses existing tap mechanics but introduces the switching cognitive load.

**Independent Test**: Start a session. Verify that responding to "Odd" (Left) on a Blue-bordered "3" and "Higher than 5" (Right) on a Pink-bordered "7" both record as correct.

**Acceptance Scenarios**:

1. **Given** the active rule is Parity (Electric Blue border), **When** a "3" appears and I tap Left (Odd), **Then** the Neon Orb MUST pulse green.
2. **Given** the active rule is Magnitude (Signature Pink border), **When** an "8" appears and I tap Left (Lower than 5), **Then** the Neon Orb MUST shake and flash red.
3. **Given** no input is received within the level-defined interval, **When** time expires, **Then** the stimulus MUST dim/scatter and be recorded as a timeout.

---

### User Story 2 - Switch Cost Analytics (Priority: P2)

As a player, I want my progress chart to show "Switch Cost" (the difference in speed between switching rules vs. repeating them), so I can track my cognitive flexibility gains.

**Why this priority**: Scientific heart of the "Task Switching" training.

**Independent Test**: Finish a session with mixed switch/repeat trials. Verify the summary shows a positive "Switch Cost" value in milliseconds.

---

### User Story 3 - Rapid Adaptive Response (Priority: P3)

As a player, I want the response deadline to tighten as my accuracy improves, forcing me to reconfigure my task-set faster.

**Why this priority**: Standardized challenge progression equivalent to Flanker's speed training.

**Independent Test**: Reach Level 10 and verify the response deadline is 400ms.

## Edge Cases

- **Tap Before Stimulus**: Ignore taps that occur during the 200ms "rearrange" animation between trials.
- **Double Taps**: Only the first tap within a stimulus window counts; subsequent taps are ignored.
- **Force Exit**: If a user exits mid-session, the session is not saved to the persistent database, maintaining data integrity of the performance signal.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST generate 75-trial sessions using digits {1, 2, 3, 4, 6, 7, 8, 9}.
- **FR-002**: System MUST use a randomized trial sequence where the probability of a "Switch" trial increases by level (20% at Level 1, up to 70% at Level 10).
- **FR-003**: System MUST provide immediate visual feedback on the Neon Orb:
    - **Correct**: Green-tinted success pulse.
    - **Incorrect**: Red flash + micro-shake.
    - **Timeout**: Brief scatter/dim effect.
- **FR-004**: Input Mapping MUST be fixed:
    - **Left**: Odd (Parity) OR Lower than 5 (Magnitude).
    - **Right**: Even (Parity) OR Higher than 5 (Magnitude).
- **FR-005**: Boundary Cues MUST be: **Electric Blue** (#00f0ff) for Parity, **Signature Pink** (#ff8aa7) for Magnitude.
- **FR-006**: Adaptive Engine MUST use the same thresholds as Flanker: 90% accuracy to level up, < 80% to level down.
- **FR-007**: Response Deadline for each trial MUST equal the level's ISI (1500ms down to 400ms).

### Key Entities

- **TaskSwitchTrial**: RT (ms), accuracy (correct/wrong/timeout), trialType (switch/repeat), and rule (parity/magnitude).
- **NeonOrbStateMachine**: Manages states: `appear`, `idle`, `feedbackSuccess`, `feedbackFailure`, `timeout`, `rearrange`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of sessions generate valid Switch Cost data (Switch RT - Repeat RT).
- **SC-002**: Visual transition (rearrange fade) between trials completes in exactly 200ms.
- **SC-003**: Adaptive engine correctly adjusts switch probability and response deadline at every level transition.

## Build Strategy (Sequential Milestones)

- **Milestone 1**: Core Loop (Logic, 75 trials, left/right tap, level-based switch probability).
- **Milestone 2**: Neon Orb Visuals (`CustomPainter` implementation and state machine).
- **Milestone 3**: Progress & Metrics (Switch Cost calculation and data persistence).

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: Single 2D background; no multi-environment unlocks for Phase 1]
- [MANDATORY SCIENTIFIC HONESTY: Switch cost reduction is the specific training aim; generalize multitasking claims are avoided]
- [Local Persistence]: All trials saved via existing Drift/SQLite layer.
