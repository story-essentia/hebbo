import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class GameCountdownOverlay extends StatelessWidget {
  final int countdownValue;
  final bool isVisible;

  const GameCountdownOverlay({
    super.key,
    required this.countdownValue,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || countdownValue <= 0) return const SizedBox.shrink();

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.4),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                '$countdownValue',
                key: ValueKey<int>(countdownValue),
                style: AppTextStyles.plusJakarta(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -4,
                ).copyWith(
                  shadows: [
                    Shadow(
                      color: AppColors.neonBlue.withValues(alpha: 0.8),
                      blurRadius: 20,
                    ),
                    Shadow(
                      color: AppColors.neonPink.withValues(alpha: 0.8),
                      blurRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
