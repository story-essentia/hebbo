class ProgressMetrics {
  final int personalBestRtMs;
  final int totalSessionsCompleted;
  final String currentEnvironmentTier;

  const ProgressMetrics({
    required this.personalBestRtMs,
    required this.totalSessionsCompleted,
    required this.currentEnvironmentTier,
  });
}

class SessionChartData {
  final int sessionNum;
  final double avgCongruentRt;
  final double avgIncongruentRt;
  final int endingDifficulty;

  const SessionChartData({
    required this.sessionNum,
    required this.avgCongruentRt,
    required this.avgIncongruentRt,
    required this.endingDifficulty,
  });
}
