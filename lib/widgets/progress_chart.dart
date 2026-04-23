import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hebbo/models/progress_models.dart';

class ProgressChart extends StatelessWidget {
  final List<SessionChartData> data;

  const ProgressChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No session data available.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final double yMin = 0;
    final double yMax = 1500;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF514166),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final TextStyle textStyle = TextStyle(
                    color: spot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  
                  if (spot.barIndex == 2) {
                    double ratio = (spot.y - yMin) / (yMax - yMin);
                    int level = (ratio * 9).round() + 1;
                    return LineTooltipItem('Lvl: $level', textStyle);
                  }
                  
                  return LineTooltipItem('${spot.y.round()}ms', textStyle);
                }).toList();
              },
            ),
          ),
          minY: yMin,
          maxY: yMax,
          minX: data.first.sessionNum.toDouble() - 0.5,
          maxX: data.last.sessionNum.toDouble() + 0.5,
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .where((d) => d.metricARt > 0)
                  .map((d) => FlSpot(d.sessionNum.toDouble(), d.metricARt))
                  .toList(),
              isCurved: true,
              color: const Color(0xFFFF8AA7),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: data
                  .where((d) => d.metricBRt > 0)
                  .map(
                    (d) => FlSpot(d.sessionNum.toDouble(), d.metricBRt),
                  )
                  .toList(),
              isCurved: true,
              color: const Color(0xFFf0bfff),
              barWidth: 3,
              dashArray: [5, 5],
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              isStepLineChart: true,
              spots: data.map((d) {
                final double diffFactor =
                    (d.endingDifficulty.clamp(1, 10) - 1) / 9.0;
                final double scaled = yMin + (diffFactor * (yMax - yMin));
                return FlSpot(d.sessionNum.toDouble(), scaled);
              }).toList(),
              color: const Color(0xFF00E676),
              barWidth: 2,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 250,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFb7a3cf),
                    ),
                  );
                },
              ),
              axisNameWidget: const Text(
                "RT (ms)",
                style: TextStyle(fontSize: 12, color: Color(0xFFb7a3cf)),
              ),
              axisNameSize: 20,
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                // Force 10 titles (1 to 10)
                interval: (yMax - yMin) / 9,
                getTitlesWidget: (value, meta) {
                  // We want to show labels for indices 0..9 corresponding to levels 1..10
                  // Logic: for each possible level, find the Y value.
                  // Since fl_chart calls this for many values, we check which level 'value' represents.
                  
                  for (int i = 0; i < 10; i++) {
                    double targetY = yMin + i * (yMax - yMin) / 9;
                    if ((value - targetY).abs() < (yMax - yMin) / 20) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFb7a3cf),
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              axisNameWidget: const Text(
                "Level",
                style: TextStyle(fontSize: 12, color: Color(0xFF00E676)),
              ),
              axisNameSize: 20,
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value >= data.first.sessionNum - 0.5 &&
                      value <= data.last.sessionNum + 0.5) {
                    if (value % 1 == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFb7a3cf),
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              axisNameWidget: const Text(
                "Session",
                style: TextStyle(fontSize: 12, color: Color(0xFFb7a3cf)),
              ),
              axisNameSize: 25,
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) => FlLine(
              color: const Color(0xFF514166).withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: const Color(0xFF514166).withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
