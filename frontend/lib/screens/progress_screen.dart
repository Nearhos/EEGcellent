import 'package:eegcellent/widgets/analysis_sheet_content.dart';
import 'package:eegcellent/widgets/circular_scale_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sheet/sheet.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required });

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome, Harry",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "Let's check your stress",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
