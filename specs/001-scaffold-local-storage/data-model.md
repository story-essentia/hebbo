# Data Model: App Scaffold and Local Storage Layer

## Entities

### Trial (Table: `trials`)
Individual game response recorded within a session.

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| id | int | Primary Key, Auto-increment | Unique identifier for the trial. |
| session_id | int | Foreign Key (`sessions.id`) | ID of the session this trial belongs to. |
| trial_num | int | Not null | Sequence number of the trial within its session. |
| type | text | Not null | e.g. "congruent" or "incongruent" (Flanker). |
| correct | bool | Not null (Stored as 0/1) | Whether the user's response was correct. |
| reaction_ms | int | Not null | User response time in milliseconds. |
| difficulty | int | Not null | Level of difficulty at the time of the trial. |
| timestamp | datetime | Not null | When the trial was completed. |

### Session (Table: `sessions`)
A discrete training period consisting of multiple trials.

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| id | int | Primary Key, Auto-increment | Unique identifier for the session. |
| session_num | int | Not null | Total count of sessions for the user at this time. |
| started_at | datetime | Not null | Timestamp when the session began. |
| ended_at | datetime | Not null | Timestamp when the session concluded. |
| starting_level | int | Not null | Difficulty level at session start. |
| ending_level | int | Not null | Difficulty level at session end. |
| environment_tier | int | Not null | Environmental or calibration condition tier. |

### Difficulty State (Table: `difficulty_state`)
The user's current mastery level per game type.

| Field | Type | Attributes | Description |
|-------|------|------------|-------------|
| game_id | text | Primary Key | Name or ID of the game (e.g. "flanker", "spatial_span"). |
| current_level | int | Not null | User's current training level for this game. |
| updated_at | datetime | Not null | When this mastery record was last calculated. |

## Relationships
- **Session (1) : (N) Trial**: A session contains multiple trials linked by `session_id`.
- **Difficulty State**: Global look-up, updated at session end to set the start for next time.

## Integrity Rules
- `trial_num` must be non-negative.
- `reaction_ms` must be recorded for all completed trials.
- `ended_at` for sessions must be ≥ `started_at`.
- `game_id` is unique and mandatory for all training games.
