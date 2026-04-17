import 'package:drift/drift.dart';
import '../database/hebbo_database.dart';
import '../database/error_handler.dart';
import 'i_difficulty_repository.dart';

class DriftDifficultyRepository implements IDifficultyRepository {
  final HebboDatabase db;

  DriftDifficultyRepository(this.db);

  @override
  Future<void> upsertDifficulty(String gameId, int currentLevel) async {
    try {
      await db.into(db.difficultyStates).insertOnConflictUpdate(
            DifficultyStatesCompanion(
              gameId: Value(gameId),
              currentLevel: Value(currentLevel),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (e) {
      if (DatabaseErrorExtractor.isStorageFull(e)) {
        // Graceful failure as per FR-001/T006a
        return;
      }
      rethrow;
    }
  }

  @override
  Future<int?> getDifficultyForGame(String gameId) async {
    final query = db.select(db.difficultyStates)
      ..where((t) => t.gameId.equals(gameId));
    final row = await query.getSingleOrNull();
    return row?.currentLevel;
  }
}
