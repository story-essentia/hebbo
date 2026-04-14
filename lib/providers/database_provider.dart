import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/database/hebbo_database.dart';

final databaseProvider = Provider<HebboDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});
