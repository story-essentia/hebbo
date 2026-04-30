# Feature Specification: Spatial Span Nebula Map & Track 2

**Feature Branch**: `014-spatial-span-nebula-map`  
**Created**: 2026-04-28  
**Status**: Draft  
**Input**: User description: "I have the core shard mechanics and logic for Spatial Span. Now I need to implement the Nebula Map (Progression UI) and Track 2: The Pulse. 1. The Nebula Map UI: Create a NebulaMapView screen. Use a CustomPainter to draw a 'Constellation'—nodes representing Spans (2 through 12) connected by glowing lines. Branching Logic: Track 1 (Electric Blue) is the main vertical trunk. At Span 5, a new branch for Track 2 (Signature Pink) should ignite and branch off to the side. The map must be interactive: Tapping an unlocked node starts a game session at that specific Span and Track. 2. Database Integration: Hook the game up to the Drift database. When a user passes a 2-out-of-3 set, update their max_span_reached for that specific track. The NebulaMapView should refresh to show the newly unlocked nodes/branches. 3. Track 2 Implementation (The Pulse): Implement the logic for Track 2: Forward Recall + Animated Pulsing. Difference from Track 1: During the 'Sequence Flash' phase, add 'Visual Noise'. Other shards on the screen should pulse subtly and randomly to distract the user from the target sequence."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Nebula Map Rendering & Interaction (Priority: P1)

As a player, I want to see a visual "Constellation" representing my progression through the Spatial Span game. I want to see the main Track 1 trunk and, upon reaching Span 5, a branch for Track 2. I want to tap on unlocked nodes to start a training session at that specific difficulty level.

**Why this priority**: The Nebula Map provides the core progression UI and entry point for specific spans, replacing the placeholder "Coming Soon" screen.

**Independent Test**: Can be tested by mocking database progression data (e.g., setting Max Span to 6 on Track 1) and verifying the map renders 6 unlocked nodes, branch 2 becomes visible at node 5, and tapping an unlocked node triggers a session start.

**Acceptance Scenarios**:

1. **Given** the user navigates to the NebulaMapView, **When** they have no previous progress, **Then** only the Span 2 node (Track 1) is unlocked and illuminated.
2. **Given** the user has reached Span 6 on Track 1, **When** they view the map, **Then** Spans 2-6 on Track 1 are unlocked, and the branch for Track 2 (igniting at Span 5) is visible.
3. **Given** the user taps an unlocked node, **When** the node is selected, **Then** the game launches a session pre-configured to that specific Span and Track.

---

### User Story 2 - Progression State Persistence (Priority: P1)

As a player, I want my progress (specifically, the maximum span I've successfully completed via the 2-out-of-3 rule) to be saved automatically. When I return to the app, the Nebula Map should accurately reflect my highest achievements.

**Why this priority**: Essential for the core loop of cognitive training—without persistence, there is no progression.

**Independent Test**: Complete a 2-out-of-3 set at Span 3 to advance to Span 4. Close the app, reopen it, and verify the Nebula Map shows Span 4 as the highest unlocked node on Track 1.

**Acceptance Scenarios**:

1. **Given** the user completes a 2-out-of-3 set successfully, **When** the trial ends, **Then** the database updates `max_span_reached` for the current track.
2. **Given** the database is updated during gameplay, **When** the session ends and the user returns to the map, **Then** the Nebula Map instantly refreshes to display the newly unlocked node.

---

### User Story 3 - Track 2: The Pulse (Visual Noise) (Priority: P2)

As a player, I want to experience Track 2, which introduces "Visual Noise" (distractor pulses) during the sequence demonstration to challenge my working memory further.

**Why this priority**: Introduces the second major mechanic for the Spatial Span game, deepening the cognitive challenge.

**Independent Test**: Launch a session on Track 2. Verify that while the target sequence flashes, non-target shards also exhibit subtle, random pulsing animations. Verify that the correct target sequence is still recorded properly upon recall.

**Acceptance Scenarios**:

1. **Given** the user is playing on Track 2, **When** the 'Sequence Flash' (demonstration) phase is active, **Then** non-target shards pulse randomly and subtly to act as visual noise.
2. **Given** the user is playing on Track 2, **When** the recall phase begins, **Then** visual noise ceases entirely.

---

### Edge Cases

- **Map Panning Bounds**: What happens if the constellation grows larger than the viewport? (The `InteractiveViewer` or scroll view must prevent infinite panning into empty space).
- **Track 2 Unlock Condition**: What happens if a user completes Span 5 on Track 1, unlocking Track 2, but has zero progress on Track 2 itself? (Track 2 should show its initial node as unlocked and ready to play).
- **Simultaneous Animations**: What happens if a distractor pulse (Visual Noise) triggers at the exact same millisecond as a target pulse? (Engine must ensure target pulses always take precedence visually and logic-wise).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST implement a `NebulaMapView` using a `CustomPainter` to draw constellation nodes and connecting lines.
- **FR-002**: System MUST render Track 1 nodes (Spans 2-12) as a vertical trunk with an Electric Blue aesthetic.
- **FR-003**: System MUST render Track 2 nodes as a branch extending from the Track 1 Span 5 node, using a Signature Pink aesthetic.
- **FR-004**: System MUST allow interaction with nodes; tapping an unlocked node starts a game session configured for that node's Span and Track.
- **FR-005**: System MUST prevent starting sessions from locked nodes.
- **FR-006**: System MUST integrate with the Drift database to read and update a `max_span_reached` value per track.
- **FR-007**: System MUST update the database immediately when a user satisfies the 2-out-of-3 rule during gameplay.
- **FR-008**: System MUST refresh the `NebulaMapView` to reflect database updates upon returning from a session.
- **FR-009**: System MUST implement "Visual Noise" logic for Track 2, causing non-target shards to pulse subtly and randomly during the sequence demonstration phase.
- **FR-010**: System MUST NOT show "Visual Noise" during the recall phase.

### Key Entities

- **SpatialSpanProgress**: Represents a user's progression state in the database.
  - Attributes: `track_id` (int), `max_span_reached` (int), `last_played_at` (timestamp).
- **ConstellationNode**: A visual representation of a playable span level.
  - Attributes: `span` (int), `track` (int), `isUnlocked` (boolean), `position` (Offset/coordinate).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Tapping an unlocked node successfully launches the game screen configured to the correct Span/Track 100% of the time.
- **SC-002**: Passing a 2-out-of-3 set triggers a database write that persists the new `max_span_reached` within 100ms of the level-up event.
- **SC-003**: The `NebulaMapView` renders smoothly at 60fps, even when panning across 12+ nodes with glowing lines.
- **SC-004**: Track 2's visual noise distractors trigger at random intervals between 300ms and 800ms during the demonstration phase, without interrupting the main sequence timer.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [Assumption regarding Map Scrolling: The map will utilize standard Flutter scrolling/panning mechanisms (`InteractiveViewer` or `SingleChildScrollView`) to handle overflow if the constellation exceeds screen height.]
- [Assumption regarding database schema: The existing Drift database infrastructure will be used; a new table/entity for `spatial_span_progress` will be added without impacting existing Flanker/Task Switch data.]
- [Assumption regarding Visual Noise: Distractor pulses on Track 2 are purely visual and do not affect the hit-testing logic or the target sequence sequence array.]
