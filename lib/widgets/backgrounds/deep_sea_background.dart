import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/animated_background_wrapper.dart';
import 'package:hebbo/widgets/backgrounds/simple_particles_painter.dart';

class DeepSeaBackground extends StatelessWidget {
  const DeepSeaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final orchestrator = EnvironmentOrchestratorProvider.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF010810), Color(0xFF000205)],
        ),
      ),
      child: Stack(
        children: [
          // Bio Glow Dots
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.2),
              color: const Color(0xFF00E8FF).withValues(alpha: 0.2),
              count: 6,
              radiusMin: 4.0,
              radiusMax: 8.0,
              isGlow: true,
            ),
            size: Size.infinite,
          ),
          // Sharp Bio Dots
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.7),
              color: const Color(0xFF88FFEE).withValues(alpha: 0.4),
              count: 10,
              radiusMin: 1.5,
              radiusMax: 3.0,
            ),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}
