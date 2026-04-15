import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/logic/flanker_trial_generator.dart';
import 'package:hebbo/models/session_entity.dart';
import 'package:hebbo/models/trial_entity.dart';
import 'package:hebbo/providers/adaptive_engine_provider.dart';
import 'package:hebbo/repositories/i_session_repository.dart';
import 'package:hebbo/repositories/i_trial_repository.dart';
import 'package:hebbo/state/flanker_session_state.dart';

final trialRepositoryProvider = Provider<ITrialRepository>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final sessionRepositoryProvider = Provider<ISessionRepository>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final flankerTrialGeneratorProvider = Provider(
  (ref) => FlankerTrialGenerator(),
);

final flankerGameProvider =
    StateNotifierProvider<FlankerGameNotifier, FlankerSessionState>((ref) {
      final generator = ref.watch(flankerTrialGeneratorProvider);
      final adaptiveEngine = ref.watch(adaptiveEngineProvider.notifier);
      final trialRepo = ref.watch(trialRepositoryProvider);
      final sessionRepo = ref.watch(sessionRepositoryProvider);

      return FlankerGameNotifier(
        generator,
        adaptiveEngine,
        trialRepo,
        sessionRepo,
      );
    });

class FlankerGameNotifier extends StateNotifier<FlankerSessionState> {
  final FlankerTrialGenerator _generator;
  final AdaptiveEngineNotifier _adaptiveEngine;
  final ITrialRepository _trialRepo;
  final ISessionRepository _sessionRepo;

  Timer? _timeoutTimer;
  final Stopwatch _stopwatch = Stopwatch();
  DateTime? _sessionStartTime;
  int _initialLevel = 1;
  int? _pausedRemainingMs;

  FlankerGameNotifier(
    this._generator,
    this._adaptiveEngine,
    this._trialRepo,
    this._sessionRepo,
  ) : super(const FlankerSessionState());

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

  /// Duration of correct/wrong feedback flash (ms)
  static const _feedbackDurationMs = 200;

  /// Duration of the top-down "reset" phase between trials (ms).
  static const _resetDurationMs = 500;

  /// Duration of the initial pre-trial top-down hold (ms)
  static const _preTrialHoldMs = 800;

  void startSession(int initialLevel) {
    _sessionStartTime = DateTime.now();
    _initialLevel = initialLevel;
    _adaptiveEngine.reset(initialLevel);

    // Start with all fish in top-down state before the first trial
    state = const FlankerSessionState(trialsRemaining: 75, isPreTrial: true);

    // Hold in top-down for a moment, then begin the first trial
    Future.delayed(const Duration(milliseconds: _preTrialHoldMs), () {
      if (mounted) _nextTrial(initialLevel);
    });
  }

  void _nextTrial(int level) {
    if (state.trialsRemaining <= 0) {
      _persistSession();
      return;
    }

    final stimulus = _generator.generateStimulus(level);

    state = state.copyWith(
      currentStimulus: stimulus,
      isStimulusActive: true,
      feedbackState: FeedbackType.none,
      isPreTrial: false,
      isResetting: false,
      isWaitingForContinue: false,
    );

    _stopwatch.reset();
    _stopwatch.start();

    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) _handleTimeout();
    });
  }

  void reportResponse(Side side) {
    if (!state.isStimulusActive || state.isPaused) return;
    _handleTapResponse(side);
  }

  /// Called when the player taps during an active trial.
  void _handleTapResponse(Side side) {
    _timeoutTimer?.cancel();
    _stopwatch.stop();

    final reactionTime = _stopwatch.elapsedMilliseconds;
    final stimulus = state.currentStimulus;
    final isCorrect = side == stimulus?.targetDirection;

    _adaptiveEngine.reportTrial(isCorrect);
    final nextLevel = _adaptiveEngine.state.currentLevel;

    final trialData = {
      'rt': reactionTime,
      'correct': isCorrect,
      'level': nextLevel,
      'type': stimulus != null
          ? (stimulus.isCongruent ? 'congruent' : 'incongruent')
          : 'unknown',
    };

    // Flash feedback for 200ms
    state = state.copyWith(
      isStimulusActive: false,
      feedbackState: isCorrect ? FeedbackType.success : FeedbackType.fail,
      trialsRemaining: state.trialsRemaining - 1,
      bufferedTrials: [...state.bufferedTrials, trialData],
    );

    // After the 200ms feedback flash, transition to top-down reset
    Future.delayed(const Duration(milliseconds: _feedbackDurationMs), () {
      if (!mounted) return;

      final totalIsi = _isiMap[nextLevel] ?? 800;
      final remainingReset = (totalIsi - _feedbackDurationMs).clamp(
        _resetDurationMs,
        totalIsi,
      );

      state = state.copyWith(
        feedbackState: FeedbackType.none,
        isResetting: true,
        resetDurationMs: remainingReset,
      );

      Future.delayed(Duration(milliseconds: remainingReset), () {
        if (mounted) _nextTrial(nextLevel);
      });
    });
  }

  /// Called when the 2000ms timeout fires — no player input.
  /// Records trial as incorrect, dims the fish, and waits for a continue tap.
  void _handleTimeout() {
    _stopwatch.stop();

    final reactionTime = _stopwatch.elapsedMilliseconds;
    final stimulus = state.currentStimulus;

    _adaptiveEngine.reportTrial(false);
    final nextLevel = _adaptiveEngine.state.currentLevel;

    final trialData = {
      'rt': reactionTime,
      'correct': false,
      'level': nextLevel,
      'type': stimulus != null
          ? (stimulus.isCongruent ? 'congruent' : 'incongruent')
          : 'unknown',
    };

    // Dim the fish and hold — wait for player to tap
    state = state.copyWith(
      isStimulusActive: false,
      feedbackState: FeedbackType.timeout,
      trialsRemaining: state.trialsRemaining - 1,
      bufferedTrials: [...state.bufferedTrials, trialData],
      isWaitingForContinue: true,
    );
  }

  /// Called when the player taps during a timeout-hold.
  /// This is NOT a trial response — just a continue signal.
  void continueAfterTimeout() {
    if (!state.isWaitingForContinue || state.isPaused) return;

    final nextLevel = _adaptiveEngine.state.currentLevel;

    final totalIsi = _isiMap[nextLevel] ?? 800;
    final resetDuration = totalIsi.clamp(_resetDurationMs, totalIsi);

    // Transition to top-down reset, then next trial
    state = state.copyWith(
      feedbackState: FeedbackType.none,
      isWaitingForContinue: false,
      isResetting: true,
      resetDurationMs: resetDuration,
    );

    Future.delayed(Duration(milliseconds: resetDuration), () {
      if (mounted) _nextTrial(nextLevel);
    });
  }

  void togglePause() {
    if (state.isSessionComplete || state.isResetting || state.isPreTrial) return;

    if (state.isPaused) {
      // Resume
      state = state.copyWith(isPaused: false);
      if (state.isStimulusActive) {
        _stopwatch.start();
        _timeoutTimer =
            Timer(Duration(milliseconds: _pausedRemainingMs ?? 2000), () {
          if (mounted) _handleTimeout();
        });
      }
    } else {
      // Pause
      if (state.isStimulusActive) {
        _pausedRemainingMs = (2000 - _stopwatch.elapsedMilliseconds).clamp(0, 2000);
        _stopwatch.stop();
        _timeoutTimer?.cancel();
      }
      state = state.copyWith(isPaused: true);
    }
  }

  Future<void> _persistSession() async {
    final sessions = await _sessionRepo.getAllSessions();
    final nextSessionNum = sessions.length + 1;

    final sessionId = await _sessionRepo.insertSession(
      SessionEntity(
        sessionNum: nextSessionNum,
        startedAt: _sessionStartTime ?? DateTime.now(),
        endedAt: DateTime.now(),
        startingLevel: _initialLevel,
        endingLevel: _adaptiveEngine.state.currentLevel,
        environmentTier: 1,
      ),
    );

    for (var i = 0; i < state.bufferedTrials.length; i++) {
      final data = state.bufferedTrials[i];
      await _trialRepo.insertTrial(
        TrialEntity(
          sessionId: sessionId,
          trialNum: i + 1,
          type: data['type'],
          correct: data['correct'],
          reactionMs: data['rt'],
          difficulty: data['level'],
          timestamp: DateTime.now(),
        ),
      );
    }

    state = state.copyWith(isSessionComplete: true);
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }
}
