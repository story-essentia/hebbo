import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/progress_provider.dart';
import 'package:hebbo/widgets/progress_metrics_widget.dart';
import 'package:hebbo/widgets/progress_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF150629),
      appBar: AppBar(
        title: const Text("Your Progress", style: TextStyle(color: Color(0xFFefdfff))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFefdfff)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: stateAsync.when(
        data: (state) {
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFefdfff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(progressProvider.notifier).toggleViewMode();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFff8aa7),
                        ),
                        child: Text(state.showAllTime ? "All time" : "Last 10",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      _LegendItem(color: Color(0xFFFF8AA7), label: 'Congruent', isDashed: false),
                      SizedBox(width: 16),
                      _LegendItem(color: Color(0xFFf0bfff), label: 'Incongruent', isDashed: true),
                      SizedBox(width: 16),
                      _LegendItem(color: Color(0xFF00E676), label: 'Difficulty', isDashed: false),
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
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        )),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({required this.color, required this.label, required this.isDashed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 2,
          child: CustomPaint(
            painter: _LinePainter(color: color, isDashed: isDashed),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
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
        canvas.drawLine(Offset(startX, size.height / 2),
            Offset(startX + dashWidth, size.height / 2), paint);
        startX += dashWidth + dashSpace;
      }
    } else {
      canvas.drawLine(
          Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
