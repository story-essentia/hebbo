class SessionEntity {
  final int? id;
  final String gameId;
  final int sessionNum;
  final DateTime startedAt;
  final DateTime endedAt;
  final int startingLevel;
  final int endingLevel;
  final int environmentTier;

  SessionEntity({
    this.id,
    this.gameId = 'flanker',
    required this.sessionNum,
    required this.startedAt,
    required this.endedAt,
    required this.startingLevel,
    required this.endingLevel,
    required this.environmentTier,
  });
}
