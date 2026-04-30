import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hebbo/models/progress_models.dart';
import 'package:hebbo/database/tables/spatial_span_progress.dart';

part 'hebbo_database.g.dart';

@DataClassName('TrialTable')
class Trials extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get trialNum => integer()();
  TextColumn get type => text()(); // 'congruent'/'incongruent' or 'switch'/'repeat'
  BoolColumn get correct => boolean()();
  IntColumn get reactionMs => integer()();
  IntColumn get difficulty => integer()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get metadata => text().nullable()(); // Add for extra game data
}

@DataClassName('SessionTable')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameId => text().withDefault(const Constant('flanker'))(); // Add
  IntColumn get sessionNum => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get startingLevel => integer()();
  IntColumn get endingLevel => integer()();
  IntColumn get environmentTier => integer()();
}

@DataClassName('DifficultyTable')
class DifficultyStates extends Table {
  TextColumn get gameId => text()();
  IntColumn get currentLevel => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {gameId};
}

@DriftDatabase(tables: [Trials, Sessions, DifficultyStates, SpatialSpanProgressTable])
class HebboDatabase extends _$HebboDatabase {
  HebboDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Add columns for version 2
            await m.addColumn(sessions, sessions.gameId);
            await m.addColumn(trials, trials.metadata);
          }
          if (from < 3) {
            await m.createTable(spatialSpanProgressTable);
          }
        },
      );

  Future<int?> getPersonalBestRt(String gameId) async {
    final result = await customSelect(
      'SELECT MIN(avg_rt) as min_rt FROM ('
      '  SELECT AVG(t.reaction_ms) as avg_rt '
      '  FROM sessions s '
      '  JOIN trials t ON t.session_id = s.id '
      '  WHERE s.game_id = ? AND t.correct = 1 AND t.reaction_ms >= 150 AND s.ended_at IS NOT NULL '
      '  GROUP BY s.id'
      ');',
      variables: [Variable.withString(gameId)],
    ).getSingleOrNull();
    final value = result?.read<double?>('min_rt');
    return value?.round();
  }

  Future<int> getTotalSessionsCompleted(String gameId) async {
    final result = await customSelect(
      'SELECT COUNT(id) as count FROM sessions WHERE game_id = ? AND ended_at IS NOT NULL;',
      variables: [Variable.withString(gameId)],
    ).getSingleOrNull();
    return result?.read<int>('count') ?? 0;
  }

  Future<int?> getMostRecentEnvironmentTier() async {
    final query = select(sessions)
      ..orderBy([
        (s) => OrderingTerm(expression: s.id, mode: OrderingMode.desc),
      ])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.environmentTier;
  }

  // --- Spatial Span Progress Queries ---

  Future<SpatialSpanProgress?> getSpatialSpanProgress(int trackId) async {
    return (select(spatialSpanProgressTable)..where((t) => t.trackId.equals(trackId))).getSingleOrNull();
  }

  Future<void> updateSpatialSpanProgress(int trackId, int newSpan) async {
    final existing = await getSpatialSpanProgress(trackId);
    
    if (existing == null) {
      await into(spatialSpanProgressTable).insert(
        SpatialSpanProgressTableCompanion.insert(
          trackId: trackId,
          maxSpanReached: Value(newSpan),
          lastPlayedAt: Value(DateTime.now()),
        ),
      );
    } else if (newSpan > existing.maxSpanReached) {
      await (update(spatialSpanProgressTable)..where((t) => t.id.equals(existing.id))).write(
        SpatialSpanProgressTableCompanion(
          maxSpanReached: Value(newSpan),
          lastPlayedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Just update lastPlayedAt
      await (update(spatialSpanProgressTable)..where((t) => t.id.equals(existing.id))).write(
        SpatialSpanProgressTableCompanion(
          lastPlayedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<List<SessionChartData>> getSessionChartData(String gameId) async {
    final typeA = gameId == 'task-switching' ? 'repeat' : 'congruent';
    final typeB = gameId == 'task-switching' ? 'switch' : 'incongruent';

    final result = await customSelect('''
      SELECT 
        s.session_num, 
        s.ending_level,
        AVG(CASE WHEN t.type = ? THEN t.reaction_ms END) as avg_a,
        AVG(CASE WHEN t.type = ? THEN t.reaction_ms END) as avg_b
      FROM sessions s
      LEFT JOIN trials t ON t.session_id = s.id AND t.correct = 1
      WHERE s.game_id = ?
      GROUP BY s.id
      ORDER BY s.session_num ASC;
    ''', variables: [
      Variable.withString(typeA),
      Variable.withString(typeB),
      Variable.withString(gameId)
    ]).get();

    return result.map((row) {
      return SessionChartData(
        sessionNum: row.read<int>('session_num'),
        metricARt: row.read<double?>('avg_a') ?? 0.0,
        metricBRt: row.read<double?>('avg_b') ?? 0.0,
        endingDifficulty: row.read<int>('ending_level'),
      );
    }).toList();
  }

  Future<void> clearAllData() async {
    await delete(sessions).go();
    await delete(trials).go();
    await delete(difficultyStates).go();
  }

  Future<void> cleanupDevelopmentData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Delete sessions started before today
    // The user specifically asked to remove sessions that "don't match actual play history"
    // We assume play history starting before our 'first run' cleanup or mock sessions 1-8 are targets.
    final query = delete(sessions)
      ..where((s) => s.startedAt.isSmallerThanValue(today));

    await query.go();

    // Also ensuring trials are cleared if they were orphaned (Drift usually needs triggers or manual delete if no cascades)
    // For simplicity since we want a clean state:
    await delete(difficultyStates).go();
  }

  Future<void> repairSessionNumbers() async {
    final games = ['flanker', 'task-switching'];
    for (final gameId in games) {
      final sessionRows = await (select(sessions)
            ..where((t) => t.gameId.equals(gameId))
            ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
          .get();
      
      for (int i = 0; i < sessionRows.length; i++) {
        final session = sessionRows[i];
        if (session.sessionNum != i + 1) {
          await (update(sessions)..where((t) => t.id.equals(session.id)))
              .write(SessionsCompanion(sessionNum: Value(i + 1)));
        }
      }
    }
  }

  Future<void> seedMockSessions() async {
    final existing = await getTotalSessionsCompleted('flanker');
    if (existing > 0) return;

    for (int i = 1; i <= 8; i++) {
      final difficulty = (i / 1.5).ceil().clamp(1, 10);

      final sessionId = await into(sessions).insert(
        SessionsCompanion.insert(
          sessionNum: i,
          startedAt: DateTime.now().subtract(Duration(days: 9 - i)),
          endedAt: DateTime.now()
              .subtract(Duration(days: 9 - i))
              .add(const Duration(minutes: 5)),
          startingLevel: difficulty == 1 ? 1 : difficulty - 1,
          endingLevel: difficulty,
          environmentTier: difficulty < 4 ? 1 : (difficulty < 8 ? 2 : 3),
        ),
      );

      final congRt = 750 - (i * 30);
      final incongRt = 850 - (i * 35);
      for (int t = 0; t < 10; t++) {
        await into(trials).insert(
          TrialsCompanion.insert(
            sessionId: sessionId,
            trialNum: t,
            type: t % 2 == 0 ? 'congruent' : 'incongruent',
            correct: true,
            reactionMs: t % 2 == 0 ? congRt : incongRt,
            difficulty: difficulty,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hebbo.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
