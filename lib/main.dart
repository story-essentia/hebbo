import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/hebbo_database.dart';
import 'providers/adaptive_engine_provider.dart';
import 'providers/flanker_game_provider.dart';
import 'repositories/drift_difficulty_repository.dart';
import 'repositories/drift_session_repository.dart';
import 'repositories/drift_trial_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = HebboDatabase();
  final trialRepo = DriftTrialRepository(database);
  final sessionRepo = DriftSessionRepository(database);
  final difficultyRepo = DriftDifficultyRepository(database);

  runApp(
    ProviderScope(
      overrides: [
        difficultyRepositoryProvider.overrideWithValue(difficultyRepo),
        trialRepositoryProvider.overrideWithValue(trialRepo),
        sessionRepositoryProvider.overrideWithValue(sessionRepo),
      ],
      child: const HebboApp(),
    ),
  );
}

class HebboApp extends StatelessWidget {
  const HebboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hebbo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
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
