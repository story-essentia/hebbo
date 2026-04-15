import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/database/hebbo_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<HebboDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});
