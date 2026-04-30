import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class ShardPainter extends CustomPainter {
  final double pulseScale; // 1.0 to 1.2
  final double ringRadius; // 0.0 to 1.0 (relative to shard size)
  final double ringOpacity;
  final bool isHexagon; // true for hexagon, false for pentagon
  final bool isActive;
  final bool isNoise;

  ShardPainter({
    required this.pulseScale,
    required this.ringRadius,
    required this.ringOpacity,
    this.isHexagon = true,
    this.isActive = false,
    this.isNoise = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) / 2.5;
    final currentRadius = baseRadius * pulseScale;

    // Colors based on the screenshot
    final highlightColor = isNoise ? AppColors.neonPink : AppColors.neonBlue;
    final mainColor = isActive || isNoise
        ? highlightColor
        : const Color(0xFF8A30FF); // Purple jewel
    final glowColor = isActive || isNoise
        ? highlightColor
        : mainColor.withOpacity(0.4);

    // 1. Draw the Outer Glow (Stronger & more layered)
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(isActive || isNoise ? 0.6 : 0.3)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.outer,
        isActive || isNoise ? 30 : 15,
      );

    _drawPolygon(canvas, center, currentRadius, glowPaint);

    // 2. Face Bevel (Inner shadow)
    final innerRadius = currentRadius * 0.75;

    // Draw the Bevel area (Sides)
    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          mainColor.withOpacity(isActive || isNoise ? 0.9 : 0.6),
          mainColor.withOpacity(isActive || isNoise ? 0.5 : 0.2),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    _drawPolygon(canvas, center, currentRadius, sidePaint);

    // 3. Draw Facet Lines
    final facetPaint = Paint()
      ..color = Colors.white.withOpacity(isActive || isNoise ? 0.4 : 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _drawFacetLines(canvas, center, currentRadius, innerRadius, facetPaint);

    // 4. Draw the Top Face
    final topFacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isActive || isNoise
              ? Colors.white.withOpacity(0.9)
              : mainColor.withOpacity(0.8),
          isActive || isNoise ? highlightColor : mainColor.withOpacity(0.3),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

    _drawPolygon(canvas, center, innerRadius, topFacePaint);

    // 5. Draw the Pulse Ring
    if (ringOpacity > 0) {
      final ringPaint = Paint()
        ..color = AppColors.neonBlue.withOpacity(ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final expandedRingRadius = currentRadius * (1.2 + ringRadius * 0.8);
      _drawPolygon(canvas, center, expandedRingRadius, ringPaint);
    }
  }

  void _drawPolygon(Canvas canvas, Offset center, double radius, Paint paint) {
    final sides = isHexagon ? 6 : 5;
    final path = _getPolygonPath(center, radius, sides);
    canvas.drawPath(path, paint);
  }

  void _drawFacetLines(
    Canvas canvas,
    Offset center,
    double outerR,
    double innerR,
    Paint paint,
  ) {
    final sides = isHexagon ? 6 : 5;
    final angle = (math.pi * 2) / sides;
    final startAngle = isHexagon ? 0.0 : -math.pi / 2;

    for (int i = 0; i < sides; i++) {
      final p1 = Offset(
        center.dx + outerR * math.cos(startAngle + angle * i),
        center.dy + outerR * math.sin(startAngle + angle * i),
      );
      final p2 = Offset(
        center.dx + innerR * math.cos(startAngle + angle * i),
        center.dy + innerR * math.sin(startAngle + angle * i),
      );
      canvas.drawLine(p1, p2, paint);
    }
  }

  Path _getPolygonPath(Offset center, double radius, int sides) {
    final path = Path();
    final angle = (math.pi * 2) / sides;
    final startAngle = isHexagon ? 0.0 : -math.pi / 2;

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(startAngle + angle * i);
      final y = center.dy + radius * math.sin(startAngle + angle * i);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ShardPainter oldDelegate) {
    return oldDelegate.pulseScale != pulseScale ||
        oldDelegate.ringRadius != ringRadius ||
        oldDelegate.ringOpacity != ringOpacity ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isNoise != isNoise;
  }
}
