import 'package:flutter/material.dart';
import 'package:hebbo/models/progress_models.dart';

class ProgressMetricsWidget extends StatelessWidget {
  final ProgressMetrics metrics;

  const ProgressMetricsWidget({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            context,
            "Best RT",
            "${metrics.personalBestRtMs}ms",
            Icons.timer,
          ),
          _buildCard(
            context,
            "Sessions",
            "${metrics.totalSessionsCompleted}",
            Icons.check_circle_outline,
          ),
          if (metrics.currentEnvironmentTier != null)
            _buildCard(
              context,
              "Environment",
              metrics.currentEnvironmentTier!,
              Icons.water,
            ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        color: const Color(0xFF301a4d),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: const Color(0xFFb7a3cf)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFFb7a3cf)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFefdfff),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
