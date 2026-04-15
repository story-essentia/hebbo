import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/models/progress_models.dart';
import 'package:hebbo/providers/database_provider.dart';

class ProgressState {
  final ProgressMetrics metrics;
  final List<SessionChartData> chartData;
  final bool showAllTime;

  ProgressState({
    required this.metrics,
    required this.chartData,
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
    );
  }
}

class ProgressNotifier extends AsyncNotifier<ProgressState> {
  @override
  Future<ProgressState> build() async {
    return _fetchData(false);
  }

  Future<ProgressState> _fetchData(bool showAllTime) async {
    final db = ref.read(databaseProvider);

    // Development only: Seed test data so user doesn't have to play 75 trials
    await db.seedMockSessions();

    final pbRt = await db.getPersonalBestRt() ?? 0;
    final totalSessions = await db.getTotalSessionsCompleted();

    final tierInt = await db.getMostRecentEnvironmentTier() ?? 1;
    String envName = "Shallow reef";
    if (tierInt == 2) envName = "Open ocean";
    if (tierInt >= 3) envName = "Deep sea";

    final metrics = ProgressMetrics(
      personalBestRtMs: pbRt,
      totalSessionsCompleted: totalSessions,
      currentEnvironmentTier: envName,
    );

    final rawData = await db.getSessionChartData();
    var displayData = rawData;

    if (!showAllTime && displayData.length > 10) {
      displayData = displayData.sublist(displayData.length - 10);
    }

    return ProgressState(
      metrics: metrics,
      chartData: displayData,
      showAllTime: showAllTime,
    );
  }

  Future<void> toggleViewMode() async {
    if (state.value == null) return;

    final newShowAllTime = !state.value!.showAllTime;

    // We could either filter in-memory or refetch.
    // Since we need to slice differently based on limit, refetching is safest,
    // or just re-slice the full list if we kept it. Re-fetching is very cheap here.
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData(newShowAllTime));
  }
}

final progressProvider = AsyncNotifierProvider<ProgressNotifier, ProgressState>(
  () {
    return ProgressNotifier();
  },
);
