import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class ConstellationNode {
  final int span;
  final int track;
  final bool isUnlocked;
  final Offset position;
  final double radius;

  ConstellationNode({
    required this.span,
    required this.track,
    required this.isUnlocked,
    required this.position,
    this.radius = 20.0,
  });
}

class ProgressionMapPainter extends CustomPainter {
  final List<ConstellationNode> nodes;

  ProgressionMapPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw connecting lines
    final linePaint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final track1Nodes = nodes.where((n) => n.track == 1).toList()
      ..sort((a, b) => a.span.compareTo(b.span));

    final track2Nodes = nodes.where((n) => n.track == 2).toList()
      ..sort((a, b) => a.span.compareTo(b.span));

    final track3Nodes = nodes.where((n) => n.track == 3).toList()
      ..sort((a, b) => a.span.compareTo(b.span));

    _drawLines(canvas, track1Nodes, AppColors.neonBlue);
    _drawLines(canvas, track2Nodes, AppColors.neonPink);
    _drawLines(canvas, track3Nodes, AppColors.neonLime);

    // 2. Draw nodes
    for (final node in nodes) {
      Color color;
      if (node.track == 1) {
          color = AppColors.neonBlue;
      } else if (node.track == 2) {
          color = AppColors.neonPink;
      } else {
          color = AppColors.neonLime;
      }
      
      final opacity = node.isUnlocked ? 1.0 : 0.05;

      if (node.isUnlocked) {
        // Outer glow
        final glowPaint = Paint()
          ..color = color.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(node.position, node.radius + 4, glowPaint);
        
        // Inner gradient for premium feel
        final Rect nodeRect = Rect.fromCircle(center: node.position, radius: node.radius);
        final Shader nodeShader = RadialGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          stops: const [0.5, 1.0],
        ).createShader(nodeRect);

        final nodePaint = Paint()
          ..shader = nodeShader
          ..style = PaintingStyle.fill;

        canvas.drawCircle(node.position, node.radius, nodePaint);
        
        // Crisp inner border
        final borderPaint = Paint()
          ..color = AppColors.background.withOpacity(0.3)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(node.position, node.radius - 2, borderPaint);
      } else {
        // Locked/dimmed state
        final nodePaint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(node.position, node.radius, nodePaint);
        
        final borderPaint = Paint()
          ..color = color.withOpacity(opacity * 2)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(node.position, node.radius, borderPaint);
      }

      // Text
      final textSpan = TextSpan(
        text: '${node.span}',
        style: AppTextStyles.plusJakarta(
          color: node.isUnlocked
              ? AppColors.background
              : AppColors.textPrimary.withOpacity(0.2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          node.position.dx - textPainter.width / 2,
          node.position.dy - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawLines(
    Canvas canvas,
    List<ConstellationNode> trackNodes,
    Color baseColor,
  ) {
    for (int i = 0; i < trackNodes.length - 1; i++) {
      final current = trackNodes[i];
      final next = trackNodes[i + 1];

      final bool isUnlocked = current.isUnlocked && next.isUnlocked;
      final opacity = isUnlocked ? 0.8 : 0.1;
      
      final Rect lineRect = Rect.fromPoints(current.position, next.position);
      final Shader lineShader = LinearGradient(
        colors: [
          baseColor.withOpacity(opacity),
          baseColor.withOpacity(opacity * 0.5),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(lineRect);

      final paint = Paint()
        ..shader = lineShader
        ..strokeWidth = isUnlocked ? 3.0 : 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Outer glow for premium look
      if (isUnlocked) {
        final glowPaint = Paint()
          ..color = baseColor.withOpacity(0.3)
          ..strokeWidth = 6.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
          ..style = PaintingStyle.stroke;
        canvas.drawLine(current.position, next.position, glowPaint);
      }

      canvas.drawLine(current.position, next.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressionMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes;
  }
}
