# Feature Specification: First-Run Experience & Home Screen

**Feature Branch**: `006-first-run-homescreen`  
**Created**: 2026-04-14  
**Status**: Draft  
**Input**: User description: "Build the complete first-run experience and home screen for Hebbo. This milestone connects all existing screens into a coherent app flow for the first time."

## User Scenarios & Testing *(mandatory)*

### User Story 1 — First-Time User Onboarding (Priority: P1)

A new user installs Hebbo and opens it for the first time. They are greeted with a single "radical honesty" screen that communicates the app's core principles: the games are research-backed, all data stays on-device, no account is needed, and the team is transparent about what the science does and does not prove. After reading, the user taps a single call-to-action button ("Let's go") and is taken to the home screen. This honesty screen never appears again on subsequent app launches.

**Why this priority**: This is the user's first impression of the product. It sets the tone for trust, scientific integrity, and no-nonsense communication — core brand values. Without this, the app launches directly into a game with no context.

**Independent Test**: Can be tested by uninstalling and reinstalling the app. On first launch, the honesty screen appears. After tapping "Let's go," every subsequent launch skips directly to the home screen.

**Acceptance Scenarios**:

1. **Given** the app is freshly installed (no prior data), **When** the user opens the app, **Then** the radical honesty screen is displayed with four factual statements and a "Let's go" button.
2. **Given** the user is viewing the radical honesty screen, **When** they tap "Let's go," **Then** the app navigates to the home screen and the honesty screen is marked as seen.
3. **Given** the user has previously tapped "Let's go," **When** they reopen the app on any subsequent launch, **Then** the app navigates directly to the home screen, bypassing the honesty screen entirely.

---

### User Story 2 — Home Screen Game Selection (Priority: P1)

A returning user opens the app and lands on the home screen. They see three game cards displayed vertically. The first card ("Flanker") is fully interactive — tapping it starts a game session. The remaining two cards ("Task Switching" and "Spatial Span") are visually dimmed and marked as "Coming soon," indicating future content without creating a dead-end or confusion.

**Why this priority**: The home screen is the central navigation hub of the app. Every session begins here. Without it, there is no way to return to a menu or understand what the app offers.

**Independent Test**: Can be tested by launching the app (after onboarding). The home screen displays three game cards. Only the Flanker card responds to taps, navigating to the game session. The other two cards are visually muted and do not respond to interaction.

**Acceptance Scenarios**:

1. **Given** the user is on the home screen, **When** they view the screen, **Then** three game cards are displayed vertically: "Flanker," "Task Switching," and "Spatial Span."
2. **Given** the user is on the home screen, **When** they tap the "Flanker" card, **Then** the app navigates to the Flanker game session.
3. **Given** the user is on the home screen, **When** they tap the "Task Switching" card, **Then** nothing happens — the card does not respond to taps.
4. **Given** the user is on the home screen, **When** they tap the "Spatial Span" card, **Then** nothing happens — the card does not respond to taps.
5. **Given** the user is on the home screen, **When** they view the locked cards, **Then** the locked cards are visually dimmed (reduced opacity or muted colors) and display "Coming soon" as their subtitle.

---

### User Story 3 — Complete Navigation Flow (Priority: P1)

A user completes a full app loop without encountering any dead ends. They launch the app, land on the home screen, tap Flanker, play a session, see the session-end screen, and can choose to: play again, view their progress, or return to the home screen. From the progress screen, they can navigate back. Every path loops back to a meaningful destination.

**Why this priority**: This is the first milestone where all existing screens are wired together. Without a complete flow, users get stuck on screens with no way to navigate back or forward.

**Independent Test**: Can be tested by walking the full navigation loop: Home → Flanker → Session End → (each option) → verify destination → verify ability to return.

**Acceptance Scenarios**:

1. **Given** the user has completed a game session, **When** they are on the session-end screen and tap "Play again," **Then** a new game session begins.
2. **Given** the user has completed a game session, **When** they are on the session-end screen and tap "See progress," **Then** the progress screen is displayed.
3. **Given** the user has completed a game session, **When** they are on the session-end screen and tap "Back to menu," **Then** the home screen is displayed.
4. **Given** the user is on the progress screen, **When** they tap the back arrow, **Then** they return to the screen they came from.

---

### User Story 4 — Scientific Transparency (Priority: P2)

A user on the home screen can access a brief scientific disclosure about the research behind Hebbo. Tapping an "About Hebbo" link at the bottom of the home screen opens a compact overlay or bottom sheet showing the scientific citations (Eriksen 1974, Rueda 2005) and a brief note about the evidence basis. This satisfies the scientific honesty principle without cluttering the main interface.

**Why this priority**: Scientific honesty is a core brand value, but it is secondary to making the app navigable and functional. This feature enriches the experience without blocking core functionality.

**Independent Test**: Can be tested by tapping "About Hebbo" on the home screen and verifying that the citations are displayed in a modal or bottom sheet that can be dismissed.

**Acceptance Scenarios**:

1. **Given** the user is on the home screen, **When** they tap "About Hebbo," **Then** a modal or bottom sheet appears displaying scientific citations.
2. **Given** the "About Hebbo" overlay is visible, **When** the user dismisses it (tap outside, swipe down, or close button), **Then** the overlay closes and the home screen is fully visible again.

---

### User Story 5 — Development Data Cleanup (Priority: P2)

When the app launches for the first time after this milestone's deployment, any leftover development or mock data (seeded sessions, trials, and difficulty states from earlier testing) is automatically removed. The user starts with a clean, empty database — no phantom records, no impossible reaction times, no confusing pre-existing progress.

**Why this priority**: Corrupt or seeded test data degrades trust and creates confusion (e.g., the "7ms Best RT" bug). Users must start with a pristine state.

**Independent Test**: Can be tested by checking the database after first launch — all tables should be empty. Progress screen should display an empty or "no data" state until the user completes their first real session.

**Acceptance Scenarios**:

1. **Given** the app contains leftover development data from prior builds, **When** the app launches for the first time after this milestone, **Then** all trial, session, and difficulty state records are deleted.
2. **Given** the data cleanup has run, **When** the user navigates to the progress screen before playing any session, **Then** the metrics show zero values and the chart shows a "no data" empty state.

---

### Edge Cases

- What happens if the user force-quits the app on the honesty screen before tapping "Let's go"? The honesty screen should appear again on next launch since the "seen" flag was never set.
- What happens if the user rotates the device on the honesty screen or home screen? Content should remain readable and not overflow.
- What happens if the user taps the Flanker card rapidly? Only one game session should start — no duplicate navigations.
- What happens if the database cleanup runs but there is no development data? The cleanup completes silently with no errors.
- What happens if the user navigates back from the Flanker game screen mid-session? The app should handle this gracefully (return to home screen or show a confirmation).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST display the radical honesty screen on the very first launch after installation.
- **FR-002**: The radical honesty screen MUST display exactly four factual statements as specified in the content requirements.
- **FR-003**: The radical honesty screen MUST include a single primary call-to-action button labeled "Let's go."
- **FR-004**: Tapping "Let's go" MUST persist a flag locally indicating the screen has been seen, and navigate to the home screen.
- **FR-005**: On all subsequent app launches, the app MUST skip the radical honesty screen and navigate directly to the home screen.
- **FR-006**: The home screen MUST display three game cards vertically: "Flanker," "Task Switching," and "Spatial Span."
- **FR-007**: The "Flanker" card MUST be interactive — tapping it navigates to the Flanker game session.
- **FR-008**: The "Task Switching" and "Spatial Span" cards MUST be visually dimmed and non-interactive, displaying "Coming soon" as their subtitle.
- **FR-009**: The home screen MUST include an "About Hebbo" text link that opens a modal or bottom sheet with scientific citations.
- **FR-010**: The session-end screen MUST provide three navigation options: "Play again" (starts new session), "See progress" (opens progress screen), and "Back to menu" (returns to home screen).
- **FR-011**: The progress screen back arrow MUST return the user to the screen they navigated from.
- **FR-012**: On first launch after this milestone, the app MUST delete all existing trial, session, and difficulty state records from the local database.
- **FR-013**: All screens in this milestone MUST follow the Electric Nocturne design system as defined in DESIGN.md.
- **FR-014**: The app MUST produce zero static analysis errors.

### Key Entities

- **Onboarding Flag**: A locally persisted boolean value indicating whether the radical honesty screen has been seen. Key: `has_seen_honesty_screen`. Stored using on-device key-value storage.
- **Game Card**: A display entity representing a game on the home screen. Attributes: title, subtitle, icon, active/locked status.
- **Navigation Route**: The directed connection between screens. Defines origin, destination, and trigger action.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh install shows the honesty screen, and tapping "Let's go" transitions to the home screen in under 1 second. The honesty screen never appears again on subsequent launches.
- **SC-002**: All three game cards are visible on the home screen. Only the Flanker card responds to taps. Locked cards are visually distinguishable from the active card at a glance.
- **SC-003**: The complete navigation loop (Home → Flanker → Session End → each option) has zero dead ends — every path leads to a meaningful destination.
- **SC-004**: "About Hebbo" displays scientific citations and can be dismissed within 2 taps (open + close).
- **SC-005**: After the one-time data cleanup, the local database contains zero seeded or development records.
- **SC-006**: All screens in this milestone pass visual review against the Electric Nocturne design system (deep purple backgrounds, pink accents, rounded corners, no sharp edges, no 1px borders).
- **SC-007**: The full end-to-end flow is verified on a physical device with zero crashes or layout errors.

## Assumptions

- No user accounts, no remote sync, no social features. All data is local-first.
- Scientific honesty is a core principle — the honesty screen and "About Hebbo" citations are non-negotiable, not marketing fluff.
- The target user is 25–35, tech-savvy, and skeptical of pseudoscience brain-training claims.
- The Electric Nocturne design system (DESIGN.md) is the single source of truth for all visual decisions in this milestone.
- The existing Flanker game session, session-end screen, and progress screen are functional and do not require modifications beyond navigation wiring.
- The "has_seen_honesty_screen" flag is stored using simple on-device key-value persistence — not in the game database.
- The one-time data cleanup targets only development/seeded data and runs before the honesty screen check. It is safe to run even if no development data exists.
- The session-end screen already exists as a placeholder and will be updated with the three navigation options in this milestone.
