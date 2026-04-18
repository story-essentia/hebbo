# Quickstart: Dynamic Environments

## Development Setup

1. **Verify State**: Ensure you have a session state with a reachable `currentLevel`.
2. **Visual Debugging**:
   - To force a specific environment for testing, modify `FR-001` logic in `flanker_game_screen.dart` temporarily.
   - Use `flutter run --profile` to verify 60fps on the Pixel 6a.

## Testing Environments

### Scenario 1: Level Progression
- Set `currentLevel` to 1. Start session. Verify **Shallow Reef**.
- Reach Level 4. Verify **Open Ocean** loads at start of next trial/session.
- Reach Level 8. Verify **Deep Sea** loads.

### Scenario 2: Forward Movement
- In `FlankerGameScreen`, complete a trial.
- When `isResetting` becomes true, verify the parallax background speed increases significantly (8-10x) for the duration of the reset.

### Scenario 3: Performance
- Open Flutter DevTools -> Performance.
- Confirm frame times for `CustomPainter` layers are < 10ms.
