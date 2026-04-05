class DifficultyEntity {
  final String gameId;
  final int currentLevel;
  final DateTime updatedAt;

  DifficultyEntity({
    required this.gameId,
    required this.currentLevel,
    required this.updatedAt,
  });
}
