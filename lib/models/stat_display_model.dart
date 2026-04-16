class StatDisplayModel {
  final int? bestRtMs;
  final int totalSessions;
  final bool hasPlayedBefore;

  const StatDisplayModel({
    required this.bestRtMs,
    required this.totalSessions,
    required this.hasPlayedBefore,
  });

  factory StatDisplayModel.empty() {
    return const StatDisplayModel(
      bestRtMs: null,
      totalSessions: 0,
      hasPlayedBefore: false,
    );
  }
}
