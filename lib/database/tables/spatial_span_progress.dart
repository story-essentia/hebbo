import 'package:drift/drift.dart';

@DataClassName('SpatialSpanProgress')
class SpatialSpanProgressTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackId => integer()();
  IntColumn get maxSpanReached => integer().withDefault(const Constant(2))();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
}
