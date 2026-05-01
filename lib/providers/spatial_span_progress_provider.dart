import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/database_provider.dart';

class SpatialSpanProgressState {
  final int track1MaxSpan;
  final int track2MaxSpan;
  final int track3MaxSpan;
  final bool isInitialLoading;

  const SpatialSpanProgressState({
    this.track1MaxSpan = 2,
    this.track2MaxSpan = 0,
    this.track3MaxSpan = 0,
    this.isInitialLoading = true,
  });

  SpatialSpanProgressState copyWith({
    int? track1MaxSpan,
    int? track2MaxSpan,
    int? track3MaxSpan,
    bool? isInitialLoading,
  }) {
    return SpatialSpanProgressState(
      track1MaxSpan: track1MaxSpan ?? this.track1MaxSpan,
      track2MaxSpan: track2MaxSpan ?? this.track2MaxSpan,
      track3MaxSpan: track3MaxSpan ?? this.track3MaxSpan,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    );
  }
}

class SpatialSpanProgressNotifier extends StateNotifier<SpatialSpanProgressState> {
  final Ref _ref;

  SpatialSpanProgressNotifier(this._ref) : super(const SpatialSpanProgressState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final db = _ref.read(databaseProvider);
    
    final track1Progress = await db.getSpatialSpanProgress(1);
    final track2Progress = await db.getSpatialSpanProgress(2);
    final track3Progress = await db.getSpatialSpanProgress(3);

    state = state.copyWith(
      track1MaxSpan: track1Progress?.maxSpanReached ?? 2,
      track2MaxSpan: track2Progress?.maxSpanReached ?? 0,
      track3MaxSpan: track3Progress?.maxSpanReached ?? 0,
      isInitialLoading: false,
    );
  }

  Future<void> updateMaxSpan(int trackId, int newSpan) async {
    final db = _ref.read(databaseProvider);
    await db.updateSpatialSpanProgress(trackId, newSpan);

    if (trackId == 1) {
        if (newSpan > state.track1MaxSpan) {
            state = state.copyWith(track1MaxSpan: newSpan);
        }
    } else if (trackId == 2) {
        if (newSpan > state.track2MaxSpan) {
            state = state.copyWith(track2MaxSpan: newSpan);
        }
    } else if (trackId == 3) {
        if (newSpan > state.track3MaxSpan) {
            state = state.copyWith(track3MaxSpan: newSpan);
        }
    }
  }
}

final spatialSpanProgressProvider = StateNotifierProvider<SpatialSpanProgressNotifier, SpatialSpanProgressState>((ref) {
  return SpatialSpanProgressNotifier(ref);
});
