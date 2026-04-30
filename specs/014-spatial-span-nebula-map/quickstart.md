# Quickstart: Spatial Span Nebula Map & Track 2

## Verification Scenarios

### 1. Database & UI Initialization (Track 1)
- **Action**: Launch the app and navigate to Spatial Span.
- **Expected**: The Nebula Map renders. Only the "Span 2" node on the main vertical trunk (Electric Blue) is unlocked and glowing. The rest are dim.

### 2. Progression & Branching (Track 1 to Track 2)
- **Action**: Tap the unlocked "Span 2" node to start a session. Fail or abort to return to the map.
- **Developer Action**: Manually update the `track1MaxSpan` to `5` via a debug button or direct DB edit.
- **Expected**: The map updates immediately. Nodes 2 through 5 on Track 1 are unlocked. A new branch (Signature Pink) visibly extends from Node 5, and its first node is unlocked.

### 3. Track 2 Interaction (Visual Noise)
- **Action**: Tap the unlocked node on the Track 2 branch.
- **Expected**: A game session starts. During the demonstration phase, watch the sequence. You should see the target shards pulse normally, but also observe random, subtle pulses from other shards (Visual Noise).
- **Expected (Recall)**: During the recall phase, all visual noise must stop completely.

### 4. Progress Persistence
- **Action**: Successfully complete a 2-out-of-3 set on Track 2 to advance to the next span.
- **Expected**: Upon returning to the Nebula Map (or restarting the app), the progress on Track 2 is saved and the next node on the pink branch is unlocked.
