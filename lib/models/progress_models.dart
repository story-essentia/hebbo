class ProgressMetrics {
  final int personalBestRtMs;
  final int totalSessionsCompleted;
  final String? currentEnvironmentTier; // Null for games without environments
  final String? rewardLabel;           // Alternative to environment (e.g. "Electric Nocturne")

  const ProgressMetrics({
    required this.personalBestRtMs,
    required this.totalSessionsCompleted,
    this.currentEnvironmentTier,
    this.rewardLabel,
  });
}

class SessionChartData {
  final int sessionNum;
  final double metricARt; // Congruent or Repeat
  final double metricBRt; // Incongruent or Switch
  final int endingDifficulty;

  const SessionChartData({
    required this.sessionNum,
    required this.metricARt,
    required this.metricBRt,
    required this.endingDifficulty,
  });
}
