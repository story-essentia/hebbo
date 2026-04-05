import '../repositories/i_session_repository.dart';
import '../repositories/i_trial_repository.dart';

class SessionProvider {
  final ISessionRepository sessionRepository;
  final ITrialRepository trialRepository;

  SessionProvider({
    required this.sessionRepository,
    required this.trialRepository,
  });
}
