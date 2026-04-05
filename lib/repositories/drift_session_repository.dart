import 'package:drift/drift.dart';
import '../database/hebbo_database.dart';
import '../models/session_entity.dart';
import 'i_session_repository.dart';

class DriftSessionRepository implements ISessionRepository {
  final HebboDatabase db;

  DriftSessionRepository(this.db);

  @override
  Future<int> insertSession(SessionEntity session) {
    return db.into(db.sessions).insert(SessionsCompanion(
      sessionNum: Value(session.sessionNum),
      startedAt: Value(session.startedAt),
      endedAt: Value(session.endedAt),
      startingLevel: Value(session.startingLevel),
      endingLevel: Value(session.endingLevel),
      environmentTier: Value(session.environmentTier),
    ));
  }

  @override
  Future<List<SessionEntity>> getAllSessions() async {
    final query = db.select(db.sessions)..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    final rows = await query.get();
    return rows.map((row) => SessionEntity(
      id: row.id,
      sessionNum: row.sessionNum,
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      startingLevel: row.startingLevel,
      endingLevel: row.endingLevel,
      environmentTier: row.environmentTier,
    )).toList();
  }
}
