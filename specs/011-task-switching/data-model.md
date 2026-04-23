# Data Model: Task Switching

## Entities

### TaskSwitchTrial
Represents a single cognitive trial in a task-switching session.

| Field | Type | Description |
|-------|------|-------------|
| id | Int | Primary key |
| sessionId | Int | Reference to TaskSwitchSession |
| digit | Int | Value 1-9 (excluding 5) |
| rule | Enum | `PARITY` or `MAGNITUDE` |
| trialType | Enum | `SWITCH` or `REPEAT` |
| difficultyLevel| Int | 1 to 10 |
| rtMs | Int | Reaction time in milliseconds |
| result | Enum | `CORRECT`, `INCORRECT`, `TIMEOUT` |
| timestamp | DateTime| When the trial occurred |

### TaskSwitchSession
Aggregate data for a 75-trial session.

| Field | Type | Description |
|-------|------|-------------|
| id | Int | Primary key |
| startTime | DateTime| Start of session |
| endTime | DateTime| End of session |
| meanRtSwitch | Int | Average RT for switch trials (ms) |
| meanRtRepeat | Int | Average RT for repeat trials (ms) |
| switchCostMs | Int | `meanRtSwitch - meanRtRepeat` |
| accuracy | Double | Percentage correct |
| finalLevel | Int | Level at session end |

## Relationships
- `TaskSwitchSession` has many `TaskSwitchTrial`s (1:N).
- `TaskSwitchSession` belongs to a "Task Switching" game type in the global session registry.

## Persistence Rules
- Data MUST be persisted locally using Drift (SQLite).
- Sessions ARE NOT valid until all 75 trials are completed or the session is marked "aborted".
- RT values MUST be non-negative.
