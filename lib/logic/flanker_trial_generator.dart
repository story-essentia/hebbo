import 'dart:math';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/state/flanker_session_state.dart';

class FlankerTrialGenerator {
  final Random _random;

  FlankerTrialGenerator({Random? random}) : _random = random ?? Random();

  /// Map level (1-10) to the incongruent ratio (30% to 70%).
  double getIncongruentRatio(int level) {
    if (level < 1) return 0.3;
    if (level >= 10) return 0.7;
    // Linear progression from 0.3 at level 1 to 0.7 at level 9/10
    return 0.3 + (level - 1) * 0.05;
  }

  /// Generate a single stimulus based on current level.
  FlankerStimulus generateStimulus(int level) {
    final targetDirection = _random.nextBool() ? Side.left : Side.right;
    final incongruentThreshold = getIncongruentRatio(level);
    final isCongruent = _random.nextDouble() > incongruentThreshold;

    return FlankerStimulus(
      targetDirection: targetDirection,
      isCongruent: isCongruent,
    );
  }
}
