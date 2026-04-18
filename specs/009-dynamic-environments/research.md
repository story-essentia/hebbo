# Research: Dynamic Parallax Environments

## Decision 1: Parallax Wrapping Logic
- **Decision**: Use an `offsetPercentage` (0.0 to 1.0) derived from the `AnimationController` and map it to a `(offset % canvasWidth)` in the `paint` method.
- **Rationale**: Simplest math for infinite looping. By drawing the same layer twice (at `x` and `x - width`), we ensure no gaps when an element crosses the boundary.
- **Alternatives considered**: Moving individual `Particle` objects in a list. Rejected as it has higher CPU overhead (N objects vs 1 math operation per layer).

## Decision 2: Temporal Acceleration (Forward Motion)
- **Decision**: Implement a `speedMultiplier` in the `EnvironmentOrchestrator`. 
  - Default: `1.0`.
  - Trial-Reset: Animate multiplier from `1.0` to `10.0` over the first 25% of `resetDurationMs`, then back to `1.0`.
- **Rationale**: Smoothly scaling the multiplier feels more "organic" than an instant snap.
- **Alternatives considered**: Manual frame-by-frame offset increments. Rejected; less robust than leveraging Flutter's `AnimationController` ticker.

## Decision 3: Bioluminescent Glow (Deep Sea)
- **Decision**: Use `Paint.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma)` for the outer glow of the Level 8+ bio-circles.
- **Rationale**: Provides a premium soft-light effect without the performance hit of a full `BackdropFilter`.
- **Alternatives considered**: `ImageFiltered` widget. Rejected; too heavy for multiple small particles.

## Decision 4: Selection Logic (Background Swap)
- **Decision**: Use a `StatefulWidget` wrapper or a `Consumer` that switches between the three background widgets based on `ref.watch(adaptiveEngineProvider).currentLevel`.
- **Rationale**: Ensures the background is only swapped at the start of a session (when the screen builds) or dynamically if levels change mid-session.
