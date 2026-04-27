# Research & Decisions: Game Start Countdown

## Decisions

### 1. State Management
- **Decision**: Add `isCountingDown` (bool) and `countdownValue` (int) to `FlankerSessionState` and `TaskSwitchState`.
- **Rationale**: Keeps the game logic reactive and clean. The UI can respond specifically to these flags.
- **Alternatives Considered**: Using a local `StatefulWidget` timer in the screen. Rejected because the GameNotifier should control the trial sequence start.

### 2. Implementation Flow
- **Decision**: Update `startSession()` in the Notifiers.
- **Flow**:
  1. `startSession()` called.
  2. State sets `isCountingDown: true`, `countdownValue: 3`.
  3. A periodic `Timer` (1s) runs, decrementing `countdownValue`.
  4. When `countdownValue` reaches 0, `isCountingDown` becomes `false`, and `_nextTrial()` is called.
- **Rationale**: Ensures the game doesn't "race" for 3 seconds while the user isn't ready.

### 3. UI Aesthetics (Electric Nocturne)
- **Decision**: Create a `GameCountdownOverlay` widget.
- **Style**:
  - Centered large text with `PlusJakartaSans`.
  - Gradient color (Neon Cyan to Neon Pink).
  - Subtle `AnimatedSwitcher` or `AnimatedOpacity` for the number change.
  - Backdrop blur to dim the game background during countdown.

## Research Findings

### Timer Best Practices in Flutter Notifiers
- Always cancel timers in `dispose()`.
- Use `Timer.periodic` for the 3-2-1 sequence.

### Animations
- A simple `ScaleTransition` or `TweenAnimationBuilder` will make the numbers feel "alive" as they count down.
