// =============================================================================
// animated_fish.dart
//
// State-driven animated fish — Flutter CustomPainter port of the HTML/CSS/JS
// version.  Drop this file into your project and import it wherever needed.
//
// pubspec.yaml dependency (add under `dependencies:`):
//   path_drawing: ^1.1.1
//
// Usage:
//   AnimatedFish(currentState: FishState.swimLeftCorrect)
//
// Passing a new `currentState` smoothly transitions colours and glow; no need
// to recreate the widget via a ValueKey.
// =============================================================================

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_drawing/path_drawing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1.  ENUM – animation / visual states
// ─────────────────────────────────────────────────────────────────────────────

enum FishState {
  /// Blue fish, swimming left, no glow or ripples.
  swimLeftNeutral,
  swimRightNeutral,

  /// Green fish + green outer-glow + expanding ripple rings.
  swimLeftCorrect,
  swimRightCorrect,

  /// Red/coral fish + red outer-glow  + expanding ripple rings.
  swimLeftWrong,
  swimRightWrong,

  /// Grey/semi-transparent fish, no animation.
  timeoutNeutral,

  /// Top-down aerial view — fish swimming upward.
  topDown,
}

// ─────────────────────────────────────────────────────────────────────────────
// 2.  BUBBLE DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _Bubble {
  final double x0;
  final double y0;
  final double radius;
  final double driftX;
  double t;

  _Bubble({
    required this.x0,
    required this.y0,
    required this.radius,
    required this.driftX,
  }) : t = 0;
}

class _Streak {
  final double x0;
  final double y0;
  final double length;
  final double speed;
  double t;

  _Streak({
    required this.x0,
    required this.y0,
    required this.length,
    required this.speed,
  }) : t = 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3.  STATEFUL WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class AnimatedFish extends StatefulWidget {
  final FishState currentState;
  final int resetDurationMs;

  const AnimatedFish({
    super.key,
    required this.currentState,
    this.resetDurationMs = 500,
  });

  @override
  State<AnimatedFish> createState() => _AnimatedFishState();
}

class _AnimatedFishState extends State<AnimatedFish>
    with TickerProviderStateMixin {
  /// Tracks the last side-view direction so the rotation transition
  /// knows which way to turn even after state changes to topDown.
  bool _lastFacingRight = false;

  // ── Side-view animation controllers ────────────────────────────────────────

  late final AnimationController _tailCtrl;
  late final Animation<double> _tailAngle;

  late final AnimationController _bodyCtrl;
  late final Animation<double> _bodyAngle;

  late final AnimationController _rippleCtrl;

  late final AnimationController _glowCtrl;
  late final Animation<double> _glowValue;

  // ── View transition controller (0 = side view, 1 = top-down view) ─────────

  late final AnimationController _viewCtrl;
  late final Animation<double> _viewValue;

  // ── Reset dash controller (0 -> 1 -> 0 vertical movement) ─────────────────

  late final AnimationController _dashCtrl;
  late final Animation<double> _dashValue;

  // ── Top-down wiggle controller ─────────────────────────────────────────────

  late final AnimationController _topDownWiggleCtrl;

  // ── Shake controller for wrong feedback ────────────────────────────────────

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeValue;

  // ── Particles / Currents ───────────────────────────────────────────────────

  final _rng = math.Random();
  final _bubbles = <_Bubble>[];
  final _streaks = <_Streak>[];

  late final Ticker _ticker;
  Duration _prevElapsed = Duration.zero;
  Duration _sinceSpawn = Duration.zero;
  Duration _sinceStreak = Duration.zero;

  static const _spawnInterval = Duration(milliseconds: 600);
  static const _streakInterval = Duration(milliseconds: 100);
  static const _lifetimeMs = 3000;
  static const _streakLifetimeMs = 600;

  // ────────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _tailCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);

    _tailAngle = Tween<double>(
      begin: -12 * math.pi / 180,
      end: 12 * math.pi / 180,
    ).animate(CurvedAnimation(parent: _tailCtrl, curve: Curves.easeInOut));

    _bodyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _bodyAngle = Tween<double>(
      begin: -2 * math.pi / 180,
      end: 2 * math.pi / 180,
    ).animate(CurvedAnimation(parent: _bodyCtrl, curve: Curves.easeInOut));

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _glowValue = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut);

    // View transition: 250ms fast morph between side and top-down
    _viewCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _viewValue = CurvedAnimation(parent: _viewCtrl, curve: Curves.easeInOut);

    // Reset dash: 800ms movement up and back (slower and smoother)
    _dashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _dashValue = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_dashCtrl);

    // Top-down body undulation: 600ms oscillating wiggle
    _topDownWiggleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Wrong feedback shake: 400ms rapid oscillation
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeValue = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 15.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 15.0, end: -15.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.linear));

    _ticker = createTicker(_onTick)..start();

    _updateGlow();
    _updateView();
  }

  // ── Frame callback ───────────────────────────────────────────────────────────

  void _onTick(Duration elapsed) {
    if (!mounted) return;

    final dt = elapsed - _prevElapsed;
    _prevElapsed = elapsed;
    _sinceSpawn += dt;
    _sinceStreak += dt;

    final dtFraction = dt.inMilliseconds / _lifetimeMs;
    for (final b in _bubbles) {
      b.t = (b.t + dtFraction).clamp(0.0, 1.0);
    }
    _bubbles.removeWhere((b) => b.t >= 1.0);

    final streakDtFraction = dt.inMilliseconds / _streakLifetimeMs;
    for (final s in _streaks) {
      s.t = (s.t + streakDtFraction).clamp(0.0, 1.0);
    }
    _streaks.removeWhere((s) => s.t >= 1.0);

    final isNeutral =
        widget.currentState == FishState.swimLeftNeutral ||
        widget.currentState == FishState.swimRightNeutral;

    final isTopDown = widget.currentState == FishState.topDown;

    if (_sinceSpawn >= _spawnInterval && isNeutral) {
      _sinceSpawn = Duration.zero;
      _bubbles.add(
        _Bubble(
          x0: 28 + _rng.nextDouble() * 14,
          y0: 112,
          radius: 2.5 + _rng.nextDouble() * 5.0,
          driftX: _rng.nextDouble() * 40 - 20,
        ),
      );
    }

    if (_sinceStreak >= _streakInterval && isTopDown) {
      _sinceStreak = Duration.zero;
      _streaks.add(
        _Streak(
          x0: 80 + _rng.nextDouble() * 40,
          y0: 160 + _rng.nextDouble() * 30, // behind tail
          length: 20 + _rng.nextDouble() * 30,
          speed: 150 + _rng.nextDouble() * 100,
        ),
      );
    }

    setState(() {});
  }

  // ── State change ─────────────────────────────────────────────────────────────

  @override
  void didUpdateWidget(AnimatedFish old) {
    super.didUpdateWidget(old);
    if (old.currentState != widget.currentState) {
      // Remember the last side-view direction before transitioning to top-down
      if (old.currentState != FishState.topDown) {
        _lastFacingRight =
            old.currentState == FishState.swimRightNeutral ||
            old.currentState == FishState.swimRightCorrect ||
            old.currentState == FishState.swimRightWrong;

        // Trigger dash if we are moving to top-down
        if (widget.currentState == FishState.topDown) {
          _dashCtrl.duration = Duration(milliseconds: widget.resetDurationMs);
          _dashCtrl.forward(from: 0);
        }
      }
      _updateGlow();
      _updateView();

      // Trigger shake on wrong response
      if (widget.currentState == FishState.swimLeftWrong || 
          widget.currentState == FishState.swimRightWrong) {
        _shakeCtrl.forward(from: 0);
      }
    }
  }

  void _updateGlow() {
    final isNeutral =
        widget.currentState == FishState.swimLeftNeutral ||
        widget.currentState == FishState.swimRightNeutral ||
        widget.currentState == FishState.timeoutNeutral ||
        widget.currentState == FishState.topDown;

    if (isNeutral) {
      _glowCtrl.reverse();
    } else {
      _glowCtrl.forward();
    }
  }

  void _updateView() {
    if (widget.currentState == FishState.topDown) {
      _viewCtrl.forward();
    } else {
      _viewCtrl.reverse();
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _tailCtrl.dispose();
    _bodyCtrl.dispose();
    _rippleCtrl.dispose();
    _glowCtrl.dispose();
    _viewCtrl.dispose();
    _dashCtrl.dispose();
    _topDownWiggleCtrl.dispose();
    _ticker.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _tailCtrl,
        _bodyCtrl,
        _rippleCtrl,
        _glowCtrl,
        _viewCtrl,
        _dashCtrl,
        _topDownWiggleCtrl,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeValue.value, 0),
          child: CustomPaint(
            size: const Size(300, 300),
            painter: _FishPainter(
              state: widget.currentState,
              tailAngle: _tailAngle.value,
              bodyAngle: _bodyAngle.value,
              rippleProgress: _rippleCtrl.value,
              glowValue: _glowValue.value,
              bubbles: List.unmodifiable(_bubbles),
              streaks: List.unmodifiable(_streaks),
              viewTransition: _viewValue.value,
              dashValue: _dashValue.value,
              topDownWiggle: _topDownWiggleCtrl.value,
              lastFacingRight: _lastFacingRight,
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4.  CUSTOM PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _FishPainter extends CustomPainter {
  final FishState state;
  final double tailAngle;
  final double bodyAngle;
  final double rippleProgress;
  final double glowValue;
  final List<_Bubble> bubbles;
  final List<_Streak> streaks;
  final double viewTransition; // 0 = side, 1 = top-down
  final double dashValue; // vertical offset progress
  final double topDownWiggle; // 0..1 oscillation
  final bool lastFacingRight; // direction the fish was facing in side view

  _FishPainter({
    required this.state,
    required this.tailAngle,
    required this.bodyAngle,
    required this.rippleProgress,
    required this.glowValue,
    required this.bubbles,
    required this.streaks,
    required this.viewTransition,
    required this.dashValue,
    required this.topDownWiggle,
    required this.lastFacingRight,
  });

  // ── SVG viewBox is 200 × 200 ─────────────────────────────────────────────────

  static Path? _pBodyMain;
  static Path? _pBellyHighlight;
  static Path? _pDarkUnderbelly;
  static Path? _pLateralLine;
  static Path? _pMouth;
  static Path? _pBodyStripe;
  static Path? _pTopFin;
  static Path? _pBottomFin;
  static Path? _pTailFin;

  static void _initPaths() {
    if (_pBodyMain != null) return;

    _pBodyMain = parseSvgPathData(
      'M20 110 C20 60, 160 50, 160 105 C160 155, 40 165, 20 110',
    );
    _pBellyHighlight = parseSvgPathData(
      'M35 130 C60 160, 140 155, 155 115 C130 145, 60 150, 35 130',
    );
    _pDarkUnderbelly = parseSvgPathData(
      'M90 115 C110 115, 135 135, 125 145 C115 155, 95 140, 90 115',
    );
    _pLateralLine = parseSvgPathData('M85 110 C80 125, 80 140, 90 155');
    _pMouth = parseSvgPathData('M20 105 L35 112 L20 120');
    _pBodyStripe = parseSvgPathData('M100 105 H170');
    _pTopFin = parseSvgPathData('M80 60 C100 30, 130 50, 140 75 L100 80 Z');
    _pBottomFin = parseSvgPathData('M110 140 L140 160 L130 145 Z');
    _pTailFin = parseSvgPathData('M150 100 L190 70 L175 100 L190 130 Z');
  }

  // ── Palette helpers ──────────────────────────────────────────────────────────

  static const _colNeutralBody = Color(0xFF4fb3e8);
  static const _colCorrectBody = Color(0xFF32ff7e);
  static const _colWrongBody = Color(0xFFff6b6b);

  static const _colNeutralFin = Color(0xFF1e60ad);
  static const _colCorrectFin = Color(0xFF1b944d);
  static const _colWrongFin = Color(0xFFc0392b);

  static const _colCorrectGlow = Color(0xFF32ff7e);
  static const _colWrongGlow = Color(0xFFff6b6b);

  Color get _bodyColor {
    final target = _isCorrect
        ? _colCorrectBody
        : _isWrong
        ? _colWrongBody
        : _colNeutralBody;
    return Color.lerp(_colNeutralBody, target, glowValue)!;
  }

  Color get _finColor {
    final target = _isCorrect
        ? _colCorrectFin
        : _isWrong
        ? _colWrongFin
        : _colNeutralFin;
    return Color.lerp(_colNeutralFin, target, glowValue)!;
  }

  Color get _glowTint => _isCorrect
      ? _colCorrectGlow
      : _isWrong
      ? _colWrongGlow
      : Colors.transparent;

  bool get _isRight =>
      state == FishState.swimRightNeutral ||
      state == FishState.swimRightCorrect ||
      state == FishState.swimRightWrong;

  bool get _isCorrect =>
      state == FishState.swimLeftCorrect || state == FishState.swimRightCorrect;

  bool get _isWrong =>
      state == FishState.swimLeftWrong || state == FishState.swimRightWrong;

  bool get _isNeutral =>
      state == FishState.swimLeftNeutral || state == FishState.swimRightNeutral;

  // ── paint() ──────────────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    _initPaths();

    // Fully top-down
    if (viewTransition > 0.99) {
      _paintTopDown(canvas, size);
      return;
    }
    // Fully side-view
    if (viewTransition < 0.01) {
      _paintSideView(canvas, size);
      return;
    }

    // ── Direction-aware rotation morph ──────────────────────────────────
    // Left-facing fish (9 o'clock) rotates CW (+90°) to reach 12 o'clock.
    // Right-facing fish (3 o'clock) rotates CCW (-90°) to reach 12 o'clock.
    // We use lastFacingRight to know which direction during transition.

    final center = Offset(size.width / 2, size.height / 2);

    // Determine current side-facing, or fall back to lastFacingRight
    final facingRight = state == FishState.topDown ? lastFacingRight : _isRight;

    // Left-facing → CW (+π/2), Right-facing → CCW (-π/2)
    final rotAngle = facingRight
        ? -viewTransition *
              math.pi /
              2 // CCW to 12 o'clock
        : viewTransition * math.pi / 2; // CW to 12 o'clock

    // Side view: rotates and fades out over 0.0 → 0.65
    if (viewTransition < 0.65) {
      final sideAlpha = (1.0 - viewTransition / 0.65).clamp(0.0, 1.0);
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Color.fromRGBO(255, 255, 255, sideAlpha),
      );
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotAngle);
      canvas.translate(-center.dx, -center.dy);
      _paintSideView(canvas, size);
      canvas.restore();
    }

    // Top-down view: fades in over 0.35 → 1.0
    if (viewTransition > 0.35) {
      final tdAlpha = ((viewTransition - 0.35) / 0.65).clamp(0.0, 1.0);
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Color.fromRGBO(255, 255, 255, tdAlpha),
      );
      _paintTopDown(canvas, size);
      canvas.restore();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SIDE VIEW (original painting logic)
  // ═══════════════════════════════════════════════════════════════════════════

  void _paintSideView(Canvas canvas, Size size) {
    if (state == FishState.timeoutNeutral) {
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Color.fromRGBO(255, 255, 255, 0.4),
      );
    }

    canvas.scale(size.width / 200, size.height / 200);

    if (_isRight) {
      canvas.translate(200, 0);
      canvas.scale(-1, 1);
    }

    // 1. Ripple rings
    if (!_isNeutral && state != FishState.timeoutNeutral) _drawRipples(canvas);

    // 2. Bubbles
    _drawBubbles(canvas);

    // 3. Static fins
    _paintFill(canvas, _pTopFin!, _finColor);
    _paintFill(canvas, _pBottomFin!, _finColor);

    // 4. Tail fin — rotated
    canvas.save();
    _pivotRotate(canvas, tailAngle, const Offset(150, 100));
    _paintFill(canvas, _pTailFin!, _finColor);
    canvas.restore();

    // 5. Body group — wobble
    canvas.save();
    _pivotRotate(canvas, bodyAngle, const Offset(160, 100));

    // 5a. Glow
    if (glowValue > 0) {
      canvas.drawPath(
        _pBodyMain!,
        Paint()
          ..color = _glowTint.withValues(alpha: 0.65 * glowValue)
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, 20 * glowValue)
          ..style = PaintingStyle.fill,
      );
    }

    // 5b. Body fill
    _paintFill(canvas, _pBodyMain!, _bodyColor);

    // 5c. Belly highlight
    canvas.drawPath(
      _pBellyHighlight!,
      Paint()
        ..color = const Color(0xFFa0e1f5).withValues(alpha: 0.8)
        ..style = PaintingStyle.fill,
    );

    // 5d. Dark underbelly
    _paintFill(canvas, _pDarkUnderbelly!, const Color(0xFF1e60ad));

    // 5e. Lateral line
    canvas.drawPath(
      _pLateralLine!,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // 5f. Eye
    canvas.drawCircle(
      const Offset(60, 105),
      8,
      Paint()..color = const Color(0xFF2c3e50),
    );
    canvas.drawCircle(
      const Offset(57, 102),
      2.5,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );

    // 5g. Mouth
    canvas.drawPath(
      _pMouth!,
      Paint()
        ..color = const Color(0xFF1e60ad)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // 5h. Body stripe
    canvas.drawPath(
      _pBodyStripe!,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore(); // end body-wobble

    // 6. Fin glow overlay
    if (glowValue > 0) {
      final finGlow = Paint()
        ..color = _glowTint.withValues(alpha: 0.4 * glowValue)
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 12 * glowValue)
        ..style = PaintingStyle.fill;

      canvas.save();
      _pivotRotate(canvas, tailAngle, const Offset(150, 100));
      canvas.drawPath(_pTailFin!, finGlow);
      canvas.restore();

      canvas.drawPath(_pTopFin!, finGlow);
      canvas.drawPath(_pBottomFin!, finGlow);
    }

    if (state == FishState.timeoutNeutral) {
      canvas.restore();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TOP-DOWN VIEW — bird's-eye / aerial perspective
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //  The fish is drawn swimming UPWARD in a 200×200 viewBox.
  //  Features: symmetrical body, eyes, pectoral fins, dorsal ridge,
  //  small lip/mouth, and realistic undulation physics.
  //

  void _paintTopDown(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 200);

    // ── Dash movement ───────────────────────────────────────────────────────
    // dashValue (0..1..0) moves the fish up on the Y axis (nose direction).
    // A value of 1.0 translates it by -25 units (upwards).
    final yOffset = -25 * dashValue;
    canvas.translate(0, yOffset);

    // ── Tailwind Currents (Streaks) ─────────────────────────────────────────
    final streakPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (final s in streaks) {
      final t = s.t.clamp(0.0, 1.0);
      // Currents flow DOWN (away from fish)
      final startY = s.y0 + s.speed * t;
      final endY = startY + s.length * (1.0 - t);
      final op = ((1.0 - t) * 0.4).clamp(0.0, 0.4);

      canvas.drawLine(
        Offset(s.x0, startY),
        Offset(s.x0, endY),
        streakPaint..color = Colors.white.withValues(alpha: op),
      );
    }

    // ── Undulation physics ──────────────────────────────────────────────────
    // The wiggle value (0..1) drives a sinusoidal body wave.
    // We apply a slight rotation and horizontal skew to simulate
    // the S-curve of a real fish body moving through water.
    final wigglePhase = topDownWiggle * 2 * math.pi;
    final bodyRotation = math.sin(wigglePhase) * 3.0 * math.pi / 180; // ±3°
    final bodySkew = math.sin(wigglePhase) * 0.02; // subtle horizontal shear

    // Center of the fish body in viewBox coords
    const cx = 100.0;
    const cy = 100.0;

    // Apply the undulation transform around the fish center
    canvas.translate(cx, cy);
    canvas.rotate(bodyRotation);

    // Apply skew via a matrix transform for the S-curve effect
    final skewMat4 = Matrix4.identity();
    skewMat4.setEntry(0, 1, bodySkew); // shear X by Y
    final skewMatrix = Float64List(16);
    skewMat4.copyIntoArray(skewMatrix);
    canvas.transform(skewMatrix);

    canvas.translate(-cx, -cy);

    final bodyColor = _colNeutralBody;
    final finColor = _colNeutralFin;
    final darkColor = const Color(0xFF1e60ad);

    // ── 1. Tail fin (caudal) — V-shaped, behind the body ────────────────
    final tailWiggle = math.sin(wigglePhase + 0.5) * 8;
    final tailPath = Path()
      ..moveTo(100 + tailWiggle, 170)
      ..lineTo(80 + tailWiggle * 0.5, 200)
      ..quadraticBezierTo(100 + tailWiggle, 192, 120 + tailWiggle * 0.5, 200)
      ..close();
    _paintFill(canvas, tailPath, finColor);

    // Tail fin highlight
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── 2. Pectoral fins (symmetrical, swept-back) ──────────────────────
    final finWiggle = math.sin(wigglePhase + 1.0) * 5;

    // Left pectoral fin
    final leftFinPath = Path()
      ..moveTo(72, 105)
      ..quadraticBezierTo(45 + finWiggle, 120, 50 + finWiggle, 140)
      ..quadraticBezierTo(60, 130, 72, 115)
      ..close();
    _paintFill(canvas, leftFinPath, finColor.withValues(alpha: 0.85));

    // Right pectoral fin
    final rightFinPath = Path()
      ..moveTo(128, 105)
      ..quadraticBezierTo(155 - finWiggle, 120, 150 - finWiggle, 140)
      ..quadraticBezierTo(140, 130, 128, 115)
      ..close();
    _paintFill(canvas, rightFinPath, finColor.withValues(alpha: 0.85));

    // Fin edge highlights
    canvas.drawPath(
      leftFinPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    canvas.drawPath(
      rightFinPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── 3. Main body — elongated ellipse, head at top ───────────────────
    final bodyPath = Path()
      ..moveTo(100, 25) // nose tip
      ..cubicTo(130, 30, 135, 60, 132, 100) // right curve of body
      ..cubicTo(130, 140, 120, 165, 100, 170) // right tail taper
      ..cubicTo(80, 165, 70, 140, 68, 100) // left tail taper
      ..cubicTo(65, 60, 70, 30, 100, 25) // left curve back to nose
      ..close();
    _paintFill(canvas, bodyPath, bodyColor);

    // Body edge definition
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = darkColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── 4. Body shading — belly gradient overlay ────────────────────────
    // Lighter center strip simulating belly from above
    final bellyPath = Path()
      ..moveTo(100, 35)
      ..cubicTo(115, 40, 118, 70, 116, 100)
      ..cubicTo(115, 130, 110, 155, 100, 162)
      ..cubicTo(90, 155, 85, 130, 84, 100)
      ..cubicTo(82, 70, 85, 40, 100, 35)
      ..close();
    canvas.drawPath(
      bellyPath,
      Paint()
        ..color = const Color(0xFFa0e1f5).withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );

    // ── 5. Dorsal Fin — vertical blade along the center line ──────────────
    // To make it look "upward", we draw a narrow, sharp triangle/sliver
    final dorsalFinPath = Path()
      ..moveTo(100, 60) // Start from mid-upper body
      ..quadraticBezierTo(104, 90, 102, 145) // Back edge
      ..quadraticBezierTo(100, 148, 98, 145) // Tail end
      ..quadraticBezierTo(96, 90, 100, 60) // Front edge
      ..close();

    // Fill with a slightly lighter/more vibrant fin color to catch "light"
    _paintFill(canvas, dorsalFinPath, finColor.withValues(alpha: 0.9));

    // Blade edge line (the very top of the fin)
    final finEdge = Path()
      ..moveTo(100, 65)
      ..quadraticBezierTo(101, 100, 100, 142);
    canvas.drawPath(
      finEdge,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    // Subtle shadow on the base of the fin
    final finBaseShadow = Path()
      ..moveTo(97, 70)
      ..quadraticBezierTo(100, 100, 97, 140);
    canvas.drawPath(
      finBaseShadow,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // ── 6. Scale pattern — subtle horizontal arcs ───────────────────────
    for (double y = 50; y < 160; y += 18) {
      final scaleWidth = 15.0 * (1.0 - ((y - 100).abs() / 80)).clamp(0.3, 1.0);
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(100, y),
          width: scaleWidth * 2,
          height: 8,
        ),
        0,
        math.pi,
        false,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    // ── 7. Eyes — symmetrical, slightly forward ────────────────────────
    // Eye sockets (dark)
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(85, 48), width: 14, height: 12),
      Paint()..color = const Color(0xFF2c3e50),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(115, 48), width: 14, height: 12),
      Paint()..color = const Color(0xFF2c3e50),
    );

    // Iris (body-colored ring)
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(85, 47), width: 10, height: 8),
      Paint()..color = darkColor,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(115, 47), width: 10, height: 8),
      Paint()..color = darkColor,
    );

    // Specular highlights
    canvas.drawCircle(
      const Offset(83, 45),
      2.0,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      const Offset(113, 45),
      2.0,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // ── 8. Mouth — small curved lip at the nose tip ────────────────────
    final mouthPath = Path()
      ..moveTo(95, 28)
      ..quadraticBezierTo(100, 32, 105, 28);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = darkColor.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Lip highlight
    final lipHighlight = Path()
      ..moveTo(96, 26)
      ..quadraticBezierTo(100, 24, 104, 26);
    canvas.drawPath(
      lipHighlight,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // ── 9. Small bubble trail (behind/below the fish) ──────────────────
    for (final b in bubbles) {
      final t = b.t.clamp(0.0, 1.0);
      // Bubbles drift downward (away from fish heading up)
      final x = 100 + b.driftX * t * 0.3;
      final y = 170 + 50 * t;
      final op = ((1.0 - t) * 0.4).clamp(0.0, 0.4);

      canvas.drawCircle(
        Offset(x, y),
        b.radius * 0.7,
        Paint()
          ..color = Colors.white.withValues(alpha: op)
          ..style = PaintingStyle.fill,
      );
    }

    canvas.restore();
  }

  // ── Drawing helpers ──────────────────────────────────────────────────────────

  void _paintFill(Canvas canvas, Path path, Color color) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void _pivotRotate(Canvas canvas, double angle, Offset pivot) {
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(angle);
    canvas.translate(-pivot.dx, -pivot.dy);
  }

  // ── Ripple rings ─────────────────────────────────────────────────────────────

  void _drawRipples(Canvas canvas) {
    const maxRadius = 105.0;
    const center = Offset(90, 105);
    const delays = [0.0, 0.25, 0.5];

    for (final delay in delays) {
      double t = (rippleProgress - delay) % 1.0;
      if (t < 0) t += 1.0;

      final radius = maxRadius * Curves.easeOut.transform(t);
      final opacity = (1.0 - t) * 0.7 * glowValue;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = _glowTint.withValues(alpha: opacity.clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
      );
    }
  }

  // ── Rising bubbles ────────────────────────────────────────────────────────────

  void _drawBubbles(Canvas canvas) {
    for (final b in bubbles) {
      final t = b.t.clamp(0.0, 1.0);
      final x = b.x0 + b.driftX * t;
      final y = b.y0 - 220 * t;
      final op = ((1.0 - t) * 0.6).clamp(0.0, 0.6);

      canvas.drawCircle(
        Offset(x, y),
        b.radius,
        Paint()
          ..color = Colors.white.withValues(alpha: op)
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        Offset(x, y),
        b.radius,
        Paint()
          ..color = Colors.white.withValues(alpha: op * 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(_FishPainter old) => true;
}
