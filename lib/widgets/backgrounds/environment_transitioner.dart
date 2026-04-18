import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/environment_factory.dart';

/// Handles smooth 4-second cross-fades between environments when the level changes.
class EnvironmentTransitioner extends StatefulWidget {
  final int level;

  const EnvironmentTransitioner({
    super.key,
    required this.level,
  });

  @override
  State<EnvironmentTransitioner> createState() => _EnvironmentTransitionerState();
}

class _EnvironmentTransitionerState extends State<EnvironmentTransitioner>
    with SingleTickerProviderStateMixin {
  late Widget _currentWidget;
  Widget? _previousWidget;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _currentWidget = EnvironmentFactory.getBackgroundForLevel(widget.level);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      value: 1.0,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(EnvironmentTransitioner oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final newWidget = EnvironmentFactory.getBackgroundForLevel(widget.level);
    
    // Check if the actual environment type changed (comparing runtimeType of the widgets)
    if (newWidget.runtimeType != _currentWidget.runtimeType) {
      setState(() {
        _previousWidget = _currentWidget;
        _currentWidget = newWidget;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // New environment fading in
        FadeTransition(
          opacity: _opacityAnimation,
          child: _currentWidget,
        ),
        // Previous environment fading out
        if (_previousWidget != null)
          FadeTransition(
            opacity: ReverseAnimation(_opacityAnimation),
            child: _previousWidget!,
          ),
      ],
    );
  }
}
