import 'package:hebbo/logic/flanker_domain.dart';

class FlankerStimulus {
  final Side targetDirection;
  final bool isCongruent;

  const FlankerStimulus({
    required this.targetDirection,
    required this.isCongruent,
  });

  @override
  String toString() =>
      'FlankerStimulus(target: $targetDirection, congruent: $isCongruent)';
}

class FlankerSessionState {
  final int trialsRemaining;
  final FlankerStimulus? currentStimulus;
  final bool isStimulusActive;
  final FeedbackType feedbackState;
  final List<dynamic> bufferedTrials;
  final bool isSessionComplete;

  /// True before the very first trial — fish are in top-down state.
  final bool isPreTrial;

  /// True between trials — fish return to top-down during reset.
  final bool isResetting;

  /// True when timeout occurred — game holds until the player taps to continue.
  final bool isWaitingForContinue;

  /// Dynamic duration for the reset phase (ms).
  final int resetDurationMs;

  /// True when the game is manually paused by the user.
  final bool isPaused;

  final bool isPersisted;
  final String? saveError;

  final bool isCountingDown;
  final int countdownValue;

  const FlankerSessionState({
    this.trialsRemaining = 75,
    this.currentStimulus,
    this.isStimulusActive = false,
    this.feedbackState = FeedbackType.none,
    this.bufferedTrials = const [],
    this.isSessionComplete = false,
    this.isPreTrial = false,
    this.isResetting = false,
    this.isWaitingForContinue = false,
    this.resetDurationMs = 500,
    this.isPaused = false,
    this.isPersisted = true,
    this.saveError,
    this.isCountingDown = false,
    this.countdownValue = 0,
  });

  FlankerSessionState copyWith({
    int? trialsRemaining,
    FlankerStimulus? currentStimulus,
    bool? isStimulusActive,
    FeedbackType? feedbackState,
    List<dynamic>? bufferedTrials,
    bool? isSessionComplete,
    bool? isPreTrial,
    bool? isResetting,
    bool? isWaitingForContinue,
    int? resetDurationMs,
    bool? isPaused,
    bool? isPersisted,
    String? saveError,
    bool? isCountingDown,
    int? countdownValue,
  }) {
    return FlankerSessionState(
      trialsRemaining: trialsRemaining ?? this.trialsRemaining,
      currentStimulus: currentStimulus ?? this.currentStimulus,
      isStimulusActive: isStimulusActive ?? this.isStimulusActive,
      feedbackState: feedbackState ?? this.feedbackState,
      bufferedTrials: bufferedTrials ?? this.bufferedTrials,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      isPreTrial: isPreTrial ?? this.isPreTrial,
      isResetting: isResetting ?? this.isResetting,
      isWaitingForContinue: isWaitingForContinue ?? this.isWaitingForContinue,
      resetDurationMs: resetDurationMs ?? this.resetDurationMs,
      isPaused: isPaused ?? this.isPaused,
      isPersisted: isPersisted ?? this.isPersisted,
      saveError: saveError ?? this.saveError,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      countdownValue: countdownValue ?? this.countdownValue,
    );
  }
}
