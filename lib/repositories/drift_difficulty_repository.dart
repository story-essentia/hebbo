import 'package:drift/drift.dart';
import '../database/hebbo_database.dart';
import 'i_difficulty_repository.dart';

class DriftDifficultyRepository implements IDifficultyRepository {
  final HebboDatabase db;

  DriftDifficultyRepository(this.db);

  @override
  Future<void> upsertDifficulty(String gameId, int currentLevel) async {
    await db
        .into(db.difficultyStates)
        .insertOnConflictUpdate(
          DifficultyStatesCompanion(
            gameId: Value(gameId),
            currentLevel: Value(currentLevel),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<int?> getDifficultyForGame(String gameId) async {
    final query = db.select(db.difficultyStates)
      ..where((t) => t.gameId.equals(gameId));
    final row = await query.getSingleOrNull();
    return row?.currentLevel;
  }
}
