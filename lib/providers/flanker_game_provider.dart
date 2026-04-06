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

final flankerTrialGeneratorProvider = Provider((ref) => FlankerTrialGenerator());

final flankerGameProvider = StateNotifierProvider<FlankerGameNotifier, FlankerSessionState>((ref) {
  final generator = ref.watch(flankerTrialGeneratorProvider);
  final adaptiveEngine = ref.watch(adaptiveEngineProvider.notifier);
  final trialRepo = ref.watch(trialRepositoryProvider);
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  
  return FlankerGameNotifier(generator, adaptiveEngine, trialRepo, sessionRepo);
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

  FlankerGameNotifier(
    this._generator, 
    this._adaptiveEngine,
    this._trialRepo,
    this._sessionRepo,
  ) : super(const FlankerSessionState());

  static const Map<int, int> _isiMap = {
    1: 1500, 2: 1300, 3: 1100, 4: 950, 5: 800,
    6: 700, 7: 600, 8: 500, 9: 450, 10: 400,
  };

  void startSession(int initialLevel) {
    _sessionStartTime = DateTime.now();
    _initialLevel = initialLevel;
    state = const FlankerSessionState(trialsRemaining: 75);
    _nextTrial(initialLevel);
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
    );

    _stopwatch.reset();
    _stopwatch.start();

    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(milliseconds: 2000), () {
      _handleResponse(null);
    });
  }

  void reportResponse(Side side) {
    if (!state.isStimulusActive) return;
    _handleResponse(side);
  }

  void _handleResponse(Side? side) {
    _timeoutTimer?.cancel();
    _stopwatch.stop();

    final reactionTime = _stopwatch.elapsedMilliseconds;
    final stimulus = state.currentStimulus;
    final isCorrect = side != null && side == stimulus?.targetDirection;

    _adaptiveEngine.reportTrial(isCorrect);
    final nextLevel = _adaptiveEngine.state.currentLevel;

    final trialData = {
      'rt': reactionTime,
      'correct': isCorrect,
      'level': nextLevel,
      'type': stimulus != null ? (stimulus.isCongruent ? 'congruent' : 'incongruent') : 'unknown',
    };

    state = state.copyWith(
      isStimulusActive: false,
      feedbackState: isCorrect 
          ? FeedbackType.success 
          : (side == null ? FeedbackType.timeout : FeedbackType.fail),
      trialsRemaining: state.trialsRemaining - 1,
      bufferedTrials: [...state.bufferedTrials, trialData],
    );

    final delay = _isiMap[nextLevel] ?? 800;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _nextTrial(nextLevel);
    });
  }

  Future<void> _persistSession() async {
    final sessions = await _sessionRepo.getAllSessions();
    final nextSessionNum = sessions.length + 1;

    final sessionId = await _sessionRepo.insertSession(SessionEntity(
      sessionNum: nextSessionNum,
      startedAt: _sessionStartTime ?? DateTime.now(),
      endedAt: DateTime.now(),
      startingLevel: _initialLevel,
      endingLevel: _adaptiveEngine.state.currentLevel,
      environmentTier: 1, // Default for Flanker
    ));

    for (var i = 0; i < state.bufferedTrials.length; i++) {
      final data = state.bufferedTrials[i];
      await _trialRepo.insertTrial(TrialEntity(
        sessionId: sessionId,
        trialNum: i + 1,
        type: data['type'],
        correct: data['correct'],
        reactionMs: data['rt'],
        difficulty: data['level'],
        timestamp: DateTime.now(),
      ));
    }
    
    // Level persistence is handled at game engine boundaries (spec 002)
    // but the session persistence makes the current level available for next session.
    state = state.copyWith(isSessionComplete: true);
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }
}
