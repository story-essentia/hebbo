# Data Model: Fish Animation Integration

## FishState (Extended)
The existing `FishState` enum will be expanded to encompass all possible trial outcomes and directions to ensure clear mapping between the game logic and visual output.

| State Name | Direction | Feedback | Visual Markers |
|------------|-----------|----------|----------------|
| `swimLeftNeutral` | Left | None | Standard Blue, Bubbles ON |
| `swimRightNeutral` | Right | None | Standard Blue, Mirrored, Bubbles ON |
| `swimLeftCorrect` | Left | Correct | Green Glow, Ripples, Bubbles OFF |
| `swimRightCorrect` | Right | Correct | Green Glow, Ripples, Mirrored, Bubbles OFF |
| `swimLeftWrong` | Left | Wrong | Red Glow, Ripples, Bubbles OFF |
| `swimRightWrong` | Right | Wrong | Red Glow, Ripples, Mirrored, Bubbles OFF |
| `timeoutNeutral` | N/A | Timeout | 40% Opacity, Neutral Blue, No Ripples, Bubbles OFF |

## State Transitions
Transitions are triggered by the `FlankerGameNotifier` upon user input or trial expiration.

- **Start Trial**: All fish set to `Neutral` (with appropriate direction).
- **Correct Tap**: Center fish -> `Correct`; Flankers remain `Neutral`.
- **Incorrect Tap**: Center fish -> `Wrong`; Flanker directions unchanged.
- **Timeout**: ALL fish -> `timeoutNeutral`.
