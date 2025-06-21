import 'package:flutter/material.dart';

class CircularScaleIndicator extends StatelessWidget {
  final double maxStressLevel;
  final double? stressLevel;
  final String label;

  const CircularScaleIndicator({
    super.key,
    required this.stressLevel,
    required this.maxStressLevel,
    this.label = "STRESS",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.15,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: SizedBox(
                    width: double.infinity,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end:
                            stressLevel == null
                                ? 0.0
                                : stressLevel! /
                                    maxStressLevel,
                      ),
                      duration: Duration(
                        milliseconds:
                            stressLevel == null
                                ? 0
                                : (800.0 *
                                        stressLevel! /
                                        maxStressLevel)
                                    .toInt(),
                      ),
                      builder:
                          (context, value, _) =>
                              CircularProgressIndicator(
                                value:
                                    stressLevel == null
                                        ? 0
                                        : value,
                                strokeWidth: 24.0,
                                strokeCap: StrokeCap.round,
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 25.0),
                  Text(
                    stressLevel == null
                        ? '-'
                        : stressLevel!.toStringAsFixed(1),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge!.copyWith(
                      height: 0.9,
                      fontSize: 72.0,
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
