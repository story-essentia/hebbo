enum TaskRule { parity, magnitude }

enum FeedbackType { none, success, fail, timeout }

class TaskSwitchStimulus {
  final int digit;
  final TaskRule rule;
  final bool isSwitch;

  const TaskSwitchStimulus({
    required this.digit,
    required this.rule,
    required this.isSwitch,
  });
}

class TaskSwitchState {
  final int trialsRemaining;
  final bool isStimulusActive;
  final FeedbackType feedbackState;
  final bool isPaused;
  final bool isSessionComplete;
  final bool isPersisted;
  final bool isResetting;
  final int resetDurationMs;
  final bool isWaitingForContinue;
  final TaskSwitchStimulus? currentStimulus;
  final List<Map<String, dynamic>> bufferedTrials;
  final int? switchCostMs;
  final String? saveError;

  const TaskSwitchState({
    this.trialsRemaining = 0,
    this.isStimulusActive = false,
    this.feedbackState = FeedbackType.none,
    this.isPaused = false,
    this.isSessionComplete = false,
    this.isPersisted = false,
    this.isResetting = false,
    this.resetDurationMs = 200,
    this.isWaitingForContinue = false,
    this.currentStimulus,
    this.bufferedTrials = const [],
    this.switchCostMs,
    this.saveError,
  });

  TaskSwitchState copyWith({
    int? trialsRemaining,
    bool? isStimulusActive,
    FeedbackType? feedbackState,
    bool? isPaused,
    bool? isSessionComplete,
    bool? isPersisted,
    bool? isResetting,
    int? resetDurationMs,
    bool? isWaitingForContinue,
    TaskSwitchStimulus? currentStimulus,
    List<Map<String, dynamic>>? bufferedTrials,
    int? switchCostMs,
    String? saveError,
  }) {
    return TaskSwitchState(
      trialsRemaining: trialsRemaining ?? this.trialsRemaining,
      isStimulusActive: isStimulusActive ?? this.isStimulusActive,
      feedbackState: feedbackState ?? this.feedbackState,
      isPaused: isPaused ?? this.isPaused,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      isPersisted: isPersisted ?? this.isPersisted,
      isResetting: isResetting ?? this.isResetting,
      resetDurationMs: resetDurationMs ?? this.resetDurationMs,
      isWaitingForContinue: isWaitingForContinue ?? this.isWaitingForContinue,
      currentStimulus: currentStimulus ?? this.currentStimulus,
      bufferedTrials: bufferedTrials ?? this.bufferedTrials,
      switchCostMs: switchCostMs ?? this.switchCostMs,
      saveError: saveError ?? this.saveError,
    );
  }
}
