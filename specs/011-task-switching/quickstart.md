# Quickstart: Task Switching Development

## High-Level Flow
1. **Calibration**: Session starts at Level 1 (or user's last mastered level).
2. **Trial Loop**: 
    - Determine rule (Parity or Magnitude) based on switch probability.
    - Render Neon Orb with appropriate border color.
    - Wait for tap or deadline (ISI).
    - Provide immediate feedback animation.
    - Log trial.
3. **Session End**: Update session table with aggregate metrics (Switch Cost).

## Key Components

### `TaskSwitchNotifier` (Riverpod)
Manages the state machine of the session. Tracks current trials, computes accuracy for the adaptive engine, and triggers rule switches.

### `NeonOrbPainter`
A `CustomPainter` that renders:
- Central digit.
- Neon glow border (dynamic color).
- Feedback overlays (green/red/dim).

### `TaskSwitchScreen`
Handles the tap detection logic.
- `onTapDown` on the Left half -> Call `submitResponse(ResponseSide.left)`.
- `onTapDown` on the Right half -> Call `submitResponse(ResponseSide.right)`.

## Metric Calculation
```dart
int calculateSwitchCost(List<TaskSwitchTrial> trials) {
  final switchMean = trials.where((t) => t.isSwitch).map((t) => t.rtMs).average;
  final repeatMean = trials.where((t) => !t.isSwitch).map((t) => t.rtMs).average;
  return switchMean - repeatMean;
}
```
*Note: Exclude timeouts and errors from RT calculations to avoid skewing the cognitive cost metric.*
