# Data Model: Adaptive Difficulty Engine

## State Entities

### Adaptive Difficulty State (Immutable)

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| currentLevel | int | Range: 1–10 | The user's active training level. |
| upWindow | List<bool> | Max entries: 20 | Sliding window of recent hits/misses for level-up. |
| downWindow | List<bool> | Max entries: 10 | Sliding window of recent hits/misses for level-down. |

## Relationships
- **AdaptiveEngineNotifier (1) : (1) AdaptiveDifficultyState**: The notifier maintains and immutable replaces the state after every trial.
- **AdaptiveEngineNotifier (1) : (1) DifficultyRepository**: The repository is used to persist the value of `currentLevel` only (windows are not persisted between sessions).

## Integrity Rules
- `currentLevel` must never be ≤ 0 or ≥ 11.
- `upWindow` is trimmed from the left once it exceeds length 20.
- `downWindow` is trimmed from the left once it exceeds length 10.
- "Slate Reset" requires both lists to be empty `[]`.
- Level-up evaluation ONLY happens once `upWindow` has 20 entries.
- Level-down evaluation ONLY happens once `downWindow` has 10 entries AND the reported trial was **incorrect**.

## Transitions

### 1. Level Up
- **Condition**: `upWindow.length == 20` AND `avgAccuracy >= 80%`.
- **Result**: `currentLevel++`, `upWindow = []`, `downWindow = []`.

### 2. Level Down
- **Condition**: `downWindow.length == 10` AND `avgAccuracy < 60%` AND `lastTrial == incorrect`.
- **Result**: `currentLevel--`, `upWindow = []`, `downWindow = []`.
