import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hebbo.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
