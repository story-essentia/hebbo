class AdaptiveDifficultyState {
  final int currentLevel;
  final List<bool> upWindow;
  final List<bool> downWindow;
  final List<int> upRtWindow;
  final List<int> downRtWindow;

  const AdaptiveDifficultyState({
    required this.currentLevel,
    required this.upWindow,
    required this.downWindow,
    required this.upRtWindow,
    required this.downRtWindow,
  });

  factory AdaptiveDifficultyState.initial() {
    return const AdaptiveDifficultyState(
      currentLevel: 1,
      upWindow: [],
      downWindow: [],
      upRtWindow: [],
      downRtWindow: [],
    );
  }

  AdaptiveDifficultyState copyWith({
    int? currentLevel,
    List<bool>? upWindow,
    List<bool>? downWindow,
    List<int>? upRtWindow,
    List<int>? downRtWindow,
  }) {
    return AdaptiveDifficultyState(
      currentLevel: currentLevel ?? this.currentLevel,
      upWindow: upWindow ?? this.upWindow,
      downWindow: downWindow ?? this.downWindow,
      upRtWindow: upRtWindow ?? this.upRtWindow,
      downRtWindow: downRtWindow ?? this.downRtWindow,
    );
  }

  double get upAccuracy {
    if (upWindow.isEmpty) return 0.0;
    final hits = upWindow.where((hit) => hit).length;
    return hits / upWindow.length;
  }

  double get downAccuracy {
    if (downWindow.isEmpty) return 0.0;
    final hits = downWindow.where((hit) => hit).length;
    return hits / downWindow.length;
  }

  double get avgRt {
    if (upRtWindow.isEmpty) return 0.0;
    final total = upRtWindow.fold(0, (sum, rt) => sum + rt);
    return total / upRtWindow.length;
  }

  @override
  String toString() {
    return 'AdaptiveDifficultyState(level: $currentLevel, up: ${upWindow.length}, down: ${downWindow.length}, upAcc: ${upAccuracy.toStringAsFixed(2)}, downAcc: ${downAccuracy.toStringAsFixed(2)}, avgRt: ${avgRt.toStringAsFixed(0)}ms)';
  }
}
