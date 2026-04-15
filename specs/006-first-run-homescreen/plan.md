# Implementation Plan: First-Run Experience & Home Screen

**Feature Branch**: `006-first-run-homescreen`  
**Created**: 2026-04-14

## Technical Context

- **Tech Stack**: Flutter, Dart, Riverpod, Drift (SQLite).
- **Architecture Pattern**: StateNotifier / Providers for global state.
- **Data Persistence**: `shared_preferences` for the first-run flag.
- **Design System**: Electric Nocturne (`DESIGN.md` -> #150629 background, #291543/#301a4d surface containers, #ff8aa7 primary accent, fully rounded corners).

## Constitution Check

- **Scientific Honesty**: Verified. The feature adds a radical honesty onboarding screen and a scientific citations bottom sheet.
- **Privacy by Default**: Verified. No user tracking is added. Data cleanup deletes local data.
- **Design as First-Class**: Verified. Electric Nocturne design constraints are strictly enforced in UI layout.
- **Scope Discipline**: Verified. Limits MVP scope strictly to the requested flows.

## Phase 0: Outline & Research

*Completed during research phase. Identified `shared_preferences` as the persistence layer.*

See `research.md` for details.

## Phase 1: Design & Contracts

*Completed. See `data-model.md` and `quickstart.md`.*

No external interface contracts required for this frontend feature.

## Phase 2: Implementation Strategy

### Component 1: Development Data Cleanup & Boot Logic
- **Responsibility**: Ensure the database is wiped on first launch and route the user correctly.
- **Implementation**:
  - Add logic in `main.dart` (or an initialization provider) that reads `shared_preferences`.
  - Check if a custom flag `has_run_dev_cleanup` is set. If not, trigger a database clear function via Drift, set the flag, and proceed.
  - Read `has_seen_honesty_screen`. If false/null, set initial route to `HonestyScreen`, else `HomeScreen`.

### Component 2: Radical Honesty Screen
- **Responsibility**: Present the first-time onboarding screen.
- **Implementation**:
  - Deep purple background (`#150629`).
  - Centered layout, generous vertical spacing.
  - Four stated facts with subtle accent marks or icons.
  - One primary CTA button ("Let's go"): full roundness, pink gradient (`#ff8aa7`).
  - Button `onPressed`: Set `has_seen_honesty_screen` in `shared_preferences` and `Navigator.pushReplacement` to `HomeScreen`.

### Component 3: Home Screen
- **Responsibility**: Display the game menu and "About Hebbo" citations.
- **Implementation**:
  - Three surface cards vertically stacked.
  - Card styling: `#301a4d` color, large borders radius (32px), `on-surface` (`#efdfff`) typography.
  - Flanker card: tappable, with icon. Tapping routes to `FlankerGameScreen`.
  - Task Switching & Spatial Span cards: 50% opacity/muted, subtitle "Coming soon", non-tappable.
  - Bottom link: "About Hebbo". Tapping opens a `showModalBottomSheet` containing citations.

### Component 4: Session Navigation Loop
- **Responsibility**: Wire the end-of-session and progress screens back into the flow.
- **Implementation**:
  - Update `SessionEndPlaceholder` to have an Electric Nocturne layout.
  - Add three buttons: 
    - "Play again" -> routes back to `FlankerGameScreen`.
    - "See progress" -> routes to `ProgressScreen`.
    - "Back to menu" -> routes to `HomeScreen` (clearing stack).
  - Ensure the back button in `ProgressScreen` pops correctly.

## Edge Cases Handled

- **Force Quit During Onboarding**: Handled by only setting the `shared_preferences` flag when "Let's go" is actually tapped.
- **Rapid Tap**: Use debouncing on the Flanker card or a simple flag to prevent double-routing.
