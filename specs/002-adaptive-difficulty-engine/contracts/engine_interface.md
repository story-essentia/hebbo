# Interface Contract: Adaptive Difficulty Engine

## Notifier Interface: `AdaptiveEngineNotifier`

### Method: `load(String gameId)`
- **Action**: Fetch the `currentLevel` from `DifficultyRepository` for a specific game and set initial state.
- **Return**: `Future<void>`.

### Method: `reportTrial(bool correct)`
- **Action**: Add result to `upWindow` and `downWindow`.
- **Logic**: Perform "Slate Reset" and level adjustments if windows are full and accuracy meets thresholds.
- **Return**: `void` (State update).

### Method: `save(String gameId)`
- **Action**: Commit the current `state.currentLevel` back to the repository.
- **Return**: `Future<void>`.

## Providers
- `adaptiveEngineProvider`: Global `StateNotifierProvider` to maintain difficulty throughout a session.

## Constraints
- Windows are **transient**. They do not persist across app restarts or sessions.
- Difficulty levels only change incrementally (+1/-1).
