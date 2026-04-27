import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/state/spatial_span_state.dart';

final spatialSpanProvider = StateNotifierProvider<SpatialSpanNotifier, SpatialSpanState>((ref) {
  return SpatialSpanNotifier();
});

class SpatialSpanNotifier extends StateNotifier<SpatialSpanState> {
  SpatialSpanNotifier() : super(const SpatialSpanState());

  Timer? _demonstrationTimer;
  int _currentDemoIndex = 0;

  void startSession() {
    // Generate 9 random positions in a 4x4 grid (0-15)
    final allPositions = List.generate(16, (i) => i)..shuffle();
    final shardPositions = allPositions.take(9).toList();

    state = SpatialSpanState(
      span: 3,
      shardPositions: shardPositions,
      phase: GamePhase.idle,
      isCountingDown: true,
      countdownValue: 3,
    );

    _startCountdown();
  }

  void _startCountdown() {
    _demonstrationTimer?.cancel();
    _demonstrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdownValue > 1) {
        state = state.copyWith(countdownValue: state.countdownValue - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isCountingDown: false);
        _startNextTrial();
      }
    });
  }

  void togglePause() {
    if (state.isCountingDown || state.phase == GamePhase.complete) return;
    
    final newPaused = !state.isPaused;
    state = state.copyWith(isPaused: newPaused);
    
    if (newPaused) {
      _demonstrationTimer?.cancel();
    } else {
      if (state.phase == GamePhase.demonstration) {
        _runDemonstration();
      }
    }
  }

  void _startNextTrial() {
    final sequence = _generateSequence(state.span);
    
    state = state.copyWith(
      currentSequence: sequence,
      userSequence: [],
      phase: GamePhase.demonstration,
      activeShardIndex: null,
      feedbackState: FeedbackType.none,
    );

    _currentDemoIndex = 0;
    _runDemonstration();
  }

  List<int> _generateSequence(int length) {
    final list = List.generate(9, (i) => i)..shuffle();
    return list.take(length).toList();
  }

  void _runDemonstration() {
    _demonstrationTimer?.cancel();
    
    _demonstrationTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (_currentDemoIndex >= state.currentSequence.length) {
        timer.cancel();
        state = state.copyWith(
          phase: GamePhase.recall,
          activeShardIndex: null,
        );
        return;
      }

      // Step 1: Light up the shard
      final shardIdx = state.currentSequence[_currentDemoIndex];
      state = state.copyWith(activeShardIndex: shardIdx);
      
      // Step 2: Turn it off after 800ms so there is a visual gap
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && state.activeShardIndex == shardIdx) {
          state = state.copyWith(activeShardIndex: null);
        }
      });

      _currentDemoIndex++;
    });
  }

  void handleShardTap(int index) {
    if (state.phase != GamePhase.recall || state.isPaused) return;

    final nextExpectedIndex = state.currentSequence[state.userSequence.length];
    final newUserSequence = [...state.userSequence, index];

    if (index == nextExpectedIndex) {
      state = state.copyWith(userSequence: newUserSequence);
      
      if (newUserSequence.length == state.currentSequence.length) {
        _handleTrialResult(true);
      }
    } else {
      _handleTrialResult(false);
    }
  }

  void _handleTrialResult(bool success) {
    final newSuccesses = state.successesInLevel + (success ? 1 : 0);
    final newTrials = state.trialsInLevel + 1;

    state = state.copyWith(
      phase: GamePhase.feedback,
      feedbackState: success ? FeedbackType.success : FeedbackType.fail,
      successesInLevel: newSuccesses,
      trialsInLevel: newTrials,
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      if (newSuccesses == 2) {
        // Level up
        state = state.copyWith(
          span: state.span + 1,
          successesInLevel: 0,
          trialsInLevel: 0,
        );
        _startNextTrial();
      } else if (newTrials - newSuccesses == 2) {
        // Fail level / end session (Simplified for Milestone 1)
        state = state.copyWith(phase: GamePhase.complete);
      } else {
        // Try again at same span
        _startNextTrial();
      }
    });
  }

  @override
  void dispose() {
    _demonstrationTimer?.cancel();
    super.dispose();
  }
}
