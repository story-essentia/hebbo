# Hebbo Modularity Standard (Principle V)

## Core Requirement
The codebase must be modular enough that a new game can be added without touching core logic.

## Game Interface Standard
Every game in Hebbo must implement a standard interface to ensure consistent integration with the host application.

### 1. Data Contract
All game results must be recorded via the `TrialRepository` using the standard `Trial` model.
- `trials` table handles all game-specific data via the `type` and `difficulty` fields.
- New games should define a unique `gameId` for tracking difficulty state.

### 2. UI Isolation
- Games are standalone widgets.
- They must not depend on global app state except for the `TrialRepository` and necessary training parameters (e.g. current difficulty).

### 3. Contribution Guidelines
- External developers should be able to drop a new game folder into `lib/features/games/` and register it with the main navigation/menu.
- (Detailed registry mechanism to be defined in V2).
