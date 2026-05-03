import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/state/spatial_span_state.dart';
import 'package:hebbo/providers/audio_provider.dart';
import 'package:hebbo/providers/spatial_span_progress_provider.dart';

final spatialSpanProvider =
    StateNotifierProvider<SpatialSpanNotifier, SpatialSpanState>((ref) {
      return SpatialSpanNotifier(ref);
    });

class SpatialSpanNotifier extends StateNotifier<SpatialSpanState> {
  final Ref _ref;

  SpatialSpanNotifier(this._ref) : super(const SpatialSpanState());

  Timer? _demonstrationTimer;
  Timer? _noiseTimer;
  int _currentDemoIndex = 0;
  final math.Random _random = math.Random();

  void startSession({int trackId = 1, int startingSpan = 3}) {
    // Generate 10 random positions in a 4x4 grid (0-15)
    final allPositions = List.generate(16, (i) => i)..shuffle();
    final shardPositions = allPositions.take(10).toList();

    state = SpatialSpanState(
      trackId: trackId,
      span: startingSpan,
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
      _noiseTimer?.cancel();
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
    final list = List.generate(10, (i) => i)..shuffle();
    return list.take(length).toList();
  }

  void _runDemonstration() {
    _demonstrationTimer?.cancel();
    _noiseTimer?.cancel();

    // Setup noise for Track 2
    if (state.trackId == 2) {
      _startNoiseTimer();
    }

    _demonstrationTimer = Timer.periodic(const Duration(milliseconds: 1200), (
      timer,
    ) {
      if (_currentDemoIndex >= state.currentSequence.length) {
        timer.cancel();
        _noiseTimer?.cancel();
        
        state = state.copyWith(
            phase: GamePhase.recall,
            activeShardIndex: null,
            noiseShardIndex: null,
        );
        return;
      }

      // Step 1: Light up the shard
      final shardIdx = state.currentSequence[_currentDemoIndex];
      state = state.copyWith(activeShardIndex: shardIdx);
      
      // Play flash sound
      _ref.read(gameAudioProvider).playSpatialSpanFlash();

      // Step 2: Turn it off after 800ms so there is a visual gap
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && state.activeShardIndex == shardIdx) {
          state = state.copyWith(activeShardIndex: null);
        }
      });

      _currentDemoIndex++;
    });
  }

  void _startNoiseTimer() {
    _noiseTimer?.cancel();

    final nextInterval = 300 + _random.nextInt(500); // 300ms to 800ms
    _noiseTimer = Timer(Duration(milliseconds: nextInterval), () {
      if (state.phase != GamePhase.demonstration || state.isPaused) return;

      // Pick a random shard that is NOT the active target
      final availableShards = List<int>.from(state.shardPositions)
        ..remove(state.activeShardIndex);

      if (availableShards.isNotEmpty) {
        final randomShard =
            availableShards[_random.nextInt(availableShards.length)];

        // Random scale between 1.1 and 1.3 to create a subtle expanding pulse
        final scale = 1.1 + (_random.nextDouble() * 0.2);

        state = state.copyWith(noiseShardIndex: randomShard, noiseScale: scale);

        // Turn off noise after brief pulse
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted && state.noiseShardIndex == randomShard) {
            state = state.copyWith(noiseShardIndex: null);
          }
        });
      }

      // Re-trigger recursively
      _startNoiseTimer();
    });
  }

  void handleShardTap(int index) {
    if (state.phase != GamePhase.recall || state.isPaused) return;

    final isReversed = state.trackId == 3;
    final targetIndexInSequence = isReversed
        ? state.currentSequence.length - 1 - state.userSequence.length
        : state.userSequence.length;
        
    final nextExpectedIndex = state.currentSequence[targetIndexInSequence];
    final newUserSequence = [...state.userSequence, index];

    if (index == nextExpectedIndex) {
      _ref.read(gameAudioProvider).playSpatialSpanCorrectTap();
      state = state.copyWith(userSequence: newUserSequence);

      if (newUserSequence.length == state.currentSequence.length) {
        _handleTrialResult(true, index);
      }
    } else {
      _ref.read(gameAudioProvider).playSpatialSpanWrongTap();
      _handleTrialResult(false, index);
    }
  }

  void _handleTrialResult(bool success, int tappedIndex) {
    final newSuccesses = state.successesInLevel + (success ? 1 : 0);
    final newTrials = state.trialsInLevel + 1;

    state = state.copyWith(
      phase: GamePhase.feedback,
      feedbackState: success ? FeedbackType.success : FeedbackType.fail,
      successesInLevel: newSuccesses,
      trialsInLevel: newTrials,
      // Temporarily store the wrong index in activeShardIndex for the shake animation
      activeShardIndex: success ? null : tappedIndex, 
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      if (newSuccesses == 2) {
        // Level up
        final nextSpan = math.min(10, state.span + 1);

        // Play level up sound
        _ref.read(gameAudioProvider).playLevelUp();

        // Save progression to DB
        _ref
            .read(spatialSpanProgressProvider.notifier)
            .updateMaxSpan(state.trackId, nextSpan);

        state = state.copyWith(
          span: nextSpan,
          successesInLevel: 0,
          trialsInLevel: 0,
        );
        _startNextTrial();
      } else if (newTrials - newSuccesses == 2) {
        // Level down instead of completing
        final prevSpan = math.max(3, state.span - 1);
        
        state = state.copyWith(
          span: prevSpan,
          successesInLevel: 0,
          trialsInLevel: 0,
        );
        _startNextTrial();
      } else {
        // Try again at same span
        _startNextTrial();
      }
    });
  }

  @override
  void dispose() {
    _demonstrationTimer?.cancel();
    _noiseTimer?.cancel();
    super.dispose();
  }
}
