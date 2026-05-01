import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:hebbo/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  final database = HebboDatabase();
  final trialRepo = DriftTrialRepository(database);
  final sessionRepo = DriftSessionRepository(database);
  final difficultyRepo = DriftDifficultyRepository(database);

  final sharedPreferences = await SharedPreferences.getInstance();

  final hasRunFinalCleanup =
      sharedPreferences.getBool('has_run_final_cleanup') ?? false;
  if (!hasRunFinalCleanup) {
    await database.clearAllData();
    await sharedPreferences.setBool('has_run_final_cleanup', true);
  }

  // One-time repair for session numbers
  final hasRunRepair =
      sharedPreferences.getBool('has_run_session_repair_v1') ?? false;
  if (!hasRunRepair) {
    await database.repairSessionNumbers();
    await sharedPreferences.setBool('has_run_session_repair_v1', true);
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

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class HebboApp extends StatelessWidget {
  final bool hasSeenHonestyScreen;

  const HebboApp({super.key, required this.hasSeenHonestyScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Hebbo',
      theme: AppTheme.darkTheme,
      home: hasSeenHonestyScreen ? const HomeScreen() : const HonestyScreen(),
    );
  }
}
