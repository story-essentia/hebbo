# Data Model & State Transitions: Spatial Span Nebula Map & Track 2

## Database Entities

### `SpatialSpanProgress` (Drift Table)
- **`id`**: `IntColumn` (Auto-increment PK)
- **`trackId`**: `IntColumn` (1 = Electric Blue, 2 = Signature Pink)
- **`maxSpanReached`**: `IntColumn` (Default: 2 for Track 1, 0 for Track 2)
- **`lastPlayedAt`**: `DateTimeColumn`

## State Models

### `NebulaMapState`
- **`track1MaxSpan`**: `int` (From DB, defaults to 2)
- **`track2MaxSpan`**: `int` (From DB, defaults to 0)
- **`isInitialLoading`**: `bool` (True while fetching from DB)

### `ConstellationNode` (View Model)
- **`span`**: `int` (2 through 12)
- **`track`**: `int` (1 or 2)
- **`isUnlocked`**: `bool` (True if `span <= maxSpanReached` for that track. For track 2, node 5 is unlocked if track 1 reached span 5)
- **`offset`**: `Offset` (Calculated position for CustomPainter)

## Logic & Rules

### Node Unlocking Logic
- **Track 1**: Node `N` is unlocked if `track1MaxSpan >= N`.
- **Track 2 Ignition**: Track 2 branch becomes visible and its first node (Span 5 equivalent) is unlocked when `track1MaxSpan >= 5`.
- **Track 2 Progression**: Track 2 Node `N` is unlocked if `track2MaxSpan >= N`.

### Visual Noise Logic (Track 2)
- When a game session is started with `trackId == 2`, the `SpatialSpanEngine` engages "Noise Mode" during the demonstration phase.
- A secondary periodic timer randomly selects a non-target shard and triggers a low-opacity pulse animation.
- Noise pulses strictly adhere to the `pulseScale` limits to ensure they don't visually overlap or interfere with the target shard's hit-box priority.
