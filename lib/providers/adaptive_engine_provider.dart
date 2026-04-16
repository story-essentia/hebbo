import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/i_difficulty_repository.dart';
import '../state/adaptive_difficulty_state.dart';

class AdaptiveEngineNotifier extends StateNotifier<AdaptiveDifficultyState> {
  final IDifficultyRepository _repository;

  static const Map<int, int> _isiMap = {
    1: 1500,
    2: 1300,
    3: 1100,
    4: 950,
    5: 800,
    6: 700,
    7: 600,
    8: 500,
    9: 450,
    10: 400,
  };

  AdaptiveEngineNotifier(this._repository)
      : super(AdaptiveDifficultyState.initial());

  Future<void> load(String gameId) async {
    final startLevel = await _repository.getDifficultyForGame(gameId);
    if (startLevel != null) {
      state = state.copyWith(currentLevel: startLevel);
    }
  }

  Future<void> save(String gameId) async {
    await _repository.upsertDifficulty(gameId, state.currentLevel);
  }

  void reportTrial(bool correct, int reactionMs) {
    // 1. Update windows
    final newUpWindow = List<bool>.from(state.upWindow)..add(correct);
    final newUpRtWindow = List<int>.from(state.upRtWindow)..add(reactionMs);
    final newDownWindow = List<bool>.from(state.downWindow)..add(correct);
    final newDownRtWindow = List<int>.from(state.downRtWindow)..add(reactionMs);

    // 2. Trim windows
    final trimmedUp = newUpWindow.length > 20
        ? newUpWindow.sublist(newUpWindow.length - 20)
        : newUpWindow;
    final trimmedUpRt = newUpRtWindow.length > 20
        ? newUpRtWindow.sublist(newUpRtWindow.length - 20)
        : newUpRtWindow;
    final trimmedDown = newDownWindow.length > 10
        ? newDownWindow.sublist(newDownWindow.length - 10)
        : newDownWindow;
    final trimmedDownRt = newDownRtWindow.length > 10
        ? newDownRtWindow.sublist(newDownRtWindow.length - 10)
        : newDownRtWindow;

    state = state.copyWith(
      upWindow: trimmedUp,
      upRtWindow: trimmedUpRt,
      downWindow: trimmedDown,
      downRtWindow: trimmedDownRt,
    );

    // 3. Evaluate Level UP / Maintenance (20-trial window)
    if (state.upWindow.length == 20) {
      if (state.upAccuracy >= 0.8) {
        final currentLevel = state.currentLevel;
        final currentIsi = _isiMap[currentLevel] ?? 800;
        final nextLevelIsi = _isiMap[currentLevel + 1] ?? 0;
        final averageRt = state.avgRt;

        if (averageRt <= nextLevelIsi && currentLevel < 10) {
          // Rule: Acc >= 80% AND RT <= Next Level ISI -> Level UP
          _performLevelShift(1);
        } else if (averageRt > currentIsi) {
          // Rule: Acc >= 80% BUT RT > Current Level ISI -> Level DOWN
          _performLevelShift(-1);
        } else {
          // Rule: Acc >= 80% AND RT is between Next ISI and Current ISI -> Stay
          // Reset windows to evaluate next block of 20
          state = state.copyWith(
            upWindow: [],
            upRtWindow: [],
            downWindow: [],
            downRtWindow: [],
          );
        }
        return;
      }
    }

    // 4. Evaluate Level DOWN (10-trial performance accuracy window, triggered by failure)
    if (!correct && state.downWindow.length == 10) {
      if (state.downAccuracy < 0.6) {
        _performLevelShift(-1);
        return;
      }
    }
  }

  void _performLevelShift(int delta) {
    int newLevel = (state.currentLevel + delta).clamp(1, 10);

    state = state.copyWith(
      currentLevel: newLevel,
      upWindow: [],
      upRtWindow: [],
      downWindow: [],
      downRtWindow: [],
    );
  }

  void reset(int level) {
    state = AdaptiveDifficultyState(
      currentLevel: level.clamp(1, 10),
      upWindow: const [],
      downWindow: const [],
      upRtWindow: const [],
      downRtWindow: const [],
    );
  }
}

final difficultyRepositoryProvider = Provider<IDifficultyRepository>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final adaptiveEngineProvider =
    StateNotifierProvider<AdaptiveEngineNotifier, AdaptiveDifficultyState>((
  ref,
) {
  final repo = ref.watch(difficultyRepositoryProvider);
  return AdaptiveEngineNotifier(repo);
});
