# Quickstart: Progress Screen

## Getting Started

1. **Install Dependencies**
   Run the following to add the charting package:
   ```bash
   flutter pub add fl_chart
   ```

2. **Database Seeder**
   Before building the UI, implement a seeding script (e.g. static method on the database or provider) to insert 8 mock sessions into the Drift database. This allows visual testing of the chart. The sessions should have increasing session numbers, decreasing RTs (congruent 750 -> 450, incongruent 850 -> 580), and increasing difficulty (1 -> 6).

3. **Database Repository Methods**
   Extend the `DriftTrialRepository` (or equivalent) to provide:
   - `getPersonalBestRt()`: returns `int?`
   - `getAverageTrialRtPerSession()`: returns grouped raw data.

4. **UI Implementation**
   - Create `ProgressScreen` in `lib/screens/progress_screen.dart`.
   - Build 3 cards in a horizontal `Row` for the metrics.
   - Build the `LineChart` below. Implement `LineChartData` mapping the scaled difficulty values alongside the regular RT values. Use the right titles area for the 1-10 labels.
   - Add a subtle text button "All time" / "Last 10" to toggle the list subset fed to the chart.

5. **Navigation integration**
   - In `SessionEndPlaceholder`, update the `See progress` button to do `Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()))`.
