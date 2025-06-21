import 'package:eegcellent/models/data_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisChart extends StatefulWidget {
  final int maxStressLevel;
  final List<DataPoint> data;

  const AnalysisChart({
    super.key,
    required this.maxStressLevel,
    required this.data,
  });

  @override
  State<AnalysisChart> createState() =>
      _AnalysisChartState();
}

class _AnalysisChartState extends State<AnalysisChart> {
  late double _minX;
  late double _maxX;
  late final double originalMaxX;
  late final double originalMinX;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    originalMinX =
        widget.data.first.timestamp.millisecondsSinceEpoch
            .toDouble();
    originalMaxX =
        widget.data.last.timestamp.millisecondsSinceEpoch
            .toDouble();

    setState(() {
      _minX = originalMinX;
      _maxX = originalMaxX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _minX = originalMinX;
          _maxX = originalMaxX;
        });
      },
      onScaleUpdate: (scaleUpd) {
        // doesn't trigger
      },
      onHorizontalDragUpdate: (dragUpdDet) {
        setState(() {
          double primDelta = dragUpdDet.primaryDelta ?? 0.0;
          if (primDelta != 0) {
            if (primDelta.isNegative) {
              if (_maxX < originalMaxX) {
                _minX += _maxX * 0.05;
                _maxX += _maxX * 0.05;
              }
            } else {
              if (_minX > 0) {
                _minX -= _maxX * 0.05;
                _maxX -= _maxX * 0.05;
              }
            }
          }

          if (_minX < originalMinX) {
            _minX = originalMinX;
          }

          if (_maxX > originalMaxX) {
            _maxX = originalMaxX;
          }
        });
      },
      child: LineChart(
        LineChartData(
          // read about it in the LineChartData section
          lineBarsData: [
            LineChartBarData(
              spots:
                  widget.data
                      .map(
                        (data) => FlSpot(
                          data
                              .timestamp
                              .millisecondsSinceEpoch
                              .toDouble(),
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
                    ).colorScheme.secondary.withAlpha(224),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withAlpha(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              color:
                  Theme.of(context).colorScheme.secondary,
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
                maxIncluded: true,
                showTitles: true,
                reservedSize: 30,
                interval:
                    60000 *
                    15, // Milliseconds per min * 5 min intervals
                getTitlesWidget: (x, titleMeta) {
                  DateTime timestamp =
                      DateTime.fromMillisecondsSinceEpoch(
                        x.floor(),
                      );
                  String formattedTime = DateFormat.Hm()
                      .format(timestamp);

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
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
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toStringAsFixed(1),
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
                      Theme.of(
                        context,
                      ).colorScheme.onSurface,
            ),
          ),
          minY: 0,
          maxY: widget.maxStressLevel.toDouble(),
          maxX: _maxX,
          minX: _minX,
        ),
        duration: Duration(milliseconds: 150),
        curve: Curves.linear,
        transformationConfig: FlTransformationConfig(
          maxScale: 100000.0,
          minScale: 10000.0,
          scaleAxis: FlScaleAxis.horizontal,
        ),
      ),
    );
  }
}
