# Quickstart: Flanker Game Loop

## Overview
How to play a 75-trial Flanker session on Hebbo.

## Setup Requirements
- Flutter SDK (latest stable)
- Dart SDK
- Physical Device (recommended for RT precision) or Emulator

## Implementation Checkpoints

1. **Verify Session Start**:
    - App starts at completion level of last session.
    - Difficulty ( Congruency/ISI mapping) matches requirements at start.

2. **Verify Trial Response**:
    - Tapping Left/Right screen halves records correctness and RT instantly.
    - Stimuli disappears and is replaced by feedback (Green/Red) on the target rectangle.
    - Neutral pause (ISI) occurs before next stimulus.

3. **Verify Timeout (2000ms)**:
    - Failing to respond correctly within the time limit is recorded as incorrect trial.

4. **Verify Session Data Persistence**:
   - Complete 75 trials.
   - Use `flutter test` or database inspector to verify exactly 75 records in `trials` table.
   - Verify 1 session record in `sessions` table.

## Key Tasks for this Milestone
- Confirm zero database writes exist for aborted/reset sessions.
- Verify AdaptiveEngineNotifier correctly scales level based on performance.
- Ensure placeholder visuals do not interfere with timing accuracy.
