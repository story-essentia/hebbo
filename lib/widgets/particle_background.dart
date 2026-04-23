import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = List.generate(40, (_) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.update();
        }
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(particles: _particles),
        );
      },
    );
  }
}

class Particle {
  double x = 0;
  double y = 0;
  double vx = 0;
  double vy = 0;
  double size = 0;
  double opacity = 0;
  final Random _rnd = Random();

  Particle() {
    _reset();
    // Randomize initial positions
    x = _rnd.nextDouble();
    y = _rnd.nextDouble();
  }

  void _reset() {
    x = _rnd.nextDouble();
    y = 1.1; // Start below screen or random elsewhere based on vy
    vx = (_rnd.nextDouble() - 0.5) * 0.001;
    vy = -(_rnd.nextDouble() * 0.002 + 0.0005);
    size = _rnd.nextDouble() * 3 + 1;
    opacity = _rnd.nextDouble() * 0.4 + 0.1;
  }

  void update() {
    x += vx;
    y += vy;
    if (y < -0.1 || x < -0.1 || x > 1.1) {
      _reset();
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      final color = p.x > 0.5 ? AppColors.neonPink : AppColors.neonBlue;
      paint.color = color.withValues(alpha: p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
