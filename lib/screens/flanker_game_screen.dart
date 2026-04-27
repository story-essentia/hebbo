import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/screens/session_end_placeholder.dart';
import 'package:hebbo/providers/adaptive_engine_provider.dart';
import 'package:hebbo/widgets/fish_row_widget.dart';
import 'package:hebbo/widgets/backgrounds/environment_factory.dart';
import 'package:hebbo/widgets/backgrounds/animated_background_wrapper.dart';
import 'package:hebbo/widgets/backgrounds/environment_transitioner.dart';
import 'package:hebbo/providers/notification_provider.dart';
import 'package:hebbo/providers/audio_provider.dart';
import 'package:hebbo/widgets/game_countdown_overlay.dart';

class FlankerGameScreen extends ConsumerStatefulWidget {
  const FlankerGameScreen({super.key});

  @override
  ConsumerState<FlankerGameScreen> createState() => _FlankerGameScreenState();
}

class _FlankerGameScreenState extends ConsumerState<FlankerGameScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Invalidate providers to ensure a fresh session state
      ref.invalidate(flankerGameProvider);
      
      final notifier = ref.read(adaptiveEngineProvider.notifier);
      await notifier.load('flanker');
      final startLevel = ref.read(adaptiveEngineProvider).currentLevel;
      ref.read(flankerGameProvider.notifier).startSession(startLevel);
      ref.read(gameAudioProvider).startSessionAmbience();
    });
  }

  @override
  void dispose() {
    // Only stop session audio if we haven't reached the completion screen.
    // If session is complete, SessionEndPlaceholder will handle the stop signal.
    if (!ref.read(flankerGameProvider).isSessionComplete) {
      ref.read(gameAudioProvider).stopSessionAudio();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flankerGameProvider);
    final level = ref.watch(adaptiveEngineProvider).currentLevel;

    ref.listen(flankerGameProvider.select((s) => s.isSessionComplete),
        (previous, next) {
      if (next) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SessionEndPlaceholder(gameId: 'flanker')),
        );
      }
    });

    // Handle Ambience Pause/Resume
    ref.listen(flankerGameProvider.select((s) => s.isPaused), (previous, next) {
      if (next) {
        ref.read(gameAudioProvider).pauseAmbience();
      } else if (previous == true && next == false) {
        ref.read(gameAudioProvider).resumeAmbience();
      }
    });

    // Handle Level Up SFX
    ref.listen(adaptiveEngineProvider.select((s) => s.currentLevel),
        (previous, next) {
      if (previous != null && next > previous && state.trialsRemaining < 60) {
        ref.read(gameAudioProvider).playLevelUp();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Environment Background
          AnimatedBackgroundWrapper(
            isResetting: state.isResetting,
            isPaused: state.isPaused,
            child: EnvironmentTransitioner(level: level),
          ),

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

          // Premium Progress Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 20,
            right: 20,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: ((75 - state.trialsRemaining) / 75).clamp(0.01, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00F0FF),
                              Color(0xFFFF8AA7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8AA7).withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pause Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 32,
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
                            style: AppTextStyles.plusJakarta(
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
                              ref.read(gameAudioProvider).stopSessionAudio();
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

          // Countdown Overlay
          GameCountdownOverlay(
            countdownValue: state.countdownValue,
            isVisible: state.isCountingDown,
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
        style: AppTextStyles.plusJakarta(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
