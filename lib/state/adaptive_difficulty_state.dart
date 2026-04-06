class AdaptiveDifficultyState {
  final int currentLevel;
  final List<bool> upWindow;
  final List<bool> downWindow;

  const AdaptiveDifficultyState({
    required this.currentLevel,
    required this.upWindow,
    required this.downWindow,
  });

  factory AdaptiveDifficultyState.initial() {
    return const AdaptiveDifficultyState(
      currentLevel: 1,
      upWindow: [],
      downWindow: [],
    );
  }

  AdaptiveDifficultyState copyWith({
    int? currentLevel,
    List<bool>? upWindow,
    List<bool>? downWindow,
  }) {
    return AdaptiveDifficultyState(
      currentLevel: currentLevel ?? this.currentLevel,
      upWindow: upWindow ?? this.upWindow,
      downWindow: downWindow ?? this.downWindow,
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

  @override
  String toString() {
    return 'AdaptiveDifficultyState(level: $currentLevel, up: ${upWindow.length}, down: ${downWindow.length}, upAcc: ${upAccuracy.toStringAsFixed(2)}, downAcc: ${downAccuracy.toStringAsFixed(2)})';
  }
}
