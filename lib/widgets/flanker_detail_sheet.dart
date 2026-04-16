import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hebbo/providers/flanker_stats_provider.dart';
import 'package:hebbo/screens/flanker_game_screen.dart';
import 'package:hebbo/screens/progress_screen.dart';
import 'package:hebbo/widgets/stat_chip.dart';
import 'package:hebbo/widgets/stat_chip_skeleton.dart';

class FlankerDetailSheet extends ConsumerWidget {
  const FlankerDetailSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(flankerStatsProvider);

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
          
          // Title (Headline style)
          Text(
            'Flanker',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFEFDFFF),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats Section
          statsAsync.when(
            loading: () => const Row(
              children: [
                Expanded(child: StatChipSkeleton()),
                SizedBox(width: 12),
                Expanded(child: StatChipSkeleton()),
              ],
            ),
            error: (err, stack) => Text(
              'Error loading statistics',
              style: GoogleFonts.plusJakartaSans(color: Colors.red),
            ),
            data: (stats) {
              if (!stats.hasPlayedBefore) {
                return Text(
                  'First session — we\'ll find your level',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEFDFFF).withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: StatChip(
                      label: 'Personal Best',
                      value: '${stats.bestRtMs} ms',
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatChip(
                      label: 'Sessions',
                      value: '${stats.totalSessions}',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Science Summary
          Text(
            'Trains selective attention and inhibitory control — your ability to focus on what matters and ignore what doesn\'t.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFEFDFFF).withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Citation
          Text(
            'Based on Eriksen & Eriksen (1974)',
            style: GoogleFonts.plusJakartaSans(
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
                onTap: () {
                  // Immediate navigation as requested
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlankerGameScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Play',
                      style: GoogleFonts.plusJakartaSans(
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
          
          // Progress Link (Only shown for returning users & after data load)
          statsAsync.maybeWhen(
            data: (stats) => stats.hasPlayedBefore
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProgressScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'View your progress',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFFF8AA7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
