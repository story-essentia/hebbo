import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/hebbo_database.dart';
import 'providers/adaptive_engine_provider.dart';
import 'providers/flanker_game_provider.dart';
import 'repositories/drift_difficulty_repository.dart';
import 'repositories/drift_session_repository.dart';
import 'repositories/drift_trial_repository.dart';
import 'package:hebbo/screens/home_screen.dart';
import 'package:hebbo/screens/honesty_screen.dart';
import 'package:hebbo/providers/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = HebboDatabase();
  final trialRepo = DriftTrialRepository(database);
  final sessionRepo = DriftSessionRepository(database);
  final difficultyRepo = DriftDifficultyRepository(database);

  final sharedPreferences = await SharedPreferences.getInstance();

  final hasRunDevCleanup =
      sharedPreferences.getBool('has_run_dev_cleanup') ?? false;
  if (!hasRunDevCleanup) {
    await database.cleanupDevelopmentData();
    await sharedPreferences.setBool('has_run_dev_cleanup', true);
  }

  final hasSeenHonestyScreen =
      sharedPreferences.getBool('has_seen_honesty_screen') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        difficultyRepositoryProvider.overrideWithValue(difficultyRepo),
        trialRepositoryProvider.overrideWithValue(trialRepo),
        sessionRepositoryProvider.overrideWithValue(sessionRepo),
      ],
      child: HebboApp(hasSeenHonestyScreen: hasSeenHonestyScreen),
    ),
  );
}

class HebboApp extends StatelessWidget {
  final bool hasSeenHonestyScreen;

  const HebboApp({super.key, required this.hasSeenHonestyScreen});

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
      home: hasSeenHonestyScreen ? const HomeScreen() : const HonestyScreen(),
    );
  }
}
