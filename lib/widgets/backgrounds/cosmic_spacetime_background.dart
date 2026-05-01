import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class CosmicSpacetimeBackground extends StatelessWidget {
  const CosmicSpacetimeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: CustomPaint(
        size: Size.infinite,
        painter: _CosmicPainter(),
      ),
    );
  }
}

class _CosmicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.4);
    
    // Removed Star Trails (Concentric Rings) to clean up the center screen artifact

    // 2. Draw Subtle Star Noise
    final starPaint = Paint()..color = Colors.white.withOpacity(0.2);
    final random = math.Random(42);
    for (int i = 0; i < 50; i++) {
        final offset = Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
        );
        canvas.drawCircle(offset, random.nextDouble() * 1.5, starPaint);
    }

    // 3. Draw Neon Floor (Horizontal lines with perspective)
    final floorY = size.height * 0.85;
    final floorPaint = Paint()..strokeWidth = 1.0;

    for (int i = 0; i < 15; i++) {
      final y = floorY + (i * i * 0.5);
      if (y > size.height) break;
      
      final opacity = (1.0 - (i / 15)).clamp(0.0, 1.0) * 0.3;
      floorPaint.color = AppColors.neonBlue.withOpacity(opacity);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), floorPaint);
    }

    // Vertical perspective lines for the floor
    for (int i = -5; i <= 15; i++) {
        final xStart = size.width / 2 + (i - 5) * 40;
        final xEnd = size.width / 2 + (i - 5) * 200;
        
        floorPaint.color = AppColors.neonBlue.withOpacity(0.1);
        canvas.drawLine(Offset(xStart, floorY), Offset(xEnd, size.height), floorPaint);
    }
    
    // Floor Glow
    final glowRect = Rect.fromLTRB(0, floorY, size.width, size.height);
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.neonBlue.withOpacity(0.2),
          AppColors.neonBlue.withOpacity(0.0),
        ],
      ).createShader(glowRect);
    canvas.drawRect(glowRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
