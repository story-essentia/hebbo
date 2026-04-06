# Research: Adaptive Difficulty Engine

## Decision: Dart `Queue` vs `List` for Rolling Windows

### Rationale
- **Rolling Windows**: Using `List` with `takeLast(N)` or `sublist` is standard in Dart 3 and efficient enough for 10-20 entries.
- **Trimming**: Simple `take` or `takeLast` logic in a collection spread is readable and performant for sub-1ms state updates.

### Alternatives Considered
- **dart:collection Queue**: Faster for very large lists, but overkill for Hebbo's 20-trial windows. `List` provides easier indexing for accuracy calculations.

## Decision: Riverpod `StateNotifier` for Sync Logic

### Rationale
- **Performance**: Standard `StateNotifier` provides synchronous state updates for the game loop, which is critical for zero-frame-drop.
- **Initialization**: Initializing from an asynchronous repository (Drift) is done via `AsyncValue` or by loading into the state during the provider's `onInit` equivalent.

### Alternatives Considered
- **AsyncNotifier**: Better for data that is *always* being fetched, but since difficulty is primarily a memory-resident variable updated in session-start/save, `StateNotifier` is more predictable for sync trial reporting.

## Decision: Threshold Math for Accuracy

### Rationale
- **Calculation**: Accuracy = `100 * (trials.where((t) => t == true).length / trials.length)`.
- **Level Increments**: Must evaluate both windows independently based on the current trial's status (FR-005).

## Dependencies

- **flutter_riverpod**: Mandatory for state management.
- **test**: Required for verification without UI.
