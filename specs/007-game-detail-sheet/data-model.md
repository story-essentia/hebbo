# Data Model: Game detail bottom sheet

## UI State Model

### FlankerDetailState
Represents the content state of the Flanker detail sheet.

| Field | Type | Description |
|-------|------|-------------|
| isLoading | bool | True while database query is active |
| hasPlayedBefore | bool | Derived from whether session count > 0 |
| bestSessionRt | int? | Lowest average RT from completed sessions (integers only) |
| totalSessions | int | Total count of completed sessions |

## Domain Logic

### Personal Best RT Calculation
```sql
SELECT MIN(avg_rt) FROM (
  SELECT AVG(reaction_ms) as avg_rt 
  FROM trials 
  WHERE correct = 1 AND session_id IN (
    SELECT id FROM sessions WHERE ended_at IS NOT NULL
  )
  GROUP BY session_id
)
```

## Validation Rules
- **RT Display**: Always append " ms".
- **Session Count**: Display as integer followed by " sessions".
- **Empty State**: If `hasPlayedBefore` is false, hide stat chips and show introduction text.
