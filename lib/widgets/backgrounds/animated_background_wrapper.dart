import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hebbo/widgets/backgrounds/environment_orchestrator.dart';

/// Wraps an environment background and provides the animation heartbeat.
class AnimatedBackgroundWrapper extends StatefulWidget {
  final Widget child;
  final bool isResetting;
  final bool isPaused;

  const AnimatedBackgroundWrapper({
    super.key,
    required this.child,
    required this.isResetting,
    required this.isPaused,
  });

  @override
  State<AnimatedBackgroundWrapper> createState() => _AnimatedBackgroundWrapperState();
}

class _AnimatedBackgroundWrapperState extends State<AnimatedBackgroundWrapper>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final EnvironmentOrchestrator _orchestrator;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _orchestrator = EnvironmentOrchestrator();
    _ticker = createTicker(_onTick);
    if (!widget.isPaused) _ticker.start();
  }

  @override
  void didUpdateWidget(AnimatedBackgroundWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _ticker.stop();
        _lastElapsed = Duration.zero;
      } else {
        _ticker.start();
      }
    }
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    
    final double deltaTime = (elapsed.inMicroseconds - _lastElapsed.inMicroseconds) / 
                            Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;

    _orchestrator.setResetting(widget.isResetting);
    _orchestrator.tick(deltaTime);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _orchestrator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _orchestrator,
      builder: (context, _) {
        return EnvironmentOrchestratorProvider(
          orchestrator: _orchestrator,
          // We must not use const here or ensures the InheritedWidget triggers rebuilds
          child: widget.child,
        );
      },
    );
  }
}

/// InheritedWidget to provide the orchestrator to child painters.
class EnvironmentOrchestratorProvider extends InheritedWidget {
  final EnvironmentOrchestrator orchestrator;

  const EnvironmentOrchestratorProvider({
    super.key,
    required this.orchestrator,
    required super.child,
  });

  static EnvironmentOrchestrator of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType registers the consumer for rebuilds
    return context.dependOnInheritedWidgetOfExactType<EnvironmentOrchestratorProvider>()!.orchestrator;
  }

  @override
  bool updateShouldNotify(EnvironmentOrchestratorProvider oldWidget) {
    // ALWAYS notify so children rebuild on every tick
    return true;
  }
}
