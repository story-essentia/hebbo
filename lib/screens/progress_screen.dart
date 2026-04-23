import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/progress_provider.dart';
import 'package:hebbo/widgets/progress_metrics_widget.dart';
import 'package:hebbo/widgets/progress_chart.dart';
import 'package:hebbo/theme/app_theme.dart';

class ProgressScreen extends ConsumerWidget {
  final String gameId;
  const ProgressScreen({super.key, this.gameId = 'flanker'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(progressProvider(gameId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          gameId == 'task-switching' ? "Switching Progress" : "Flanker Progress",
          style: AppTextStyles.plusJakarta(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: stateAsync.when(
        data: (state) {
          final isTaskSwitch = gameId == 'task-switching';
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProgressMetricsWidget(metrics: state.metrics),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Session History",
                        style: AppTextStyles.plusJakarta(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(progressProvider(gameId).notifier).toggleViewMode();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        child: Text(
                          state.showAllTime ? "All time" : "Last 10",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _LegendItem(
                        color: const Color(0xFFFF8AA7),
                        label: isTaskSwitch ? 'Repeat' : 'Congruent',
                        isDashed: false,
                      ),
                      _LegendItem(
                        color: const Color(0xFFf0bfff),
                        label: isTaskSwitch ? 'Switch' : 'Incongruent',
                        isDashed: true,
                      ),
                      const _LegendItem(
                        color: Color(0xFF00E676),
                        label: 'Difficulty',
                        isDashed: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 1.1,
                    child: ProgressChart(data: state.chartData),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error loading progress',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDashed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 3,
          child: CustomPaint(
            painter: _LinePainter(color: color, isDashed: isDashed),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.plusJakarta(fontSize: 12, color: AppColors.textPrimary.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  _LinePainter({required this.color, required this.isDashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (isDashed) {
      double dashWidth = 4, dashSpace = 3, startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
