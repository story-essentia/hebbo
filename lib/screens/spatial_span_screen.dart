import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/spatial_span_provider.dart';
import 'package:hebbo/state/spatial_span_state.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/providers/audio_provider.dart';
import 'package:hebbo/widgets/game_countdown_overlay.dart';
import 'package:hebbo/widgets/spatial_span_grid.dart';
import 'package:hebbo/widgets/backgrounds/animated_background_wrapper.dart';
import 'package:hebbo/widgets/backgrounds/environment_transitioner.dart';
import 'package:hebbo/widgets/backgrounds/cosmic_spacetime_background.dart';

class SpatialSpanScreen extends ConsumerStatefulWidget {
  const SpatialSpanScreen({super.key});

  @override
  ConsumerState<SpatialSpanScreen> createState() => _SpatialSpanScreenState();
}

class _SpatialSpanScreenState extends ConsumerState<SpatialSpanScreen> {
  @override
  void initState() {
    super.initState();
    // Removed startSession() call here so we don't overwrite the span/track
    // that was passed from NebulaMapScreen.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spatialSpanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const CosmicSpacetimeBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(state),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Opacity(
                      opacity: state.isPaused ? 0.3 : 1.0,
                      child: state.phase == GamePhase.complete
                          ? _buildCompletion(state)
                          : const SpatialSpanGrid(),
                    ),
                  ),
                ),
                _buildFooter(state),
              ],
            ),
          ),

          // Pause Overlay
          if (state.isPaused) _buildPauseOverlay(),

          // Countdown Overlay
          GameCountdownOverlay(
            countdownValue: state.countdownValue,
            isVisible: state.isCountingDown,
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: AppColors.background.withOpacity(0.7),
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
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildOverlayButton(
                    label: 'Resume',
                    isPrimary: true,
                    onPressed: () =>
                        ref.read(spatialSpanProvider.notifier).togglePause(),
                  ),
                  const SizedBox(height: 16),
                  _buildOverlayButton(
                    label: 'Back to Menu',
                    isPrimary: false,
                    onPressed: () {
                      ref.read(gameAudioProvider).stopSessionAudio();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
        foregroundColor: isPrimary
            ? AppColors.background
            : AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.plusJakarta(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHeader(SpatialSpanState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // Padding to balance the pause button
          Column(
            children: [
              Text(
                'SPAN ${state.span}',
                style: AppTextStyles.plusJakarta(
                  color: AppColors.neonBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'TRIAL ${state.trialsInLevel + 1}/3',
                style: AppTextStyles.plusJakarta(
                  color: AppColors.textPrimary.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              state.isPaused ? Icons.play_arrow : Icons.pause,
              color: AppColors.textPrimary.withOpacity(0.6),
              size: 28,
            ),
            onPressed: () =>
                ref.read(spatialSpanProvider.notifier).togglePause(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(SpatialSpanState state) {
    String message = '';
    Color color = AppColors.textPrimary;

    switch (state.phase) {
      case GamePhase.demonstration:
        message = 'WATCH SEQUENCE';
        color = AppColors.neonBlue;
        break;
      case GamePhase.recall:
        message = 'REPEAT SEQUENCE';
        color = AppColors.neonPink;
        break;
      case GamePhase.feedback:
        if (state.feedbackState == FeedbackType.success) {
          message = 'CORRECT';
          color = Colors.greenAccent;
        } else {
          message = 'INCORRECT';
          color = Colors.redAccent;
        }
        break;
      default:
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: AnimatedOpacity(
        opacity: message.isEmpty ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          message,
          style: AppTextStyles.plusJakarta(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletion(SpatialSpanState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary, size: 80),
          const SizedBox(height: 24),
          Text(
            'SESSION COMPLETE',
            style: AppTextStyles.plusJakarta(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MAX SPAN REACHED: ${state.span}',
            style: AppTextStyles.plusJakarta(
              color: AppColors.neonBlue,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'CONTINUE',
              style: AppTextStyles.plusJakarta(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
