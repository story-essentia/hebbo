import 'package:hebbo/logic/flanker_domain.dart';

class FlankerStimulus {
  final Side targetDirection;
  final bool isCongruent;

  const FlankerStimulus({
    required this.targetDirection,
    required this.isCongruent,
  });

  @override
  String toString() => 'FlankerStimulus(target: $targetDirection, congruent: $isCongruent)';
}

class FlankerSessionState {
  final int trialsRemaining;
  final FlankerStimulus? currentStimulus;
  final bool isStimulusActive;
  final FeedbackType feedbackState;
  final List<dynamic> bufferedTrials;
  final bool isSessionComplete;

  const FlankerSessionState({
    this.trialsRemaining = 75,
    this.currentStimulus,
    this.isStimulusActive = false,
    this.feedbackState = FeedbackType.none,
    this.bufferedTrials = const [],
    this.isSessionComplete = false,
  });

  FlankerSessionState copyWith({
    int? trialsRemaining,
    FlankerStimulus? currentStimulus,
    bool? isStimulusActive,
    FeedbackType? feedbackState,
    List<dynamic>? bufferedTrials,
    bool? isSessionComplete,
  }) {
    return FlankerSessionState(
      trialsRemaining: trialsRemaining ?? this.trialsRemaining,
      currentStimulus: currentStimulus ?? this.currentStimulus,
      isStimulusActive: isStimulusActive ?? this.isStimulusActive,
      feedbackState: feedbackState ?? this.feedbackState,
      bufferedTrials: bufferedTrials ?? this.bufferedTrials,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
    );
  }
}
