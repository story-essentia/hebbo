# Feature Quickstart: First-Run Experience & Home Screen

## Overview
This feature introduces the initial onboarding state (Radical Honesty screen), the primary navigation hub (Home Screen), and connects all existing game routes together into a cohesive loop while adhering to the Electric Nocturne design system.

## Setup
1. **dependencies**: Add `shared_preferences` flutter package.
2. **google_fonts**: Ensure `google_fonts` package is installed and `Plus Jakarta Sans` is available (should be from progress-screen spec).

## Build Steps
1. Create `HonestyScreen` and `HomeScreen` widgets following `DESIGN.md`.
2. Update `main.dart` to check `shared_preferences` on app boot and route to the correct initial screen.
3. Add a one-time startup initialization function to clear out development data from the local database on first run.
4. Update `SessionEndPlaceholder` (or create actual `SessionEndScreen`) to provide navigation buttons for "Play again", "See progress", and "Back to menu".
5. Wire up the bottom sheet logic on the `HomeScreen` for the "About Hebbo" scientific citations.
