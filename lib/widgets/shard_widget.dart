import 'package:flutter/material.dart';
import 'package:hebbo/widgets/shard_painter.dart';

class ShardWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onTap;
  final bool isHexagon;
  final bool isNoise;
  final double noiseScale;

  const ShardWidget({
    super.key,
    this.isActive = false,
    this.onTap,
    this.isHexagon = true,
    this.isNoise = false,
    this.noiseScale = 1.0,
  });

  @override
  State<ShardWidget> createState() => ShardWidgetState();
}

class ShardWidgetState extends State<ShardWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _pulseScale;
  late Animation<double> _ringRadius;
  late Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
    );

    _ringRadius = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeOut));

    _ringOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.8), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 0.0), weight: 80),
    ]).animate(_ringController);
  }

  void pulse() {
    if (!mounted) return;
    _pulseController.forward().then((_) => _pulseController.reverse());
    _ringController.forward(from: 0.0);
  }

  void noisePulse() {
    if (!mounted) return;
    // Just pulse the scale, no ring
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  @override
  void didUpdateWidget(ShardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      pulse();
    }

    if (widget.isNoise && !oldWidget.isNoise) {
      noisePulse();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          pulse();
          widget.onTap?.call();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _ringController]),
          builder: (context, child) {
            return CustomPaint(
              size: const Size(80, 80),
              painter: ShardPainter(
                pulseScale: _pulseScale.value,
                ringRadius: _ringRadius.value,
                ringOpacity: _ringOpacity.value,
                isHexagon: widget.isHexagon,
                isActive: widget.isActive,
                isNoise: widget.isNoise,
              ),
            );
          },
        ),
      ),
    );
  }
}
