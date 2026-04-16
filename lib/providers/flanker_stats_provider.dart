import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/models/stat_display_model.dart';
import 'package:hebbo/providers/database_provider.dart';

final flankerStatsProvider = FutureProvider<StatDisplayModel>((ref) async {
  final db = ref.watch(databaseProvider);
  
  final bestRt = await db.getPersonalBestRt();
  final totalSessions = await db.getTotalSessionsCompleted();
  
  return StatDisplayModel(
    bestRtMs: bestRt,
    totalSessions: totalSessions,
    hasPlayedBefore: totalSessions > 0,
  );
});
