# Interface Contract: Flanker Game Loop

## Provider Interface: `flankerGameProvider`

### Method: `startSession()`
- **Action**: Fetch current difficulty level, set state to level 1-10, initialize trial count (75).
- **Return**: `void`.

### Method: `reportResponse(Side sideTap)`
- **Action**: Check if stimuli is active, calculate RT using `Stopwatch`, update `feedbackState` (green/red).
- **Return**: `void`.

### Method: `onTimeout()`
- **Action**: Called when `Future.delayed(2000ms)` timer completes without user response.
- **Return**: `void`.

### Method: `persistSession()`
- **Action**: Write all in-memory trials to database. Only called when trial index reaches 75.
- **Return**: `Future<void>`.

## Common Types
- **Side**: Enum (`Left`, `Right`).
- **TrialResult**: Entity (RT, correctness).
- **FeedbackType**: Enum (`Success`, `Fail`, `TimeoutClear`).
