import 'package:flutter/material.dart';
import 'package:gauge/models/data_point.dart';
import 'package:gauge/widgets/analysis_chart.dart';

class AnalysisSheetContent extends StatelessWidget {
  final List<DataPoint>? data;
  const AnalysisSheetContent({
    super.key,
    required this.data,
  });

  Widget generateContent() {
    if (data == null) {
      return LoadingContent();
    } else if (data!.isEmpty) {
      return NoDataContent();
    } else {
      return AnalysisChart(maxStressLevel: 10, data: data!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 48.0, 4.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color:
            Theme.of(
              context,
            ).colorScheme.onPrimaryContainer,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: generateContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class NoDataContent extends StatelessWidget {
  const NoDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No data.",
        style: Theme.of(
          context,
        ).textTheme.headlineSmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class LoadingContent extends StatelessWidget {
  const LoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
