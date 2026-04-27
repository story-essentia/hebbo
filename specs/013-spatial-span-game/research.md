# Research & Decisions: Spatial Span Game Milestone 1

## Decisions

### 1. Shard Layout & Density (KU-01)
- **Decision**: Implement a 4x4 coordinate system, but only populate 9 shards randomly.
- **Rationale**: 9 shards is the clinical Corsi standard. A 4x4 grid provides enough spatial entropy to ensure trials feel unique while preventing visual clutter on mobile screens.
- **Alternatives Considered**: Fixed positions (rejected as it reduces cognitive load over time).

### 2. Hit-Testing with Transformations (KU-02)
- **Decision**: Use Flutter's native `GestureDetector` on the individual shard widgets rather than a global tap listener.
- **Rationale**: If `Transform.perspective` is used, Flutter's hit-testing logic automatically accounts for the transformation matrix, ensuring the "visual" tap maps correctly to the "logical" widget without manual coordinate projection.
- **Alternatives Considered**: Global coordinate mapping (rejected as it's prone to bugs with nested transforms).

### 3. Rendering Performance (KU-03)
- **Decision**: Wrap the `ShardPainter` in a `RepaintBoundary` and use `MaskFilter.blur` on the `Paint` object, avoiding `BackdropFilter` where possible.
- **Rationale**: `MaskFilter` is significantly cheaper than `BackdropFilter` as it doesn't require a layer save/restore. `RepaintBoundary` ensures the heavy blur is only recalculated when the shard state (pulse) changes.
- **Alternatives Considered**: Image-based glows (rejected for lack of dynamic scaling quality).

### 4. Geometry Generation
- **Decision**: Use a simple mathematical path generator for regular polygons (pentagon/hexagon) within the `ShardPainter`.
- **Rationale**: Provides the organic "Luminous Shard" feel requested while keeping the implementation logic lean.

## Research Findings

### Adaptive Strategy (Corsi standard)
- Research confirms the "2-out-of-3" rule is more robust for training than a simple "1-of-1" advancement, as it filters out accidental correct guesses.

### Visual Effects
- The "No-Line Rule" requires that the shard boundaries be defined by the `MaskFilter` glow and internal gradients. A `RadialGradient` from `on-surface-variant` to `background` (fully transparent) is the recommended approach for the neon glow.
