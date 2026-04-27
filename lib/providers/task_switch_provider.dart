import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/logic/task_switch_generator.dart';
import 'package:hebbo/providers/adaptive_engine_provider.dart';
import 'package:hebbo/providers/notification_provider.dart';
import 'package:hebbo/providers/audio_provider.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/repositories/i_trial_repository.dart';
import 'package:hebbo/repositories/i_session_repository.dart';
import 'package:hebbo/state/task_switch_state.dart';
import 'package:hebbo/models/trial_entity.dart';
import 'package:hebbo/models/session_entity.dart';
import 'package:hebbo/database/error_handler.dart';
import 'package:hebbo/providers/progress_provider.dart';

final taskSwitchGeneratorProvider = Provider((ref) => TaskSwitchTrialGenerator());

final taskSwitchGameProvider = StateNotifierProvider<TaskSwitchGameNotifier, TaskSwitchState>((ref) {
  final generator = ref.watch(taskSwitchGeneratorProvider);
  final adaptiveEngine = ref.watch(adaptiveEngineProvider.notifier);
  final trialRepo = ref.watch(trialRepositoryProvider);
  final sessionRepo = ref.watch(sessionRepositoryProvider);

  return TaskSwitchGameNotifier(
    ref,
    generator,
    adaptiveEngine,
    trialRepo,
    sessionRepo,
  );
});

class TaskSwitchGameNotifier extends StateNotifier<TaskSwitchState> {
  final Ref _ref;
  final TaskSwitchTrialGenerator _generator;
  final AdaptiveEngineNotifier _adaptiveEngine;
  final ITrialRepository _trialRepo;
  final ISessionRepository _sessionRepo;

  Timer? _timeoutTimer;
  Timer? _countdownTimer;
  final Stopwatch _stopwatch = Stopwatch();
  DateTime? _sessionStartTime;
  int _initialLevel = 1;

  TaskSwitchGameNotifier(
    this._ref,
    this._generator,
    this._adaptiveEngine,
    this._trialRepo,
    this._sessionRepo,
  ) : super(const TaskSwitchState());

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

  void startSession(int initialLevel) {
    _sessionStartTime = DateTime.now();
    _initialLevel = initialLevel;
    _adaptiveEngine.reset(initialLevel);
    _generator.reset();

    state = const TaskSwitchState(
      trialsRemaining: 75,
      isCountingDown: true,
      countdownValue: 3,
    );

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final newValue = state.countdownValue - 1;
      if (newValue <= 0) {
        timer.cancel();
        state = state.copyWith(isCountingDown: false, countdownValue: 0);
        _nextTrial(initialLevel);
      } else {
        state = state.copyWith(countdownValue: newValue);
      }
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
      isResetting: false,
    );

    _stopwatch.reset();
    _stopwatch.start();

    // Removed automatic timeout transition to let user finish at their own pace
  }

  void reportResponse(bool isRight) {
    if (!state.isStimulusActive || state.isPaused) return;
    
    _timeoutTimer?.cancel();
    _stopwatch.stop();

    final reactionTime = _stopwatch.elapsedMilliseconds;
    final stimulus = state.currentStimulus!;
    
    bool isCorrect = false;
    if (stimulus.rule == TaskRule.parity) {
      // Left (false) = Odd, Right (true) = Even
      final isEven = stimulus.digit % 2 == 0;
      isCorrect = isRight == isEven;
    } else {
      // Left (false) = Lower than 5, Right (true) = Higher than 5
      final isHigher = stimulus.digit > 5;
      isCorrect = isRight == isHigher;
    }

    final deadline = _isiMap[_adaptiveEngine.state.currentLevel] ?? 1500;
    final isTooSlow = reactionTime > deadline;

    // Report to adaptive engine: correct ONLY if right AND fast
    _adaptiveEngine.reportTrial(isCorrect && !isTooSlow, reactionTime);
    final nextLevel = _adaptiveEngine.state.currentLevel;

    final trialData = {
      'rt': reactionTime,
      'correct': isCorrect, // Keep true accuracy for stats
      'level': nextLevel,
      'type': stimulus.isSwitch ? 'switch' : 'repeat',
      'metadata': 'rule:${stimulus.rule.name},digit:${stimulus.digit}${isTooSlow ? ',slow:true' : ''}',
    };

    state = state.copyWith(
      isStimulusActive: false,
      feedbackState: isCorrect ? FeedbackType.success : FeedbackType.fail,
      trialsRemaining: state.trialsRemaining - 1,
      bufferedTrials: [...state.bufferedTrials, trialData],
    );

    // Trigger audio feedback
    if (isCorrect) {
      unawaited(_ref.read(gameAudioProvider).playCorrectTap());
    } else {
      unawaited(_ref.read(gameAudioProvider).playWrongTap());
    }

    // 200ms feedback, then next trial
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _nextTrial(nextLevel);
    });
  }

  // _handleTimeout removed to prioritize user input over automatic transitions

  void togglePause() {
    if (state.isSessionComplete) return;

    if (state.isPaused) {
      _stopwatch.start();
      _nextTrial(_adaptiveEngine.state.currentLevel);
    } else {
      _stopwatch.stop();
      _timeoutTimer?.cancel();
    }

    state = state.copyWith(isPaused: !state.isPaused);
  }

  Future<void> _persistSession() async {
    try {
      final sessions = await _sessionRepo.getSessionsByGame('task-switching');
      final nextSessionNum = sessions.length + 1;
      
      unawaited(_ref.read(gameAudioProvider).playSessionComplete());

      final endingLevel = _adaptiveEngine.state.currentLevel;

      final sessionId = await _sessionRepo.insertSession(
        SessionEntity(
          gameId: 'task-switching',
          sessionNum: nextSessionNum,
          startedAt: _sessionStartTime ?? DateTime.now(),
          endedAt: DateTime.now(),
          startingLevel: _initialLevel,
          endingLevel: endingLevel,
          environmentTier: 1, // Fixed for US1
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
            metadata: data['metadata'],
          ),
        );
      }

      await _adaptiveEngine.save('task-switching');

      // Calculate switch cost for display
      final correctTrials = state.bufferedTrials.where((t) => t['correct'] == true).toList();
      final switchTrials = correctTrials.where((t) => t['type'] == 'switch').toList();
      final repeatTrials = correctTrials.where((t) => t['type'] == 'repeat').toList();

      int? switchCost;
      if (switchTrials.isNotEmpty && repeatTrials.isNotEmpty) {
        final avgSwitch = switchTrials.map((t) => t['rt'] as int).reduce((a, b) => a + b) / switchTrials.length;
        final avgRepeat = repeatTrials.map((t) => t['rt'] as int).reduce((a, b) => a + b) / repeatTrials.length;
        switchCost = (avgSwitch - avgRepeat).round();
      }

      state = state.copyWith(
        isSessionComplete: true,
        isPersisted: true,
        switchCostMs: switchCost,
      );
      _ref.invalidate(progressProvider);
    } catch (e) {
      if (DatabaseErrorExtractor.isStorageFull(e)) {
        state = state.copyWith(
          isSessionComplete: true,
          isPersisted: false,
          saveError: e.toString(),
        );
        NotificationService.showStorageFullError();
      } else {
        rethrow;
      }
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
