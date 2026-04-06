# Data Model: Flanker Game Loop

## State Entities

### Flanker Session State (Immutable)

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| trialsRemaining | int | Default: 75 | Pre-allocated trials for the session. |
| currentStimulus | FlankerStimulus | Required | Defined by target direction and congruency. |
| isStimulusActive | bool | Default: false | Whether UI is currently accepting inputs for a trial. |
| feedbackState | FeedbackType | Default: None | Correct (Green), Wrong (Red), Timeout (Dim). |
| bufferedTrials | List<TrialEntity>| Buffered | In-memory storage of completed trials until session ends. |

### FlankerStimulus (Entity)

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| targetDirection | Side | Left/Right | Orientation of the center stimuli. |
| isCongruent | bool | Toggle | True if flanking stimuli match target orientation. |

## Relationships
- **FlankerNotifier (1) : (1) FlankerSessionState**: The notifier maintains and immutable replaces the state after every trial.
- **FlankerNotifier (1) : (1) TrialRepository**: Writes all buffered trials only at `trialsRemaining == 0`.
- **FlankerNotifier (1) : (1) SessionRepository**: Writes metadata for the completed session.

## State Transitions

### 1. New Trial
- **Condition**: ISI timer completes.
- **Result**: Stimulus generated (random direction, congruency per level), `isStimulusActive = true`, stopwatch started.

### 2. User Response
- **Condition**: Screen tap received while `isStimulusActive`.
- **Result**: `isStimulusActive = false`, RT calculated, feedback shown for 200ms, trial buffered.

### 3. Timeout (2000ms)
- **Condition**: Stimulus timer expires without response.
- **Result**: `isStimulusActive = false`, Correctness = `false`, feedback (dim) shown, trial buffered.

### 4. Completion
- **Condition**: `trialsRemaining == 0`.
- **Result**: Buffer flushed to Drift database, navigate to session summary.
