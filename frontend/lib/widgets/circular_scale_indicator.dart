import 'package:flutter/material.dart';

class CircularScaleIndicator extends StatelessWidget {
  final int maxStressLevel;
  final int stressLevel;

  const CircularScaleIndicator({
    super.key,
    required this.stressLevel,
    required this.maxStressLevel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(64.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: SizedBox(
                    width: double.infinity,
                    child: CircularProgressIndicator(
                      value: stressLevel / maxStressLevel,
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
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 25.0,),
                  Text(
                    stressLevel.toString(),
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
                    "STRESS",
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
