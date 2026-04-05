import '../models/trial_entity.dart';

abstract class ITrialRepository {
  Future<int> insertTrial(TrialEntity trial);
  Future<List<TrialEntity>> getTrialsForSession(int sessionId);
}
