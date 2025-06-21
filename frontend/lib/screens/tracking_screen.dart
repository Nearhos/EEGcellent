import 'package:eegcellent/widgets/circular_scale_indicator.dart';
import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome, Harry",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "Let's check your stress",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                  ),
                ),
              ],
            ),
          ),
          CircularScaleIndicator(
            maxStressLevel: 10,
            stressLevel: 7,
          ),
        ],
      ),
    );
  }
}
