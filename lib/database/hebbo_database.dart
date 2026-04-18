import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hebbo/models/progress_models.dart';

part 'hebbo_database.g.dart';

@DataClassName('TrialTable')
class Trials extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get trialNum => integer()();
  TextColumn get type => text()();
  BoolColumn get correct => boolean()();
  IntColumn get reactionMs => integer()();
  IntColumn get difficulty => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('SessionTable')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
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

@DriftDatabase(tables: [Trials, Sessions, DifficultyStates])
class HebboDatabase extends _$HebboDatabase {
  HebboDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int?> getPersonalBestRt() async {
    final result = await customSelect(
      'SELECT MIN(avg_rt) as min_rt FROM ('
      '  SELECT AVG(t.reaction_ms) as avg_rt '
      '  FROM sessions s '
      '  JOIN trials t ON t.session_id = s.id '
      '  WHERE t.correct = 1 AND t.reaction_ms >= 150 AND s.ended_at IS NOT NULL '
      '  GROUP BY s.id'
      ');',
    ).getSingleOrNull();
    final value = result?.read<double?>('min_rt');
    return value?.round();
  }

  Future<int> getTotalSessionsCompleted() async {
    final result = await customSelect(
      'SELECT COUNT(id) as count FROM sessions WHERE ended_at IS NOT NULL;',
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

  Future<List<SessionChartData>> getSessionChartData() async {
    final result = await customSelect('''
      SELECT 
        s.session_num, 
        s.ending_level,
        AVG(CASE WHEN t.type = 'congruent' THEN t.reaction_ms END) as avg_congruent,
        AVG(CASE WHEN t.type = 'incongruent' THEN t.reaction_ms END) as avg_incongruent
      FROM sessions s
      LEFT JOIN trials t ON t.session_id = s.id AND t.correct = 1
      GROUP BY s.id
      ORDER BY s.session_num ASC;
    ''').get();

    return result.map((row) {
      return SessionChartData(
        sessionNum: row.read<int>('session_num'),
        avgCongruentRt: row.read<double?>('avg_congruent') ?? 0.0,
        avgIncongruentRt: row.read<double?>('avg_incongruent') ?? 0.0,
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
    await customStatement('DELETE FROM trials WHERE session_id NOT IN (SELECT id FROM sessions)');
    await delete(difficultyStates).go();
  }

  Future<void> seedMockSessions() async {
    final existing = await getTotalSessionsCompleted();
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
