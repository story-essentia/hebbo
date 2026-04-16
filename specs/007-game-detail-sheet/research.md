# Research: Game detail bottom sheet

## Decision: Data Query Optimization
**Rationale**: The requirement asks for "lowest average reaction time recorded in a completed session". The current `getPersonalBestRt()` query in `HebboDatabase` returns the minimum single trial RT, which is incorrect.
**Implementation**: Update `getPersonalBestRt()` to use a subquery or custom SQL to aggregate average RT per session and then select the minimum.
**Alternatives considered**: Calculating this in Dart by fetching all sessions/trials. Rejected because SQL is more efficient for aggregation and minimizes data transfer.

## Decision: Shimmer Implementation
**Rationale**: Perceived performance is critical for "premium" design. Skeletons should appear immediately.
**Implementation**: Integrate the `shimmer` package. Create a reusable `StatChipSkeleton` widget that mimics the `StatChip` layout.
**Colors**: 
- Base: `Color(0xFF301A4D)` (Surface)
- Highlight: `Color(0xFF4D2A7A)` (Slightly lighter surface)

## Decision: Bottom Sheet Component
**Rationale**: Needs to feel like a native part of the "Electric Nocturne" experience.
**Implementation**: Use `showModalBottomSheet`. 
**Styling**:
- Background: `#150629`
- Shape: `RoundedRectangleBorder` (top-only corners, 32dp radius)
- Animation: Default Material 3 slide-up.

## Decision: Transition Logic
**Rationale**: Specification requires "immediate transition" to game.
**Implementation**: On Play button tap, trigger `Navigator.pushReplacement` or `Navigator.push` immediately. The sheet will implicitly be removed as the new route pushes over. If using `Navigator.pop` first, it would trigger a closing animation which violates the spec.
