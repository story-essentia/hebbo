import 'package:flutter/material.dart';
import 'database/hebbo_database.dart';
import 'providers/difficulty_provider.dart';
import 'providers/session_provider.dart';
import 'repositories/drift_difficulty_repository.dart';
import 'repositories/drift_session_repository.dart';
import 'repositories/drift_trial_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize persistence layer
  final database = HebboDatabase();
  
  // Initialize repositories
  final trialRepo = DriftTrialRepository(database);
  final sessionRepo = DriftSessionRepository(database);
  final difficultyRepo = DriftDifficultyRepository(database);
  
  // Initialize providers (DI stubs)
  final sessionProvider = SessionProvider(
    sessionRepository: sessionRepo,
    trialRepository: trialRepo,
  );
  final difficultyProvider = DifficultyProvider(
    difficultyRepository: difficultyRepo,
  );

  runApp(HebboApp(
    sessionProvider: sessionProvider,
    difficultyProvider: difficultyProvider,
  ));
}

class HebboApp extends StatelessWidget {
  final SessionProvider sessionProvider;
  final DifficultyProvider difficultyProvider;

  const HebboApp({
    super.key,
    required this.sessionProvider,
    required this.difficultyProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hebbo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hebbo: Brain Training App (Foundation)'),
        ),
      ),
    );
  }
}
