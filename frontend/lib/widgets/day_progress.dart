import 'package:eegcellent/models/data_point.dart';
import 'package:eegcellent/models/day_progress_data.dart';
import 'package:eegcellent/widgets/analysis_sheet_content.dart';
import 'package:eegcellent/widgets/circular_scale_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sheet/sheet.dart';

class DayProgress extends StatefulWidget {
  final DateTime date;

  const DayProgress({super.key, required this.date});

  @override
  State<DayProgress> createState() => _DayProgressState();
}

class _DayProgressState extends State<DayProgress> {
  DayProgressData? _data;

  DayProgressData fetchData() {
    // TODO: fetch from firebase
    return DayProgressData(data: [], averageScore: 7.8);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _data = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularScaleIndicator(
          maxStressLevel: 10,
          stressLevel: 7,
        ),
        Spacer(),
        SizedBox(
          height: 320.0,
          width: double.infinity,
          child: Sheet(
            fit: SheetFit.expand,
            initialExtent: 800,
            child: const AnalysisSheetContent(),
          ),
        ),
      ],
    );
  }
}
