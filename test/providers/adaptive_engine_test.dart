import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hebbo/providers/adaptive_engine_provider.dart';
import 'package:hebbo/repositories/i_difficulty_repository.dart';

class MockDifficultyRepository extends Mock implements IDifficultyRepository {}

void main() {
  late MockDifficultyRepository mockRepo;
  late AdaptiveEngineNotifier notifier;

  setUp(() {
    mockRepo = MockDifficultyRepository();
    // Default mock behavior for initialization
    when(() => mockRepo.getDifficultyForGame(any())).thenAnswer((_) async => 1);
    when(() => mockRepo.upsertDifficulty(any(), any())).thenAnswer((_) async {});
    
    notifier = AdaptiveEngineNotifier(mockRepo);
  });

  group('AdaptiveEngineNotifier - Level Up Logic', () {
    test('Should increment level after 20 correct trials (80%+ accuracy) with fast RT', () async {
      await notifier.load('test_game');
      
      // Submit 20 correct trials with very fast RT (100ms) to ensure Level Up trigger
      // ISI for L1 is 1500ms, ISI for L2 is 1300ms. 100ms < 1300ms.
      for (int i = 0; i < 20; i++) {
        notifier.reportTrial(true, 100);
      }

      expect(notifier.state.currentLevel, 2);
      expect(notifier.state.upWindow.isEmpty, true);
      expect(notifier.state.downWindow.isEmpty, true);
    });

    test('Should NOT increment level before window is full (19 trials)', () async {
      await notifier.load('test_game');

      for (int i = 0; i < 19; i++) {
        notifier.reportTrial(true, 500);
      }

      expect(notifier.state.currentLevel, 1);
      expect(notifier.state.upWindow.length, 19);
    });

    test('Should NOT increment level if accuracy is below 80% (e.g., 15/20 = 75%)', () async {
      await notifier.load('test_game');

      for (int i = 0; i < 5; i++) { notifier.reportTrial(false, 500); }
      for (int i = 0; i < 15; i++) { notifier.reportTrial(true, 500); }

      expect(notifier.state.currentLevel, 1);
      expect(notifier.state.upWindow.length, 20);
    });
  });

  group('AdaptiveEngineNotifier - Level Down Logic', () {
    test('Should decrement level after 10 trials if accuracy < 60% and last trial is incorrect', () async {
      // Start at level 2
      when(() => mockRepo.getDifficultyForGame('test_game')).thenAnswer((_) async => 2);
      await notifier.load('test_game');

      // 5 correct, 5 incorrect (50% accuracy)
      for (int i = 0; i < 5; i++) { notifier.reportTrial(true, 500); }
      for (int i = 0; i < 5; i++) { notifier.reportTrial(false, 500); }

      expect(notifier.state.currentLevel, 1);
      expect(notifier.state.upWindow.isEmpty, true);
      expect(notifier.state.downWindow.isEmpty, true);
    });

    test('Should NOT decrement level if accuracy < 60% but last trial was correct', () async {
      when(() => mockRepo.getDifficultyForGame('test_game')).thenAnswer((_) async => 2);
      await notifier.load('test_game');

      // 7 incorrect, then 3 correct (30% accuracy, but last is correct)
      for (int i = 0; i < 7; i++) { notifier.reportTrial(false, 500); }
      for (int i = 0; i < 3; i++) { notifier.reportTrial(true, 500); }

      expect(notifier.state.currentLevel, 2);
      expect(notifier.state.downWindow.length, 10);
    });

    test('Should NOT decrement below 1', () async {
      await notifier.load('test_game'); // Level 1

      for (int i = 0; i < 10; i++) { notifier.reportTrial(false, 500); }

      expect(notifier.state.currentLevel, 1);
      expect(notifier.state.upWindow.isEmpty, true); // Still resets windows
    });
  });

  group('AdaptiveEngineNotifier - Persistence', () {
    test('Should save to repository on session end', () async {
      await notifier.load('test_game');
      
      // Level up to 2
      for (int i = 0; i < 20; i++) { notifier.reportTrial(true, 100); }
      
      await notifier.save('test_game');
      
      verify(() => mockRepo.upsertDifficulty('test_game', 2)).called(1);
    });
  });
}
