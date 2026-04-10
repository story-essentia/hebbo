import 'package:flutter/material.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/state/flanker_session_state.dart';
import 'package:hebbo/widgets/animated_fish.dart';

class FishRowWidget extends StatelessWidget {
  final FlankerSessionState state;

  const FishRowWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final stimulus = state.currentStimulus;

    // Determine directions (default to left if no stimulus yet)
    final targetSide = stimulus?.targetDirection ?? Side.left;
    final flankerSide = stimulus != null
        ? (stimulus.isCongruent
            ? targetSide
            : (targetSide == Side.left ? Side.right : Side.left))
        : Side.left;

    Widget row = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFish(index: 0, side: flankerSide),
              _buildFish(index: 1, side: flankerSide),
              _buildFish(index: 2, side: targetSide, isCenter: true),
              _buildFish(index: 3, side: flankerSide),
              _buildFish(index: 4, side: flankerSide),
            ],
          ),
        ),
      ),
    );

    // When waiting for continue after timeout, dim the entire row to 80%
    if (state.isWaitingForContinue) {
      row = Opacity(opacity: 0.8, child: row);
    }

    return row;
  }

  Widget _buildFish({
    required int index,
    required Side side,
    bool isCenter = false,
  }) {
    FishState fishState;

    // Pre-trial or resetting → all fish in top-down view
    if (state.isPreTrial || state.isResetting) {
      fishState = FishState.topDown;
    }
    // Timeout hold → fish stay in their current side orientation, just dimmed via Opacity
    else if (state.isWaitingForContinue) {
      fishState = side == Side.left ? FishState.swimLeftNeutral : FishState.swimRightNeutral;
    }
    // No stimulus active and no feedback → top-down (idle)
    else if (!state.isStimulusActive && state.feedbackState == FeedbackType.none) {
      fishState = FishState.topDown;
    }
    // Center fish gets feedback coloring
    else if (isCenter) {
      if (state.feedbackState == FeedbackType.success) {
        fishState = side == Side.left ? FishState.swimLeftCorrect : FishState.swimRightCorrect;
      } else if (state.feedbackState == FeedbackType.fail) {
        fishState = side == Side.left ? FishState.swimLeftWrong : FishState.swimRightWrong;
      } else {
        fishState = side == Side.left ? FishState.swimLeftNeutral : FishState.swimRightNeutral;
      }
    }
    // Flankers remain neutral during active trial
    else {
      fishState = side == Side.left ? FishState.swimLeftNeutral : FishState.swimRightNeutral;
    }

    return SizedBox(
      width: isCenter ? 280 : 240,
      height: isCenter ? 280 : 240,
      child: AnimatedFish(
        key: ValueKey('fish_$index'),
        currentState: fishState,
        resetDurationMs: state.resetDurationMs,
      ),
    );
  }
}
