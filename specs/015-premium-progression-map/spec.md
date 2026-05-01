# Feature Specification: Premium Progression Map

**Feature Branch**: `015-premium-progression-map`  
**Created**: 2026-05-01  
**Status**: Draft  
**Input**: User description: "We need to give the Progression map a more premium look. We need to keep the colors of the tracks but the virtical lines of progress more premium then just one-colored circles. Also right now when a player opens the game for the first time and goes to the progression map they only see the 1st track. I want them to see the 3 tracks with only one being unlocked in the beginning"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Premium Aesthetic for Progression Map (Priority: P1)

As a user, I want the progression map to look premium and engaging, so that my progress feels rewarding and high-quality rather than basic.

**Why this priority**: Elevating the UI to a premium level is the core requirement. Retaining the existing track colors while upgrading the visual complexity of nodes and connecting lines is essential for engagement.

**Independent Test**: Can be tested visually by opening the Progression Map screen and verifying the new node styles, glow effects, or line aesthetics match premium standards.

**Acceptance Scenarios**:

1. **Given** the Progression Map is opened, **When** the user looks at the nodes, **Then** the vertical lines and nodes feature premium styling (e.g. gradients, glows, intricate shapes) rather than simple solid-color circles, while maintaining their track's signature colors (Blue, Pink, Lime).

---

### User Story 2 - Full Track Visibility on First Open (Priority: P2)

As a new player, I want to see all 3 available tracks on the progression map even when they are locked, so that I understand the full scope of the game and what I am working toward.

**Why this priority**: Discoverability is key. Showing all tracks immediately sets expectations and gives players long-term goals.

**Independent Test**: Can be tested by starting a fresh session with no progress and opening the Progression Map to confirm all 3 tracks are drawn, with Tracks 2 and 3 visibly locked.

**Acceptance Scenarios**:

1. **Given** a new user with 0 progress opens the Progression Map, **When** the map renders, **Then** 3 parallel tracks are visible.
2. **Given** the 3 tracks are visible, **When** the user inspects them, **Then** only the first node of Track 1 is unlocked, and Tracks 2 and 3 are visually locked/dimmed but present.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST render all 3 tracks on the Progression Map at all times, regardless of the user's progress.
- **FR-002**: The system MUST visually distinguish between unlocked and locked nodes across all 3 tracks.
- **FR-003**: The system MUST replace simple single-color circle nodes and lines with premium visual assets or advanced CustomPainter geometry (e.g., gradients, drop shadows, inner glows, intricate geometry).
- **FR-004**: The system MUST retain the existing primary color mapping for each track (Track 1: Blue, Track 2: Pink, Track 3: Lime).
- **FR-005**: Locked tracks (e.g., Tracks 2 and 3 for new users) MUST still show their respective nodes but in a disabled/locked visual state.

### Key Entities

- **ConstellationNode**: Represents a single step in a track. Will require updated visual properties or states to support premium rendering and locked/unlocked distinctiveness.
- **Progression Map**: The screen rendering the structural layout of the 3 tracks.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the 3 tracks are visible upon the very first launch of the Progression Map.
- **SC-002**: Visual complexity is increased without dropping frame rates below 60fps on standard devices during scrolling/panning.
- **SC-003**: User testing confirms the new design is perceived as "premium" and "engaging" compared to the baseline single-color circles.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- Assumption: The layout remains a vertical 3-column grid, but the visual execution of the elements is what changes.
- Assumption: "Premium" implies smooth gradients, glows, and potentially faceted/jewel-like shapes similar to the game shards, rather than flat UI.
