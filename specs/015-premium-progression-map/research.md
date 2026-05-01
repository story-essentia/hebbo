# Phase 0: Research & Technical Approach

## 1. CustomPainter Premium Rendering

**Decision**: Utilize `Shader` (specifically `LinearGradient`) and `MaskFilter.blur` in `Paint` to create premium glowing lines and jeweled nodes.
**Rationale**: Flutter's `Canvas` API natively supports hardware-accelerated shaders and blurs. This approach allows us to create the "premium" neon aesthetic (inner glows, gradients, drop shadows) while maintaining 60fps performance without relying on external image assets.
**Alternatives considered**: 
- *Using Image Assets*: Pre-rendered PNG/WebP images for nodes. Rejected because it breaks dynamic scaling and makes color-theming difficult.

## 2. Rendering All Tracks Unconditionally

**Decision**: Modify `_generateNodes` in `progression_map_screen.dart` to remove the `if (track2Visible)` and `if (track3Visible)` checks, ensuring all three tracks are always generated.
**Rationale**: This fulfills the requirement to show all tracks to new players so they understand the game's scope. Nodes that are locked will simply have `isUnlocked: false`.
**Alternatives considered**:
- *Fading out invisible tracks*: Rejected because generating them and rendering them as locked (dimmed) is cleaner and more engaging.

## 3. Locked Node Visual State

**Decision**: Introduce an explicit `isLocked` visual state in `ProgressionMapPainter`. Locked nodes will use a significantly reduced opacity (e.g., 0.1 or 0.2) and remove the outer glow to distinguish them from unlocked and playable nodes.
**Rationale**: Clear visual hierarchy prevents user frustration and visually communicates progress.
