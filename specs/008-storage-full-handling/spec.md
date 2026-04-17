# Feature Specification: Storage full edge case

**Feature Branch**: `008-storage-full-handling`  
**Created**: 2026-04-16  
**Status**: Draft  
**Input**: User description: "Add graceful handling for database write failures. Wrap all Drift insert operations in try-catch. If a write fails, show a non-blocking snackbar: \"Could not save session data. Your device storage may be full.\" Do not crash. Do not lose the current session state."

## Clarifications

### Session 2026-04-16
- Q: Should the snackbar include an interactive action? → A: Include an "OK" or "Dismiss" button to acknowledge the error.
- Q: Should there be a final confirmation dialog if the user attempts to leave with unsaved data? → A: Show a confirmation dialog if navigating away while data is unsaved.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Recovery from Persistence Failure (Priority: P1)

As a user, when I finish a training session and my device storage is unexpectedly full, I want to see a clear message explaining why my data wasn't saved, so that I don't think the app just crashed or failed for no reason.

**Why this priority**: Crucial for "Scientific Honesty" and "Privacy by Default" — data integrity and system reliability are core to the Hebbo brand. Preventing crashes is essential for a premium experience.

**Independent Test**: Can be tested by simulating a disk-full error (e.g., using a mock database repository that throws on insert) and verifying that the snackbar appears and the app remains responsive.

**Acceptance Scenarios**:

1. **Given** I am on the session completion screen, **When** the system attempts to save my results and the storage is full, **Then** I see a snackbar: "Could not save session data. Your device storage may be full."
2. **Given** the storage-full error occurs, **When** I close the snackbar, **Then** I am still on the session completion screen (or a safe menu state) and can safely navigate the app.
3. **Given** a persistence failure, **When** I attempt to "See progress", **Then** the app should handle the absence of the unsaved session without crashing.

---

### Edge Cases

- **What happens when storage becomes full mid-session?** The currently buffered trials should stay in memory, and the final save attempt should fail gracefully.
- **How does system handle repeated save attempts?** If the user navigates back and forth, each failed write should trigger the same graceful error handling without stacking multiple identical snackbars.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST wrap all Drift database `insert` and `update` operations in `try-catch` blocks specifically targeting I/O or database-full exceptions.
- **FR-002**: System MUST display a non-blocking snackbar overlay with an "OK" or "Dismiss" action button when a database write fails due to storage constraints.
- **FR-003**: The error message MUST be exactly: "Could not save session data. Your device storage may be full."
- **FR-004**: System MUST NOT allow the application to terminate or enter an inconsistent visual state (freeze/white screen) following a write failure.
- **FR-005**: All game-session state and progress data MUST be maintained in memory until the session is explicitly abandoned by the user, even if persistence fails.
- **FR-006**: System MUST show a confirmation dialog warning that progress will be lost if the user attempts to navigate away from the session results screen while a storage-related save failure is active.

### Key Entities *(include if feature involves data)*

- **Session Results**: The temporary in-memory representation of the completed game (trials, RTs, accuracy).
- **HebboDatabase**: The Drift database instance where persistence is attempted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of simulated storage-full write attempts result in a gracefully handled error rather than a crash.
- **SC-002**: The error snackbar is visible to the user within 300ms of the write failure detection.
- **SC-003**: The application remains fully interactive (navigation, menu access) despite the persistence failure.
- **SC-004**: No "orphaned" database transactions are left open or locked following a caught persistence error.

## Assumptions

- [MANDATORY SCOPE DISCIPLINE: No user accounts, no remote sync, no social features for MVP]
- [MANDATORY SCIENTIFIC HONESTY: Evidence of cognitive transfer must be cited for every game]
- [Dependency on local-first architecture for all data persistence]
- [Assumption: The snackbar is the standard Flutter Material snackbar or the project's equivalent UI component.]
- [Assumption: We are only handling write failures related to storage/persistence; network or other unrelated errors are out of scope for this specific task.]
