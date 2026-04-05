abstract class IDifficultyRepository {
  Future<void> upsertDifficulty(String gameId, int currentLevel);
  Future<int?> getDifficultyForGame(String gameId);
}
