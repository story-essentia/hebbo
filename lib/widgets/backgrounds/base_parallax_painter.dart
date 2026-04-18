import 'package:flutter/material.dart';

/// Base class for parallax background layers.
/// Handles the infinite vertical wrapping logic (Top-to-Bottom).
abstract class BaseParallaxPainter extends CustomPainter {
  final double scrollOffset; // The current Y position (cumulative)

  BaseParallaxPainter({
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate effective Y position within the screen height
    final double y = scrollOffset % size.height;

    // Draw the layer twice to ensure seamless vertical wrapping
    canvas.save();
    canvas.translate(0, y);
    drawContent(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.translate(0, y - size.height);
    drawContent(canvas, size);
    canvas.restore();
  }

  /// Override this to draw the specific layer content (un-offset).
  void drawContent(Canvas canvas, Size size);

  @override
  bool shouldRepaint(covariant BaseParallaxPainter oldDelegate) =>
      oldDelegate.scrollOffset != scrollOffset;
}
