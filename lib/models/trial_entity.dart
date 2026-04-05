class TrialEntity {
  final int? id;
  final int sessionId;
  final int trialNum;
  final String type;
  final bool correct;
  final int reactionMs;
  final int difficulty;
  final DateTime timestamp;

  TrialEntity({
    this.id,
    required this.sessionId,
    required this.trialNum,
    required this.type,
    required this.correct,
    required this.reactionMs,
    required this.difficulty,
    required this.timestamp,
  });
}
