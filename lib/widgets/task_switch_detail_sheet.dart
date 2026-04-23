import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/providers/task_switch_stats_provider.dart';
import 'package:hebbo/screens/task_switch_screen.dart';
import 'package:hebbo/screens/progress_screen.dart';
import 'package:hebbo/widgets/stat_chip.dart';
import 'package:hebbo/widgets/stat_chip_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hebbo/widgets/task_switch_tutorial_sheet.dart';
import 'package:hebbo/providers/database_provider.dart';

class TaskSwitchDetailSheet extends ConsumerWidget {
  const TaskSwitchDetailSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(taskSwitchStatsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Switching',
                style: AppTextStyles.plusJakarta(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => TaskSwitchTutorialSheet.show(context),
                icon: Icon(
                  Icons.help_outline,
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          statsAsync.when(
            loading: () => const Row(
              children: [
                Expanded(child: StatChipSkeleton()),
                SizedBox(width: 12),
                Expanded(child: StatChipSkeleton()),
              ],
            ),
            error: (err, stack) => Text('Error loading statistics', style: AppTextStyles.plusJakarta(color: Colors.red)),
            data: (stats) {
              if (!stats.hasPlayedBefore) {
                return Text(
                  'First session — we\'ll find your level',
                  style: AppTextStyles.plusJakarta(
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                );
              }
              return Row(
                children: [
                   Expanded(
                    child: StatChip(
                      label: 'Personal Best',
                      value: '${stats.bestRtMs} ms',
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatChip(
                      label: 'Sessions',
                      value: '${stats.totalSessions}',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Trains cognitive flexibility — your ability to rapidly shift between different rules and mental sets.',
            style: AppTextStyles.plusJakarta(
              color: AppColors.textPrimary.withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Based on Rogers & Monsell (1995)',
            style: AppTextStyles.plusJakarta(
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFFFF5C8D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final prefs = ref.read(sharedPreferencesProvider);
                  final hasSeenTutorial = prefs.getBool('has_seen_task_switch_tutorial') ?? false;

                  if (!hasSeenTutorial) {
                    await prefs.setBool('has_seen_task_switch_tutorial', true);
                    if (context.mounted) {
                      await TaskSwitchTutorialSheet.show(context);
                    }
                  }

                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TaskSwitchScreen()),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Play',
                      style: AppTextStyles.plusJakarta(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Progress Link
          Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProgressScreen(gameId: 'task-switching'),
                      ),
                    );
                  },
                  child: Text(
                    'View your progress',
                    style: AppTextStyles.plusJakarta(
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
