import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/spatial_span_provider.dart';
import 'package:hebbo/widgets/shard_widget.dart';

class SpatialSpanGrid extends ConsumerWidget {
  const SpatialSpanGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spatialSpanProvider);
    
    if (state.shardPositions.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final cellWidth = size.width / 4;
        final cellHeight = size.height / 4;

        return Stack(
          children: List.generate(state.shardPositions.length, (i) {
            final gridIndex = state.shardPositions[i];
            final col = gridIndex % 4;
            final row = gridIndex ~/ 4;

            // Add organic jitter based on index
            final jitterX = (math.sin(i * 1.5) * 15);
            final jitterY = (math.cos(i * 1.5) * 15);

            return Positioned(
              left: col * cellWidth + (cellWidth - 80) / 2 + jitterX,
              top: row * cellHeight + (cellHeight - 80) / 2 + jitterY,
              child: ShardWidget(
                key: ValueKey('shard_$i'),
                isActive: state.activeShardIndex == i,
                isNoise: state.noiseShardIndex == i,
                noiseScale: state.noiseScale,
                trackId: state.trackId,
                isHexagon: i % 2 == 0, // Alternate shapes for visual variety
                onTap: () => ref.read(spatialSpanProvider.notifier).handleShardTap(i),
              ),
            );
          }),
        );
      },
    );
  }
}
