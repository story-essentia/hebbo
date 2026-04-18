import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/animated_background_wrapper.dart';
import 'package:hebbo/widgets/backgrounds/simple_particles_painter.dart';

class OpenOceanBackground extends StatelessWidget {
  const OpenOceanBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final orchestrator = EnvironmentOrchestratorProvider.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF04285A), Color(0xFF021438)],
        ),
      ),
      child: Stack(
        children: [
          // Deep Particles
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.15),
              color: Colors.white.withValues(alpha: 0.1),
              count: 10,
              radiusMin: 1.0,
              radiusMax: 2.0,
            ),
            size: Size.infinite,
          ),
          // Micro Particles
          CustomPaint(
            painter: SimpleParticlesPainter(
              scrollOffset: orchestrator.getOffsetForSpeed(0.6),
              color: Colors.white.withValues(alpha: 0.3),
              count: 20,
              radiusMin: 0.5,
              radiusMax: 1.2,
            ),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}
