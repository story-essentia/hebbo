# Research: Task Switching Implementation

## Decision 1: Lightweight Particle System
**Decision**: Use a simplified `CustomPainter` with a fixed-size buffer of particle objects updated via a single `Ticker`.

**Rationale**: 
- Third-party packages like `confetti` or `particle_field` are either too heavy or too opinionated for the "Electric Nocturne" style.
- A manual `CustomPainter` allows for precise control over radial gradients and "glow" attributes using `MaskFilter.blur`.
- By using a fixed list of objects and avoiding `setState` for every frame in the main widget (using `Listenable` on the painter instead), we maintain 60fps with minimal overhead.

**Alternatives Considered**: 
- `Lottie`: Too static for interactive depth.
- `Rive`: Excellent but introduces external dependency and asset weight.

## Decision 2: Adaptive Engine Extension
**Decision**: Refactor `AdaptiveEngine` to be more generic, or create a specific `TaskSwitchAdaptiveAdapter` that maps the core accuracy signals to Switch Probability and ISI.

**Rationale**: 
- Flanker's adaptive logic is already proven. 
- Levels 1-10 will map:
    - `switchProbability`: 0.2 + (level * 0.05) [clamped at 0.7]
    - `responseDeadline`: 1500 - (level * 110) [clamped at 400ms]
- This follows the Grok-defined table precisely.

**Alternatives Considered**: 
- Independent logic: Rejected to maintain consistency across games.

## Decision 3: Neon Orb Animation States
**Decision**: A dedicated `NeonOrbStateMachine` class managing a single `AnimationController` with multiple `TweenSequence` animations for:
- `correct`: Scale pulse (1.0 -> 1.1 -> 1.0) + border brightness boost.
- `incorrect`: Horizontal offset "shake" (5px left/right) + color change.
- `timeout`: Alpha fade + particle scattering.

**Rationale**: 
- This matches the "FishAnimationStateMachine" pattern used in Flanker, ensuring developers who worked on Flanker can immediately understand the Task Switching visuals.

## Decisions on High-Precision Timing
**Decision**: Use `Stopwatch` class for RT measurement.
**Rationale**: `DateTime.now()` is not monotonic and can be affected by system clock sync. `Stopwatch` is standard for high-precision latency measurement in Flutter/Dart.
