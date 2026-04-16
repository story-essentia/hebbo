# Feature Specification: Game detail bottom sheet

**Feature Branch**: `007-game-detail-sheet`  
**Created**: 2026-04-15  
**Status**: Draft  
**Input**: User description: "When the user taps the Flanker card on the home screen, instead of immediately starting a session, show a bottom sheet that slides up. The bottom sheet follows the Electric Nocturne design system. Bottom sheet contents: Title: 'Flanker' in headline style. If the user has played before: show their personal best RT and sessions completed as two small stat chips side by side. If the user has never played: show 'First session — we'll find your level' in muted text. A one-sentence science summary: 'Trains selective attention and inhibitory control — your ability to focus on what matters and ignore what doesn't.' A small 'Based on Eriksen & Eriksen (1974)' citation in label style, muted. Primary CTA button: 'Play' — full width, pink gradient, full roundness. Secondary text link below the button: 'View your progress' — only shown if user has played before, navigates to progress screen. Tapping Play from the bottom sheet starts the game session. Tapping outside the bottom sheet dismisses it without navigating."

## Clarifications

### Session 2026-04-16

- Q: Loading State UX → A: Show immediately with shimmers/skeletons for stats
- Q: Navigation Transition → A: Immediate Transition (Navigate instantly upon tap)
- Q: Stat Chip Precision → A: Integer (e.g., "742 ms")

## User Scenarios & Testing *(mandatory)*

### User Story 1 - First-time Player Introduction (Priority: P1)

As a first-time user, I want to see an introduction to the Flanker game before I start, so that I understand what I am about to train.

**Why this priority**: Essential for the first-run experience and setting scientific expectations without being overwhelming.

**Independent Test**: Can be tested by launching the app with a clean database, tapping the Flanker card, and verifying the "First session" text and science summary appear.

**Acceptance Scenarios**:

1. **Given** the user has never played Flanker, **When** they tap the Flanker card on the home screen, **Then** a bottom sheet appears showing "First session — we'll find your level" and the science summary.
2. **Given** the bottom sheet is open, **When** the user taps "Play", **Then** the game session starts.

---

### User Story 2 - Returning Player Stats (Priority: P1)

As a returning user, I want to see my current progress and personal best before starting a new session, so that I feel motivated to improve.

**Why this priority**: Core engagement loop; reinforces the value of repeated training.

**Independent Test**: Can be tested by completing one Flanker session, returning to the home screen, tapping the Flanker card, and verifying the stat chips and "View progress" link appear.

**Acceptance Scenarios**:

1. **Given** the user has completed at least one session, **When** they tap the Flanker card, **Then** the bottom sheet shows their Personal Best RT and Total Sessions Completed as stat chips.
2. **Given** the stat chips are visible, **When** the user taps "View your progress", **Then** they are navigated to the Progress screen.

---

### User Story 3 - Safe Dismissal (Priority: P2)

As a user, I want to be able to close the game details without starting a session if I change my mind.

**Why this priority**: Basic UX standard; prevents forced navigation.

**Independent Test**: Open the sheet and tap the dimmed area outside it; verify the sheet closes and the home screen remains active.

**Acceptance Scenarios**:

1. **Given** the bottom sheet is open, **When** the user taps the background/scrim area outside the sheet, **Then** the sheet is dismissed and no navigation occurs.

---

### User Story 4 - Data Loading State (Priority: P3)

As a user, I want to see a clean transition while my stats are loading, so the interface doesn't flicker.

**Why this priority**: Polish and UX quality.

**Independent Test**: Verify the sheet appears immediately upon card tap and shows animated shimmer skeletons for stat values until data is retrieved.

**Acceptance Scenarios**:

1. **Given** a user taps a card, **When** the database query is in progress, **Then** the sheet opens immediately and displays shimmer skeletons for the stat chips.
2. **Given** the sheet is open with skeletons, **When** data arrives, **Then** the skeletons are replaced with actual values without shifting the layout.

---

### Edge Cases

- **Session Interruption**: If a user played but never finished a session (no `ended_at`), they are treated as having "never played" for the purpose of the initial message.
- **Empty Stats**: If for some reason the database returns 0 sessions but "best RT" logic is triggered, the sheet should fallback gracefully to the "First session" view.
- **System Back Button (Android)**: Pressing the hardware back button while the sheet is open must dismiss the sheet.

---


## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Triggered Bottom Sheet: The application MUST display a slide-up bottom sheet when the Flanker card is tapped on the Home Screen.
- **FR-002**: First-Run Content: If no Flanker sessions exist in the database, the system MUST display the muted text: "First session — we'll find your level".
- **FR-003**: Returning User Content: If Flanker sessions exist, the system MUST display two stat chips:
    - **Personal Best RT**: The lowest average reaction time recorded in a completed session, formatted as an integer (e.g., "742 ms").
    - **Sessions Completed**: Count of all sessions with an 'ended_at' timestamp.
- **FR-004**: Scientific Context: The sheet MUST display the summary: "Trains selective attention and inhibitory control — your ability to focus on what matters and ignore what doesn't."
- **FR-005**: Citation: The sheet MUST display a muted citation: "Based on Eriksen & Eriksen (1974)".
- **FR-006**: Primary Action: A full-width "Play" button with pink gradient and full edge roundness MUST start the Flanker game session. The transition MUST be immediate (no delay for sheet dismissal animation).
- **FR-007**: Secondary Action: A "View your progress" text link MUST appear only for returning users and navigate to the existing Progress Screen.
- **FR-008**: Dismissal logic: Tapping outside the bottom sheet or swiping it down MUST dismiss it.
- **FR-009**: Loading Skeletons: The sheet MUST appear immediately upon trigger and display animated shimmer skeletons for any data-driven stats until the database query completes.

### Key Entities

- **Session**: A gaming session record. Key attributes used for the sheet: `ended_at`, `average_rt` (or calculated from trials).
- **Stat Chip**: A UI component displaying a label and a value (e.g., "Best RT", "8 sessions").

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Presentation Speed: The bottom sheet must appear smoothly with an animation duration under 300ms.
- **SC-002**: Interaction Path: Users must be able to reach the game screen in exactly two taps from the home screen (Card -> Play).
- **SC-003**: Contextual Relevance: 100% of first-time users see the introductory text instead of empty stat chips.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Assumption about "Personal Best RT": We will calculate the average RT per session and identify the minimum among all sessions completed by the user.]
- [Dependency on Electric Nocturne styling: The sheet will use the background color #150629 and surface #301a4d tokens.]
