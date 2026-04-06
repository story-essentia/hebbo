import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/screens/session_end_placeholder.dart';
import 'package:hebbo/state/flanker_session_state.dart';

class FlankerGameScreen extends ConsumerStatefulWidget {
  const FlankerGameScreen({super.key});

  @override
  ConsumerState<FlankerGameScreen> createState() => _FlankerGameScreenState();
}

class _FlankerGameScreenState extends ConsumerState<FlankerGameScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize session at default Level 1 for US1 testing
    Future.microtask(() => ref.read(flankerGameProvider.notifier).startSession(1));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flankerGameProvider);

    ref.listen(flankerGameProvider.select((s) => s.isSessionComplete), (previous, next) {
      if (next) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SessionEndPlaceholder()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stimuli Layout
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFlanker(state, 0),
                _buildFlanker(state, 1),
                _buildTarget(state),
                _buildFlanker(state, 3),
                _buildFlanker(state, 4),
              ],
            ),
          ),

          // Tap Zones
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => ref.read(flankerGameProvider.notifier).reportResponse(Side.left),
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => ref.read(flankerGameProvider.notifier).reportResponse(Side.right),
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Trial Counter
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Trials Remaining: ${state.trialsRemaining}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlanker(FlankerSessionState state, int index) {
    if (!state.isStimulusActive && state.feedbackState == FeedbackType.none) {
      return _spacer();
    }

    final stimulus = state.currentStimulus;
    if (stimulus == null) return _spacer();

    // Direction matches target if congruent
    final direction = stimulus.isCongruent ? stimulus.targetDirection : (stimulus.targetDirection == Side.left ? Side.right : Side.left);

    return _stimulusBox(
      color: Colors.grey.shade800,
      child: Icon(
        direction == Side.left ? Icons.arrow_back : Icons.arrow_forward,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildTarget(FlankerSessionState state) {
    if (!state.isStimulusActive && state.feedbackState == FeedbackType.none) {
      return _spacer();
    }

    final stimulus = state.currentStimulus;
    if (stimulus == null) return _spacer();

    Color boxColor = Colors.grey.shade700;
    if (state.feedbackState == FeedbackType.success) boxColor = Colors.green;
    if (state.feedbackState == FeedbackType.fail) boxColor = Colors.red;

    return _stimulusBox(
      color: boxColor,
      child: Icon(
        stimulus.targetDirection == Side.left ? Icons.arrow_back : Icons.arrow_forward,
        color: Colors.white,
        size: 48,
        weight: 900,
      ),
    );
  }

  Widget _stimulusBox({required Color color, required Widget child}) {
    return Container(
      width: 60,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: child),
    );
  }

  Widget _spacer() => const SizedBox(width: 68);
}
