import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/screens/flanker_game_screen.dart';
import 'package:hebbo/screens/progress_screen.dart';
import 'package:hebbo/providers/adaptive_engine_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/audio_provider.dart';

class SessionEndPlaceholder extends ConsumerStatefulWidget {
  const SessionEndPlaceholder({super.key});

  @override
  ConsumerState<SessionEndPlaceholder> createState() => _SessionEndPlaceholderState();
}

class _SessionEndPlaceholderState extends ConsumerState<SessionEndPlaceholder> {

  @override
  void dispose() {
    ref.read(gameAudioProvider).stopSessionAudio();
    super.dispose();
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF301A4D),
        title: Text(
          'Unsaved Data Detected',
          style: AppTextStyles.plusJakarta(
            color: const Color(0xFFEFDFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your session data could not be saved due to storage issues. Navigating away will discard this session permanently.',
          style: AppTextStyles.plusJakarta(color: const Color(0xFFEFDFFF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Stay',
              style: AppTextStyles.plusJakarta(
                color: const Color(0xFFFF8AA7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Discard & Exit',
              style: AppTextStyles.plusJakarta(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = ref.watch(adaptiveEngineProvider).currentLevel;
    final isPersisted = ref.watch(flankerGameProvider).isPersisted;

    return PopScope(
      canPop: isPersisted,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF150629),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Session Complete!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.plusJakarta(
                      color: const Color(0xFFEFDFFF),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level Reached: $currentLevel',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.plusJakarta(
                      color: const Color(0xFFFF8AA7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildButton(
                    context: context,
                    label: 'Play again',
                    isPrimary: true,
                    onPressed: () async {
                      if (!isPersisted) {
                        final shouldExit = await _showExitConfirmation(context);
                        if (!shouldExit) return;
                      }
                      
                      // Stop and start again for clean session restart
                      await ref.read(gameAudioProvider).stopSessionAudio();
                      
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FlankerGameScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    label: 'See progress',
                    isPrimary: false,
                    onPressed: () async {
                      if (!isPersisted) {
                        final shouldExit = await _showExitConfirmation(context);
                        if (!shouldExit) return;
                      }
                      
                      // Explicitly stop audio when navigating to progress
                      ref.read(gameAudioProvider).stopSessionAudio();
                      
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProgressScreen()),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    label: 'Back to menu',
                    isPrimary: false,
                    onPressed: () async {
                      if (!isPersisted) {
                        final shouldExit = await _showExitConfirmation(context);
                        if (!shouldExit) return;
                      }

                      // Explicitly stop audio when returning to menu
                      ref.read(gameAudioProvider).stopSessionAudio();

                      if (context.mounted) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
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

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFFFF8AA7)
            : const Color(0xFF301A4D),
        foregroundColor: isPrimary
            ? const Color(0xFF150629)
            : const Color(0xFFEFDFFF),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
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
