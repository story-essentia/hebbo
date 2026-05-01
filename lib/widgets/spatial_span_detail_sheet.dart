import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/providers/database_provider.dart';
import 'package:hebbo/providers/spatial_span_progress_provider.dart';
import 'package:hebbo/providers/spatial_span_provider.dart';
import 'package:hebbo/screens/spatial_span_screen.dart';
import 'package:hebbo/screens/progression_map_screen.dart';
import 'package:hebbo/widgets/spatial_span_tutorial_sheet.dart';
import 'package:hebbo/widgets/stat_chip.dart';
import 'package:hebbo/widgets/stat_chip_skeleton.dart';

class SpatialSpanDetailSheet extends ConsumerWidget {
  const SpatialSpanDetailSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(spatialSpanProgressProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF150629),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEFDFFF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spatial Span',
                style: AppTextStyles.plusJakarta(
                  color: const Color(0xFFEFDFFF),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => SpatialSpanTutorialSheet.show(context),
                icon: Icon(
                  Icons.help_outline,
                  color: const Color(0xFFEFDFFF).withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats Section
          Builder(builder: (context) {
              if (progressState.isInitialLoading) {
                  return const Row(
                      children: [
                        Expanded(child: StatChipSkeleton()),
                        SizedBox(width: 12),
                        Expanded(child: StatChipSkeleton()),
                      ],
                  );
              }
              final highestSpan = math.max(progressState.track1MaxSpan, math.max(progressState.track2MaxSpan, progressState.track3MaxSpan));
              if (highestSpan < 3) { // 2 is default unplayed
                  return Text(
                    'First session — we\'ll find your level',
                    style: AppTextStyles.plusJakarta(
                      color: const Color(0xFFEFDFFF).withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  );
              }
              return Row(
                children: [
                  Expanded(
                    child: StatChip(
                      label: 'Max Span',
                      value: '$highestSpan',
                      icon: Icons.memory,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatChip(
                      label: 'Unlocked',
                      value: '${progressState.track3MaxSpan >= 3 ? 3 : (progressState.track2MaxSpan >= 3 ? 2 : 1)}/3 Tracks',
                      icon: Icons.route,
                    ),
                  ),
                ],
              );
          }),
          
          const SizedBox(height: 24),
          
          // Science Summary
          Text(
            'Improve your ability to hold and manipulate spatial information. Watch the sequence of luminous shards and repeat it in the same order.',
            style: AppTextStyles.plusJakarta(
              color: const Color(0xFFEFDFFF).withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Citation
          Text(
            'Based on the Corsi Block-Tapping Task',
            style: AppTextStyles.plusJakarta(
              color: const Color(0xFFEFDFFF).withValues(alpha: 0.6),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          
          // Play Button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8AA7), Color(0xFFFF5C8D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8AA7).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final prefs = ref.read(sharedPreferencesProvider);
                  final hasSeenTutorial = prefs.getBool('has_seen_spatial_span_tutorial') ?? false;

                  if (!hasSeenTutorial) {
                    await prefs.setBool('has_seen_spatial_span_tutorial', true);
                    if (context.mounted) {
                      await SpatialSpanTutorialSheet.show(context);
                    }
                  }

                  // Determine last played track/span based on what they have unlocked
                  int trackIdToPlay = 1;
                  int spanToPlay = math.max(3, progressState.track1MaxSpan);

                  if (progressState.track3MaxSpan >= 3) {
                      trackIdToPlay = 3;
                      spanToPlay = progressState.track3MaxSpan;
                  } else if (progressState.track2MaxSpan >= 3) {
                      trackIdToPlay = 2;
                      spanToPlay = progressState.track2MaxSpan;
                  }

                  ref.read(spatialSpanProvider.notifier).startSession(trackId: trackIdToPlay, startingSpan: spanToPlay);

                  if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SpatialSpanScreen()),
                      );
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Play',
                      style: AppTextStyles.plusJakarta(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Progress Link
          Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgressionMapScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'View your progress',
                    style: AppTextStyles.plusJakarta(
                      color: const Color(0xFFFF8AA7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
