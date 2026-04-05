import 'package:drift/drift.dart';
import '../database/hebbo_database.dart';
import '../models/trial_entity.dart';
import 'i_trial_repository.dart';

class DriftTrialRepository implements ITrialRepository {
  final HebboDatabase db;

  DriftTrialRepository(this.db);

  @override
  Future<int> insertTrial(TrialEntity trial) {
    return db.into(db.trials).insert(TrialsCompanion(
      sessionId: Value(trial.sessionId),
      trialNum: Value(trial.trialNum),
      type: Value(trial.type),
      correct: Value(trial.correct),
      reactionMs: Value(trial.reactionMs),
      difficulty: Value(trial.difficulty),
      timestamp: Value(trial.timestamp),
    ));
  }

  @override
  Future<List<TrialEntity>> getTrialsForSession(int sessionId) async {
    final query = db.select(db.trials)..where((t) => t.sessionId.equals(sessionId));
    final rows = await query.get();
    return rows.map((row) => TrialEntity(
      id: row.id,
      sessionId: row.sessionId,
      trialNum: row.trialNum,
      type: row.type,
      correct: row.correct,
      reactionMs: row.reactionMs,
      difficulty: row.difficulty,
      timestamp: row.timestamp,
    )).toList();
  }
}
