# Quickstart: Spatial Span Game Milestone 1

## Verification Steps

### 1. Visual Verification (The Shard)
- Navigate to the **Spatial Span** test screen.
- Verify the background is **Deep Velvet Purple** (#150629) with drifting particles.
- Observe the **Luminous Shards**:
  - Geometric pentagon/hexagon shape.
  - Soft neon glow (no hard borders).
- Tap a shard and verify:
  - 1.2x scale pulse.
  - Ring emission animation.

### 2. Logic Verification (The Engine)
- Start a session.
- Observe the demonstration phase:
  - Shards pulse one-by-one.
  - Interval is exactly 1000ms.
- Perform the recall phase:
  - Tap the shards in the same order.
  - Correct sequence should show a success indicator and proceed.
  - Incorrect tap should show a failure indicator.

### 3. Adaptive Verification (2-out-of-3)
- Successfully complete 2 trials at the starting span (default N=3).
- Verify the span increases to N+1 for the next trial.
- Fail 2 trials and verify the session ends.

## Key Files
- `lib/providers/spatial_span_provider.dart`
- `lib/widgets/shard_painter.dart`
- `lib/widgets/game_countdown_overlay.dart` (Reused for session start)
