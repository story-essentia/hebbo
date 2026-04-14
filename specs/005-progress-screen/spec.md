# Feature Specification: Progress Screen

**Feature Branch**: `005-progress-screen`  
**Created**: 2026-04-10
**Status**: Draft  

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Overall Performance Metrics (Priority: P1)

Users want to see a high-level summary of their overall progress and achievements (Personal Best RT, Sessions Completed, and Current Environment Tier) to stay motivated.

**Why this priority**: Immediate feedback and high-level stats provide a quick understanding of the user's progress.

**Independent Test**: Can be fully tested by verifying the three metric cards render the correct values derived from the local database.

**Acceptance Scenarios**:

1. **Given** the user has completed at least one session, **When** they navigate to the progress screen, **Then** they see their fastest correct trial RT, total number of completed sessions, and their most recent environment tier ("Shallow reef", "Open ocean", or "Deep sea").
2. **Given** the user navigates to the progress screen, **When** it calculates values from the local database, **Then** no network requests are made.

---

### User Story 2 - Visualize Session-by-Session Growth (Priority: P1)

Users want to visualize their historical performance over time, tracking both reaction time metrics and game difficulty level.

**Why this priority**: A visual chart is essential for the core purpose of a "Progress Screen", helping users see their improvement over multiple sessions.

**Independent Test**: Can be fully tested by verifying the chart renders two Y axes, one X axis, two RT lines, and one difficulty stepped line based on local database queries.

**Acceptance Scenarios**:

1. **Given** there are completed sessions, **When** the chart loads, **Then** it plots the session numbers on the X axis, with the oldest on the left and the newest on the right.
2. **Given** congruent and incongruent trials have been completed, **When** the chart loads, **Then** the left Y axis shows reaction time, displaying congruent RT averages as a solid blue line and incongruent RT averages as a dashed orange line.
3. **Given** the user reaches varying difficulty levels, **When** the chart loads, **Then** the right Y axis plots the session's ending difficulty (from 1 to 10) as a green stepped line.
4. **Given** the progress screen is open, **When** examining the data source, **Then** all chart data is pulled locally from the database with no network requests.

---

### User Story 3 - Toggle Chart View Range (Priority: P2)

Users want to focus on their recent sessions but also have the option to see their entire history since the beginning.

**Why this priority**: Helps keep the chart readable while providing full context when requested.

**Independent Test**: Can be fully tested by verifying the "All time" toggle changes the chart's X-axis scope.

**Acceptance Scenarios**:

1. **Given** the progress chart is displayed, **When** there are more than 10 sessions, **Then** the chart defaults to showing only the last 10 sessions.
2. **Given** the chart defaults to the last 10, **When** the user taps the subtle "All time" button, **Then** the chart updates to display all historical sessions.
3. **Given** the chart shows all sessions, **When** the user taps the "All time" button again (or a toggle back button), **Then** it reverts to showing the last 10 sessions.
4. **Given** the user is viewing the toggle, **When** the active state changes, **Then** the active selection is visually indicated.

---

### User Story 4 - Navigate Back Safely (Priority: P2)

Users want to return to their previous location after reviewing their progress.

**Why this priority**: Navigation is required so the user doesn't get stuck on the progress screen.

**Independent Test**: Can be fully tested by pressing the back button.

**Acceptance Scenarios**:

1. **Given** the user is on the progress screen, **When** they tap the back button, **Then** they are returned to their previous screen (session end screen or home menu).
2. **Given** the user is on the progress screen, **When** they look for other navigation, **Then** there are no other navigation routes available.

---

### Edge Cases

- What happens when there are fewer than 10 sessions? (Chart shows all available sessions without failing).
- What happens when the user has 0 sessions completed? (UI handles empty states gracefully without crashing, e.g., showing 0s or empty chart).
- What happens if a session has no correct trials? (Personal Best RT and averages should handle division-by-zero or empty trial lists without crashing).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST read all data exclusively from the local Drift database with no network requests.
- **FR-002**: System MUST calculate aggregate averages (per session basis, by congruent/incongruent type) for Reaction Times.
- **FR-003**: System MUST determine the absolute minimum Reaction Time for all correct trials and display it as Personal Best RT.
- **FR-004**: System MUST display "Shallow reef", "Open ocean", or "Deep sea" according to the `environment_tier` integer found in the most recent session.
- **FR-005**: System MUST provide a toggle button to switch between the last 10 sessions and all sessions.
- **FR-006**: System MUST plot a multi-axis chart using the `fl_chart` package.
- **FR-007**: System MUST provide a back navigation button.
- **FR-008**: System MUST NOT include any game logic, animation changes, or new screens beyond the progress screen.
- **FR-009**: System MUST allow seeding of at least 8 mock sessions to aid in visual testing before UI development is completed.

### Key Entities

- **Session**: Attributes include `session_num`, `started_at`, `ended_at`, `starting_level`, `ending_level`, `environment_tier`.
- **Trial**: Attributes include `session_id`, `type` ('congruent' vs 'incongruent'), `correct` (boolean), `reaction_ms`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Progress screen renders correctly on the target device with seeded mock data.
- **SC-002**: Chart accurately plots the two Reaction Time lines and the difficulty stepped line based on local data.
- **SC-003**: All three metric cards match the aggregates computed from the local database.
- **SC-004**: Toggling between Last 10 and All Time views updates the chart data successfully.
- **SC-005**: Zero network requests are performed by the screen or its view-models.
- **SC-006**: Code passes static analysis (zero errors).

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No remote sync or network requests.]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Assumption about target users: 25-35, tech-savvy, skeptic of pseudoscience]
- [Dependency on local-first architecture for all data persistence]
- The `environment_tier` corresponds to: 1 = Shallow reef, 2 = Open ocean, 3 = Deep sea.
- Empty states (0 sessions) are adequately handled by returning default values (e.g., 0ms, "N/A", empty chart).
