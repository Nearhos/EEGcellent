import 'package:eegcellent/models/data_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisChart extends StatelessWidget {
  final int maxStressLevel;
  final List<DataPoint> data;

  const AnalysisChart({
    super.key,
    required this.maxStressLevel,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // read about it in the LineChartData section
        lineBarsData: [
          LineChartBarData(
            spots:
                data
                    .map(
                      (data) => FlSpot(
                        data.time.toDouble(),
                        data.stress.toDouble(),
                      ),
                    )
                    .toList(),
            isStrokeCapRound: true,
            barWidth: 6,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withAlpha(192),
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            color: Theme.of(context).colorScheme.secondary,
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              minIncluded: true,
              maxIncluded: false,
              showTitles: true,
              reservedSize: 30,
              interval:
                  60000 *
                  5, // Milliseconds per min * 5 min intervals
              getTitlesWidget: (x, titleMeta) {
                DateTime timestamp =
                    DateTime.fromMillisecondsSinceEpoch(
                      x.floor(),
                    );
                String formattedTime = DateFormat.Hm()
                    .format(timestamp);

                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    formattedTime,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (y, titleMeta) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Text(
                    y.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
          border: Border(
            bottom: BorderSide(
              color:
                  Theme.of(context).colorScheme.onSurface,
              width: 1.0,
            ),
            left: BorderSide(
              color:
                  Theme.of(context).colorScheme.onSurface,
              width: 1.0,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          verticalInterval:
              60000 *
              1, // Milliseconds per min * 1 min intervals
          // checkToShowHorizontalLine: (double value) {
          //   return value % 2 == 0;
          // },
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toString(),
                  Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surface,
                  ),
                );
              }).toList();
            },
            getTooltipColor:
                (touchedSpot) =>
                    Theme.of(context).colorScheme.onSurface,
          ),
        ),
        minY: 0,
        maxY: maxStressLevel.toDouble(),
      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }
}
