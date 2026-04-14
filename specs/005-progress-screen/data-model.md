# Data Model: Progress Screen

The progress screen relies entirely on reading from the existing Drift database.

## 1. Existing Entities (Read-Only)

### Session (from `sessions` table)
- `id` (integer, primary key)
- `session_num` (integer)
- `started_at` (datetime)
- `ended_at` (datetime)
- `starting_level` (integer)
- `ending_level` (integer) - *Chart Right Y-Axis*
- `environment_tier` (integer) - *Metric Card: Current Environment Tier*

### Trial (from `trials` table)
- `id` (integer, primary key)
- `session_id` (integer, foreign key)
- `trial_num` (integer)
- `type` (text: 'congruent', 'incongruent') - *Chart grouping*
- `correct` (boolean) - *Filter for valid RTs*
- `reaction_ms` (integer) - *Chart Left Y-Axis, Metric Card: PB RT*

## 2. Derived View Models

To feed the UI cleanly, the provider will construct the following Data Transfer Objects (DTOs):

### `ProgressMetrics`
```dart
class ProgressMetrics {
  final int personalBestRtMs;
  final int totalSessionsCompleted;
  final String currentEnvironmentTier; // mapped from int
}
```

### `SessionChartData`
```dart
class SessionChartData {
  final int sessionNum;
  final double avgCongruentRt;
  final double avgIncongruentRt;
  final int endingDifficulty;
}
```

## 3. Data Flow
1. `ProgressProvider` (Riverpod `AsyncNotifier`) mounts.
2. Queries DB for aggregate counts and PB RT.
3. Queries DB for session history and groups trials by type.
4. Constructs list of `SessionChartData` models and one `ProgressMetrics` model.
5. Surfaces state to `ProgressScreen`.
6. Chart UI maps data arrays into `LineChartData` definitions.
