# Research: Flanker Game Loop

## Decision: `Random` for Congruency Ratios

### Rationale
- **Probabilistic Generation**: Trial congruency is determined at stimulus onset: `Random().nextDouble() < incongruentRatio`.
- **Level Mapping**: The 30% to 70% incongruent mapping is applied linearly (matching the specification exactly).
- **Randomization Seed**: No seed is required for MVP, but the use of `Random.secure()` or `Random()` is sufficient for training variability.

### Alternatives Considered
- **Fixed Trial Sequences**: Pre-generated sequences for each level would ensure exactly 30% or 70% per level but would be repetitive across 75 trials and sessions. Probabilistic generation is more cognitively robust.

## Decision: stimulus Timing via `Stopwatch`

### Rationale
- **Precision**: `Stopwatch` is needed for millisecond accuracy of Reaction Time (RT).
- **Latency Handling**: Start the stopwatch exactly when `setState` (or equivalent) notifies the framework to render the stimuli.
- **Latency Offset**: No offset correction is required for the MVP as the app is running locally and Flutter's frame timing is reliable.

### Alternatives Considered
- **Timestamp Comparison**: `DateTime.now()` is prone to OS clock adjustments and lacks sub-millisecond precision. `Stopwatch` is preferred.

## Decision: `Future.delayed` for Response Window and ISI

### Rationale
- **ISI (Inter-Stimulus Interval)**: A fixed delay (based on level) between stimulus-off and stimulus-on.
- **2000ms Timeout**: A `Future.delayed` timer is launched with each stimulus. A successful response cancels/ignores the timeout.

### Alternatives Considered
- **Periodic Timer**: Too rigid for a reactive game loop. `async/await` with `Future.delayed` results in clearer, non-blocking code.

## Verification Scenarios

- **Manual Testing**: Confirm 200ms visual flash on correct/wrong on a physical device (Pixel 6a) to ensure zero frame drops during stimulus presentation.
- **Unit Testing**: Injecting timestamps and mocks to verify accuracy of RT measurements and final Drift data storage.
