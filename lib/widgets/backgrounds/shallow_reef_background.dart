import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/animated_background_wrapper.dart';
import 'package:hebbo/widgets/backgrounds/simple_particles_painter.dart';

class ShallowReefBackground extends StatelessWidget {
  const ShallowReefBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final orchestrator = EnvironmentOrchestratorProvider.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF007A8A), Color(0xFF004050)],
        ),
      ),
      child: Stack(
        children: [
          // Midground Bubbles
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.2),
              color: Colors.white.withValues(alpha: 0.1),
              count: 8,
              radiusMin: 3.0,
              radiusMax: 6.0,
            ),
            size: Size.infinite,
          ),
          // Foreground Fast Bubbles
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.5),
              color: Colors.white.withValues(alpha: 0.2),
              count: 12,
              radiusMin: 1.0,
              radiusMax: 2.5,
            ),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}
