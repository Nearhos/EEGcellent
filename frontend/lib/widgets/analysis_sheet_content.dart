import 'package:eegcellent/models/data_point.dart';
import 'package:eegcellent/widgets/analysis_chart.dart';
import 'package:flutter/material.dart';

class AnalysisSheetContent extends StatelessWidget {
  const AnalysisSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 48.0, 4.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: AnalysisChart(maxStressLevel: 10, data: [
                DataPoint(time: 1641031200000 + 60000, stress: 8),
                DataPoint(time: 1641031200000 + 120000, stress: 4),
                DataPoint(time: 1641031200000 + 180000, stress: 2),
                DataPoint(time: 1641031200000 + 320000, stress: 5),
                DataPoint(time: 1641031200000 + 400000, stress: 10),
              ]),
            ),
          )
        ],
      ),
    );
  }
}