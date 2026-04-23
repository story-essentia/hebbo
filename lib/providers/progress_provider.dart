import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/models/progress_models.dart';
import 'package:hebbo/providers/database_provider.dart';

class ProgressState {
  final ProgressMetrics metrics;
  final List<SessionChartData> chartData;
  final bool showAllTime;
  final String gameId;

  ProgressState({
    required this.metrics,
    required this.chartData,
    required this.gameId,
    this.showAllTime = false,
  });

  ProgressState copyWith({
    ProgressMetrics? metrics,
    List<SessionChartData>? chartData,
    bool? showAllTime,
  }) {
    return ProgressState(
      metrics: metrics ?? this.metrics,
      chartData: chartData ?? this.chartData,
      showAllTime: showAllTime ?? this.showAllTime,
      gameId: gameId,
    );
  }
}

class ProgressNotifier extends FamilyAsyncNotifier<ProgressState, String> {
  @override
  Future<ProgressState> build(String arg) async {
    return _fetchData(arg, false);
  }

  Future<ProgressState> _fetchData(String gameId, bool showAllTime) async {
    final db = ref.read(databaseProvider);

    // Mock data seeding removed as requested

    final pbRt = await db.getPersonalBestRt(gameId) ?? 0;
    final totalSessions = await db.getTotalSessionsCompleted(gameId);

    ProgressMetrics metrics;
    if (gameId == 'flanker') {
      final tierInt = await db.getMostRecentEnvironmentTier() ?? 1;
      String envName = "Shallow Reef";
      if (tierInt == 2) envName = "Open Ocean";
      if (tierInt >= 3) envName = "Deep Sea";
      
      metrics = ProgressMetrics(
        personalBestRtMs: pbRt,
        totalSessionsCompleted: totalSessions,
        currentEnvironmentTier: envName,
      );
    } else {
      metrics = ProgressMetrics(
        personalBestRtMs: pbRt,
        totalSessionsCompleted: totalSessions,
        rewardLabel: "Electric Nocturne",
      );
    }

    final rawData = await db.getSessionChartData(gameId);
    var displayData = rawData;

    if (!showAllTime && displayData.length > 10) {
      displayData = displayData.sublist(displayData.length - 10);
    }

    return ProgressState(
      metrics: metrics,
      chartData: displayData,
      showAllTime: showAllTime,
      gameId: gameId,
    );
  }

  Future<void> toggleViewMode() async {
    if (state.value == null) return;
    final currentState = state.value!;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData(arg, !currentState.showAllTime));
  }
}

final progressProvider = AsyncNotifierProviderFamily<ProgressNotifier, ProgressState, String>(
  () => ProgressNotifier(),
);
