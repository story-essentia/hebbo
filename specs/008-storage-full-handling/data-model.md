# Data Model: Storage Full Handling

## Existing Entities Impacted

This feature does not introduce new entities but modifies the behavior of persistence for existing ones.

### SessionTable / SessionEntity
- **Persistence Point**: End of game session.
- **Error Behavior**: If `insertSession` fails, the `sessionId` remains null, and the trials cannot be linked. The application must handle this by holding the session data in memory.

### TrialTable / TrialEntity
- **Persistence Point**: Streamed or batched after session completion.
- **Error Behavior**: If failure occurs during trial batching, the save operation must be aborted, and all trials must remain in the in-memory buffer.

## Implicit State (In-Memory Only)

### FlankerSessionState (Update)
- **Attribute**: `isPersisted` (bool)
- **Role**: Tracks whether the session has successfully hit the database. Used to determine if the "Progress will be lost" confirmation dialog is needed during navigation.
