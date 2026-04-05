import '../models/session_entity.dart';

abstract class ISessionRepository {
  Future<int> insertSession(SessionEntity session);
  Future<List<SessionEntity>> getAllSessions();
}
