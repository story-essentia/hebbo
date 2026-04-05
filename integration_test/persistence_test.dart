import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hebbo/database/hebbo_database.dart';
import 'package:hebbo/models/session_entity.dart';
import 'package:hebbo/models/trial_entity.dart';
import 'package:hebbo/repositories/drift_session_repository.dart';
import 'package:hebbo/repositories/drift_trial_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Persistence test: verify data survives database re-initialization', (WidgetTester tester) async {
    // 1. Initial setup: Open database and repositories
    var database = HebboDatabase();
    var sessionRepo = DriftSessionRepository(database);
    var trialRepo = DriftTrialRepository(database);

    // 2. Insert mock session
    final mockSession = SessionEntity(
      sessionNum: 1,
      startedAt: DateTime(2026, 4, 4, 20),
      endedAt: DateTime(2026, 4, 4, 21),
      startingLevel: 1,
      endingLevel: 2,
      environmentTier: 1,
    );
    final sessionId = await sessionRepo.insertSession(mockSession);
    expect(sessionId, 1);

    // 3. Insert mock trials
    final mockTrial1 = TrialEntity(
      sessionId: sessionId,
      trialNum: 1,
      type: 'congruent',
      correct: true,
      reactionMs: 450,
      difficulty: 1,
      timestamp: DateTime.now(),
    );
    await trialRepo.insertTrial(mockTrial1);

    // 4. Simulate "restart" by closing and re-opening database
    await database.close();
    
    // Use a fresh database instance (connecting to the same file)
    database = HebboDatabase();
    sessionRepo = DriftSessionRepository(database);
    trialRepo = DriftTrialRepository(database);

    // 5. Verify session persistence
    final sessions = await sessionRepo.getAllSessions();
    expect(sessions.length, 1);
    expect(sessions.first.id, sessionId);
    expect(sessions.first.sessionNum, 1);

    // 6. Verify trials persistence
    final trials = await trialRepo.getTrialsForSession(sessionId);
    expect(trials.length, 1);
    expect(trials.first.trialNum, 1);
    expect(trials.first.type, 'congruent');
    expect(trials.first.correct, true);

    await database.close();
  });
}
