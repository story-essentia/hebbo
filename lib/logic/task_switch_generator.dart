import 'dart:math';
import 'package:hebbo/state/task_switch_state.dart';

class TaskSwitchTrialGenerator {
  final Random _random = Random();
  
  TaskRule? _lastRule;

  TaskSwitchStimulus generateStimulus(int level) {
    // Determine switch probability based on level
    // Level 1: 0.2, Level 10: 0.7
    final switchProb = 0.2 + ((level - 1) * (0.5 / 9));
    
    final bool isSwitch;
    if (_lastRule == null) {
      isSwitch = true; // First trial is always a switch in terms of metric tracking start
      _lastRule = _random.nextBool() ? TaskRule.parity : TaskRule.magnitude;
    } else {
      if (_random.nextDouble() < switchProb) {
        isSwitch = true;
        _lastRule = _lastRule == TaskRule.parity ? TaskRule.magnitude : TaskRule.parity;
      } else {
        isSwitch = false;
      }
    }

    // Digits {1, 2, 3, 4, 6, 7, 8, 9}
    const digits = [1, 2, 3, 4, 6, 7, 8, 9];
    final digit = digits[_random.nextInt(digits.length)];

    return TaskSwitchStimulus(
      digit: digit,
      rule: _lastRule!,
      isSwitch: isSwitch,
    );
  }

  void reset() {
    _lastRule = null;
  }
}
