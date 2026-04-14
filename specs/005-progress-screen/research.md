# Research: Progress Screen

## 1. fl_chart Multi-Axis & Line Styling

**Decision**: Use `fl_chart` to render a single `LineChart` where the primary Y-axis (left) represents Reaction Time in milliseconds, and the secondary Y-axis (right) represents Difficulty Level (1-10). The difficulty values will be mathematically mapped/scaled to the RT coordinate space for plotting, but the right-side labels will render the 1-10 values.

**Rationale**: `fl_chart` provides `LineChartBarData` which supports `isStepLineChart: true` (for the difficulty line) and `dashArray` (for the incongruent dashed line). While it supports left and right title areas, it uses a single internal coordinate system. To show wildly different scales (e.g. RT 400-1000ms vs Difficulty 1-10), the difficulty values must be interpolated to the chart's Y bounds during plotting, while the `getTitlesWidget` for the right axis displays the unscaled values.

**Alternatives Considered**: `syncfusion_flutter_charts` supports true dual axes natively but requires a commercial license for some uses or is substantially heavier. `fl_chart` is standard, fully open-source, and already familiar in the Flutter ecosystem.

## 2. Drift Database Aggregations

**Decision**: Use a custom SQL query defined in `DriftTrialRepository` (or the database class) to fetch aggregated session metrics. 
For metric cards, we can query `MIN(reaction_ms) WHERE correct = 1` for the personal best, and `COUNT(id)` on sessions for the totals.
For chart data, we will fetch the session details and calculate averages per session and trial type using a custom query or Dart-side grouping of fetched trials. Given the database is entirely local and the number of sessions/trials for a single user is relatively small (e.g., thousands of rows max), fetching the trials and grouping in Dart is also highly performant and avoids complex SQL joins if preferred, but doing `SELECT session_id, type, AVG(reaction_ms) FROM trials WHERE correct = 1 GROUP BY session_id, type` is the most optimal.

**Rationale**: Custom SQL through Drift (`customSelect`) makes it trivial to get exact aggregation figures without over-fetching trial data, ensuring immediate load times.

**Alternatives Considered**: Fetching all trials into memory and using Dart's `fold` or `groupBy`. Drift's native custom queries are far more efficient and use local SQLite capabilities properly.
