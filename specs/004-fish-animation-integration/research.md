# Research: Fish Animation Integration

## Decision 1: `path_drawing` Performance
- **Finding**: The existing implementation correctly uses `static` variables to cache parsed `Path` objects. This avoids expensive SVG path parsing during the `paint` loop.
- **Rationale**: Since the paths are static, the performance overhead is limited to the `canvas.drawPath` calls themselves, which are hardware-accelerated on modern mobile devices like the Pixel 6a.
- **Decision**: Continue using `path_drawing` as structured.

## Decision 2: Horizontal Mirroring
- **Finding**: Using `canvas.scale(-1, 1)` is the industry-standard way to mirror content in Flutter/Skia without creating new assets.
- **Rationale**: It effectively flips the coordinate system. By also applying `canvas.translate(-size.width, 0)`, we keep the fish centered within its original bounding box.
- **Decision**: Implement mirroring at the start of the `paint` method for `right` states.

## Decision 3: Device Pixel Ratio (DPR)
- **Finding**: The `_FishPainter` scales from a fixed 200x200 viewBox to the widget's logical size.
- **Decision**: This automatically handles DPR because logical sizes in Flutter have the device pixel ratio baked in during final rendering. No extra math is required.

## Decision 4: Concurrency & FPS
- **Finding**: Having 5 concurrent `AnimatedFish` widgets means 5 tickers ticking at 60Hz. Each Painter has ~10-15 `drawPath`/`drawCircle` calls.
- **Rationale**: Modern mobile GPUs can easily handle ~50-100 draw calls per frame at 60FPS. The Pixel 6a is highly capable of this.
- **Decision**: Proceed with `FishRowWidget` as a row of 5 independent widgets.
