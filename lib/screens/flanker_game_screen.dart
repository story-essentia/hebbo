import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/screens/session_end_placeholder.dart';
import 'package:hebbo/widgets/fish_row_widget.dart';

class FlankerGameScreen extends ConsumerStatefulWidget {
  const FlankerGameScreen({super.key});

  @override
  ConsumerState<FlankerGameScreen> createState() => _FlankerGameScreenState();
}

class _FlankerGameScreenState extends ConsumerState<FlankerGameScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(flankerGameProvider.notifier).startSession(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flankerGameProvider);

    ref.listen(flankerGameProvider.select((s) => s.isSessionComplete),
        (previous, next) {
      if (next) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SessionEndPlaceholder()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stimuli Layout
          Center(
            child: Opacity(
              opacity: state.isPaused ? 0.3 : 1.0,
              child: FishRowWidget(state: state),
            ),
          ),

          // Tap Zones — behavior depends on game state
          if (!state.isPaused)
            Positioned.fill(
              child: state.isWaitingForContinue
                  ? GestureDetector(
                      onTapDown: (_) => ref
                          .read(flankerGameProvider.notifier)
                          .continueAfterTimeout(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(color: Colors.transparent),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => ref
                                .read(flankerGameProvider.notifier)
                                .reportResponse(Side.left),
                            behavior: HitTestBehavior.opaque,
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => ref
                                .read(flankerGameProvider.notifier)
                                .reportResponse(Side.right),
                            behavior: HitTestBehavior.opaque,
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
            ),

          // Progress Bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              color: const Color(0xFF301A4D),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    ((75 - state.trialsRemaining) / 74).clamp(0.0, 1.0),
                child: Container(
                  color: const Color(0xFFFF8AA7),
                ),
              ),
            ),
          ),

          // Pause Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              icon: Icon(
                state.isPaused ? Icons.play_arrow : Icons.pause,
                color: const Color(0xFFEFDFFF).withValues(alpha: 0.6),
                size: 28,
              ),
              onPressed: () =>
                  ref.read(flankerGameProvider.notifier).togglePause(),
            ),
          ),

          // Pause Overlay
          if (state.isPaused)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: const Color(0xFF150629).withValues(alpha: 0.7),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Paused',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFEFDFFF),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 48),
                          _buildOverlayButton(
                            label: 'Resume',
                            isPrimary: true,
                            onPressed: () => ref
                                .read(flankerGameProvider.notifier)
                                .togglePause(),
                          ),
                          const SizedBox(height: 16),
                          _buildOverlayButton(
                            label: 'Back to Menu',
                            isPrimary: false,
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? const Color(0xFFFF8AA7) : const Color(0xFF301A4D),
        foregroundColor:
            isPrimary ? const Color(0xFF150629) : const Color(0xFFEFDFFF),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
