import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hebbo/state/task_switch_state.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/widgets/neon_orb_painter.dart';

class NeonOrbWidget extends StatefulWidget {
  final int digit;
  final TaskRule rule;
  final FeedbackType feedback;

  const NeonOrbWidget({
    super.key,
    required this.digit,
    required this.rule,
    required this.feedback,
  });

  @override
  State<NeonOrbWidget> createState() => _NeonOrbWidgetState();
}

class _NeonOrbWidgetState extends State<NeonOrbWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _appearController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(NeonOrbWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.digit != oldWidget.digit) {
      _appearController.reset();
      _appearController.forward();
    }
    
    if (widget.feedback == FeedbackType.fail && oldWidget.feedback != FeedbackType.fail) {
      _shakeController.repeat(reverse: true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _shakeController.stop();
      });
    }

    if (widget.feedback == FeedbackType.success && oldWidget.feedback != FeedbackType.success) {
      _successController.forward(from: 0).then((_) {
        if (mounted) _successController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _appearController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.rule == TaskRule.parity ? AppColors.neonBlue : AppColors.neonPink;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _shakeController,
        _appearController,
        _successController,
      ]),
      builder: (context, child) {
        final shakeValue = widget.feedback == FeedbackType.fail 
            ? (sin(_shakeController.value * 2 * pi) * 10) 
            : 0.0;
        
        final scaleValue = _appearController.value + (_successController.value * 0.15);

        return Transform.scale(
          scale: scaleValue,
          child: CustomPaint(
            size: const Size(260, 260),
            painter: NeonOrbPainter(
              pulse: _pulseController.value + (_successController.value * 2.0),
              glowColor: borderColor,
              isWrong: widget.feedback == FeedbackType.fail,
              shakeOffset: shakeValue,
            ),
            child: Center(
              child: Text(
                widget.digit.toString(),
                style: AppTextStyles.plusJakarta(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -4,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
