# Data Model: Dynamic Environments

## Overview
This feature does not introduce new persistent database tables. It consumes the existing `currentLevel` from the session state and `AdaptiveEngine`.

## Consumed Entities

### AdaptiveEngine (State)
- **currentLevel** (int, range 1-10): The primary selector for the background environment.
  - 1..3 -> `ShallowReef`
  - 4..7 -> `OpenOcean`
  - 8..10 -> `DeepSea`

### FlankerSessionState (State)
- **isResetting** (bool): Used to trigger the temporal acceleration (forward movement).
- **resetDurationMs** (int): Used to synchronize the acceleration curve with the fish animation.

## UI Contracts (Internal)

### ParallaxLayer
- **speed**: multiplier for the global animation value.
- **painter**: specific logic for drawing (Ellipses, Kelp, Particles).
- **layerIndex**: 1 (Background), 2 (Midground), 3 (Foreground).
