import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hebbo/logic/flanker_trial_generator.dart';
import 'package:hebbo/logic/flanker_domain.dart';

class MockRandom extends Mock implements Random {}

void main() {
  group('FlankerTrialGenerator', () {
    late FlankerTrialGenerator generator;
    late MockRandom mockRandom;

    setUp(() {
      mockRandom = MockRandom();
      generator = FlankerTrialGenerator(random: mockRandom);
    });

    test('Should map level to correct incongruent ratio', () {
      expect(generator.getIncongruentRatio(1), 0.3);
      expect(generator.getIncongruentRatio(5), 0.5);
      expect(generator.getIncongruentRatio(10), 0.7);
    });

    test('Should generate congruent stimulus when random is above threshold', () {
      when(() => mockRandom.nextBool()).thenReturn(true); // target side: left
      when(() => mockRandom.nextDouble()).thenReturn(0.4); // > 0.3 threshold (Level 1)
      
      final stimulus = generator.generateStimulus(1);
      expect(stimulus.targetDirection, Side.left);
      expect(stimulus.isCongruent, true);
    });

    test('Should generate incongruent stimulus when random is below threshold', () {
      when(() => mockRandom.nextBool()).thenReturn(false); // target side: right
      when(() => mockRandom.nextDouble()).thenReturn(0.2); // < 0.3 threshold (Level 1)

      final stimulus = generator.generateStimulus(1);
      expect(stimulus.targetDirection, Side.right);
      expect(stimulus.isCongruent, false);
    });
  });
}
