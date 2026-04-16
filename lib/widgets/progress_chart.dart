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

    final double rawMinRt = _getMinRt();
    final double rawMaxRt = _getMaxRt();

    final double yMinCalc = ((rawMinRt / 50).floor() * 50.0) - 50.0;
    final double yMaxCalc = ((rawMaxRt / 50).ceil() * 50.0) + 50.0;

    final double yMin = yMinCalc < 0 ? 0 : yMinCalc;
    final double yMax = yMaxCalc <= yMin ? yMin + 100 : yMaxCalc;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: LineChart(
        LineChartData(
          minY: yMin,
          maxY: yMax,
          minX: data.first.sessionNum.toDouble() - 0.5,
          maxX: data.last.sessionNum.toDouble() + 0.5,
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .map((d) => FlSpot(d.sessionNum.toDouble(), d.avgCongruentRt))
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
                  .map(
                    (d) => FlSpot(d.sessionNum.toDouble(), d.avgIncongruentRt),
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
                // Map difficulty 1..10 to the yMin..yMax range of the RT axis
                final double diffFactor =
                    (d.endingDifficulty.clamp(1, 10) - 1) / 9.0;
                final double scaled = yMin + (diffFactor * (yMax - yMin));
                return FlSpot(d.sessionNum.toDouble(), scaled);
              }).toList(),
              color: const Color(0xFF00E676),
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 50,
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
                interval: (yMax - yMin) / 9,
                getTitlesWidget: (value, meta) {
                  // The interval is exactly (yMax - yMin) / 9, so fl_chart calls this at 10 ticks.
                  // We map those ticks directly to 1..10.
                  double ratio = (value - yMin) / (yMax - yMin);
                  int level = (ratio * 9).round() + 1;
                  
                  if (level < 1 || level > 10) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFb7a3cf),
                      ),
                    ),
                  );
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

  double _getMinRt() {
    double minVal = double.infinity;
    for (var d in data) {
      if (d.avgCongruentRt < minVal && d.avgCongruentRt > 0) {
        minVal = d.avgCongruentRt;
      }
      if (d.avgIncongruentRt < minVal && d.avgIncongruentRt > 0) {
        minVal = d.avgIncongruentRt;
      }
    }
    return minVal == double.infinity ? 0 : minVal;
  }

  double _getMaxRt() {
    double maxVal = 0;
    for (var d in data) {
      if (d.avgCongruentRt > maxVal) maxVal = d.avgCongruentRt;
      if (d.avgIncongruentRt > maxVal) maxVal = d.avgIncongruentRt;
    }
    return maxVal == 0 ? 100 : maxVal;
  }
}
