enum GamePhase { idle, demonstration, recall, feedback, complete }

enum FeedbackType { none, success, fail }

class SpatialSpanState {
  final int trackId;
  final int span;
  final int trialsInLevel;
  final int successesInLevel;
  final List<int> currentSequence;
  final List<int> userSequence;
  final GamePhase phase;
  final int? activeShardIndex;
  final int? noiseShardIndex;
  final double noiseScale;
  final FeedbackType feedbackState;
  final bool isPaused;
  final bool isResetting;
  final bool isCountingDown;
  final int countdownValue;
  final bool isSessionComplete;
  final List<int> shardPositions; // 9 indices from a 4x4 grid (0-15)

  const SpatialSpanState({
    this.trackId = 1,
    this.span = 3,
    this.trialsInLevel = 0,
    this.successesInLevel = 0,
    this.currentSequence = const [],
    this.userSequence = const [],
    this.phase = GamePhase.idle,
    this.activeShardIndex,
    this.noiseShardIndex,
    this.noiseScale = 1.0,
    this.feedbackState = FeedbackType.none,
    this.isPaused = false,
    this.isResetting = false,
    this.isCountingDown = false,
    this.countdownValue = 3,
    this.isSessionComplete = false,
    this.shardPositions = const [],
  });

  SpatialSpanState copyWith({
    int? trackId,
    int? span,
    int? trialsInLevel,
    int? successesInLevel,
    List<int>? currentSequence,
    List<int>? userSequence,
    GamePhase? phase,
    Object? activeShardIndex = _sentinel, // Use sentinel for null matching
    Object? noiseShardIndex = _sentinel,
    double? noiseScale,
    FeedbackType? feedbackState,
    bool? isPaused,
    bool? isResetting,
    bool? isCountingDown,
    int? countdownValue,
    bool? isSessionComplete,
    List<int>? shardPositions,
  }) {
    return SpatialSpanState(
      trackId: trackId ?? this.trackId,
      span: span ?? this.span,
      trialsInLevel: trialsInLevel ?? this.trialsInLevel,
      successesInLevel: successesInLevel ?? this.successesInLevel,
      currentSequence: currentSequence ?? this.currentSequence,
      userSequence: userSequence ?? this.userSequence,
      phase: phase ?? this.phase,
      activeShardIndex: activeShardIndex == _sentinel 
          ? this.activeShardIndex 
          : activeShardIndex as int?,
      noiseShardIndex: noiseShardIndex == _sentinel
          ? this.noiseShardIndex
          : noiseShardIndex as int?,
      noiseScale: noiseScale ?? this.noiseScale,
      feedbackState: feedbackState ?? this.feedbackState,
      isPaused: isPaused ?? this.isPaused,
      isResetting: isResetting ?? this.isResetting,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      countdownValue: countdownValue ?? this.countdownValue,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      shardPositions: shardPositions ?? this.shardPositions,
    );
  }
}

const _sentinel = Object();
