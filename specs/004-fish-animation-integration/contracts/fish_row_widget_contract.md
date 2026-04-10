# UI Contract: FishRowWidget

## Purpose
Encapuslate the layout and state mapping for the 5-fish stimuli row used in the Flanker task.

## Interface
The widget will be reactive to the `FlankerSessionState` provided via Riverpod.

### Input Data
- **Central Fish**: Mapped from `state.currentStimulus.targetDirection`.
- **Flanking Fish**: Mapped from calculated congruence/incongruence directions.
- **Trial Status**: Mapped from `state.isStimulusActive` and `state.feedbackState`.

### Layout Constants
- **Center Fish Size**: 280.0 x 280.0 logical pixels.
- **Flanker Fish Size**: 240.0 x 240.0 logical pixels.
- **Alignment**: Horizontal center.

### Animation Durations (Managed by Logic)
- **Feedback duration**: 400ms.
- **Timeout duration**: 300ms.
- **ISI (Inter-Stimulus Interval)**: Varies by level (managed by existing adaptive engine).
