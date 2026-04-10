import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/i_difficulty_repository.dart';
import '../state/adaptive_difficulty_state.dart';

class AdaptiveEngineNotifier extends StateNotifier<AdaptiveDifficultyState> {
  final IDifficultyRepository _repository;

  AdaptiveEngineNotifier(this._repository) : super(AdaptiveDifficultyState.initial());

  /// Loads the initial difficulty level from persistence.
  Future<void> load(String gameId) async {
    final startLevel = await _repository.getDifficultyForGame(gameId);
    if (startLevel != null) {
      state = state.copyWith(currentLevel: startLevel);
    }
  }

  /// Saves the current level to persistence.
  Future<void> save(String gameId) async {
    await _repository.upsertDifficulty(gameId, state.currentLevel);
  }

  /// Reports a single trial result and evaluates windows for level adjustments.
  void reportTrial(bool correct) {
    // 1. Update windows
    final newUpWindow = List<bool>.from(state.upWindow)..add(correct);
    final newDownWindow = List<bool>.from(state.downWindow)..add(correct);

    // 2. Trim windows if they exceed max lengths
    final trimmedUp = newUpWindow.length > 20 ? newUpWindow.sublist(newUpWindow.length - 20) : newUpWindow;
    final trimmedDown = newDownWindow.length > 10 ? newDownWindow.sublist(newDownWindow.length - 10) : newDownWindow;

    state = state.copyWith(
      upWindow: trimmedUp,
      downWindow: trimmedDown,
    );

    // 3. Evaluate Level UP (80% accuracy over 20 trials)
    if (state.upWindow.length == 20) {
      if (state.upAccuracy >= 0.8) {
        _performLevelShift(1);
        return; // Slate Reset ends the evaluation
      }
    }

    // 4. Evaluate Level DOWN (< 60% accuracy over 10 trials, triggered only by failure)
    if (!correct && state.downWindow.length == 10) {
      if (state.downAccuracy < 0.6) {
        _performLevelShift(-1);
        return;
      }
    }
  }

  void _performLevelShift(int delta) {
    int newLevel = state.currentLevel + delta;
    
    // Boundary enforcement 1-10
    if (newLevel < 1) newLevel = 1;
    if (newLevel > 10) newLevel = 10;

    // Slate Reset: Level changes or boundary triggers always clear windows
    state = state.copyWith(
      currentLevel: newLevel,
      upWindow: [],
      downWindow: [],
    );
  }

  /// Resets the engine to a specific level and clears all performance history.
  void reset(int level) {
    state = AdaptiveDifficultyState(
      currentLevel: level.clamp(1, 10),
      upWindow: const [],
      downWindow: const [],
    );
  }
}

final difficultyRepositoryProvider = Provider<IDifficultyRepository>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final adaptiveEngineProvider = StateNotifierProvider<AdaptiveEngineNotifier, AdaptiveDifficultyState>((ref) {
  final repo = ref.watch(difficultyRepositoryProvider);
  return AdaptiveEngineNotifier(repo);
});
