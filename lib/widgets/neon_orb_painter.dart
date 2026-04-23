import 'dart:math';
import 'package:flutter/material.dart';

class NeonOrbPainter extends CustomPainter {
  final double pulse;
  final Color glowColor;
  final bool isWrong;
  final double shakeOffset;

  NeonOrbPainter({
    required this.pulse,
    required this.glowColor,
    this.isWrong = false,
    this.shakeOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + shakeOffset, size.height / 2);
    final radius = (size.width / 2.5) * (1 + pulse * 0.05);

    // 1. Inner soft glow
    final innerGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius * 1.2, innerGlowPaint);

    // 2. Main border
    final borderPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);

    // 3. Outer sharp glow
    final outerGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, radius, outerGlowPaint);

    // 4. White core border for "neon" look
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, corePaint);

    if (isWrong) {
      // Add a red tint over the center if wrong
      final errorPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawCircle(center, radius * 0.8, errorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NeonOrbPainter oldDelegate) {
    return oldDelegate.pulse != pulse || 
           oldDelegate.glowColor != glowColor || 
           oldDelegate.shakeOffset != shakeOffset;
  }
}
