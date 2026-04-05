# Interface Contract: Local Storage (Drift Layer)

## Overview
Exposes the core methods required to record training data and manage mastery levels locally.

## Repository Interface (Abstract)

### Method: `insertTrial`
- **Arguments**: `TrialData` (Domain Model)
- **Action**: Persists one trial to the `trials` table.
- **Return**: `Future<int>` id of the inserted row.

### Method: `readTrialsForSession`
- **Arguments**: `int sessionId`
- **Action**: Queries trials where `session_id = sessionId`.
- **Return**: `Future<List<TrialData>>`.

### Method: `createSession`
- **Arguments**: `SessionData` (Domain Model)
- **Action**: Persists a new session to the `sessions` table.
- **Return**: `Future<int>` id of the inserted row.

### Method: `readAllSessions`
- **Arguments**: None
- **Action**: Queries all sessions in descending order of `started_at`.
- **Return**: `Future<List<SessionData>>`.

### Method: `upsertDifficulty`
- **Arguments**: `String gameId`, `int newLevel`
- **Action**: Updates current mastery level for `gameId` or creates it if it doesn't exist.
- **Return**: `Future<void>`.

### Method: `getDifficultyForGame`
- **Arguments**: `String gameId`
- **Action**: Queries the current training level for a specific game.
- **Return**: `Future<int?>`.

## Technical Enforcement
- No remote network sync permitted in this layer.
- Persistence must be handled with transaction safety for multi-trial session inserts.
