import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/base_parallax_painter.dart';

class SimpleParticlesPainter extends BaseParallaxPainter {
  final Color color;
  final int count;
  final double radiusMin;
  final double radiusMax;
  final List<Offset> _positions;
  final List<double> _radii;
  final bool isGlow;

  SimpleParticlesPainter({
    required super.scrollOffset,
    required this.color,
    required this.count,
    required this.radiusMin,
    required this.radiusMax,
    this.isGlow = false,
  })  : _positions = List.generate(count, (i) => Offset(
          math.Random(i + 143).nextDouble() * 2000, // Wide X range
          math.Random(i + 952).nextDouble() * 4000  // Large Y range to fill tall screens
        )),
        _radii = List.generate(count, (i) => radiusMin + 
          math.Random(i + 777).nextDouble() * (radiusMax - radiusMin));

  @override
  void drawContent(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    if (isGlow) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, radiusMax * 1.5);
    }

    for (int i = 0; i < _positions.length; i++) {
      // Map random positions to current screen size
      final double x = _positions[i].dx % size.width;
      final double y = _positions[i].dy % size.height;
      canvas.drawCircle(Offset(x, y), _radii[i], paint);
    }
  }
}
