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
      
      final opacity = node.isUnlocked ? 1.0 : 0.2;

      // Node core
      final nodePaint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(node.position, node.radius, nodePaint);

      // Node glow
      if (node.isUnlocked) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15);
        canvas.drawCircle(node.position, node.radius, glowPaint);
      }

      // Text
      final textSpan = TextSpan(
        text: '${node.span}',
        style: AppTextStyles.plusJakarta(
          color: node.isUnlocked
              ? AppColors.background
              : AppColors.textPrimary.withOpacity(0.3),
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

      final paint = Paint()
        ..color = baseColor.withOpacity(
          current.isUnlocked && next.isUnlocked ? 0.6 : 0.1,
        )
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(current.position, next.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressionMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes;
  }
}
