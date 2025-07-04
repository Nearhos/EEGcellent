import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gauge/firebase.dart';
import 'package:gauge/main.dart';
import 'package:gauge/models/data_point.dart';
import 'package:gauge/models/day_progress_data.dart';
import 'package:gauge/widgets/analysis_sheet_content.dart';
import 'package:gauge/widgets/circular_scale_indicator.dart';
import 'package:sheet/sheet.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() =>
      _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  DayProgressData? _data;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _listener;

  void triggerNotification() async {
    const AndroidNotificationDetails
    androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(
          android: androidNotificationDetails,
        );
    await flutterLocalNotificationsPlugin.show(
      2,
      'Take a break!',
      'Your stress level is getting up there.',
      notificationDetails,
    );
  }

  void Function(QuerySnapshot<Map<String, dynamic>>)
  createDataListener(DateTime datetime) {
    return (
      QuerySnapshot<Map<String, dynamic>> data,
    ) async {
      final dataPoints =
          data.docs.map((doc) {
            final data = doc.data();
            return DataPoint(
              timestamp: data["timestamp"],
              stress: data["stress"],
            );
          }).toList();
      print(data.size);

      final averageScore =
          await db
              .collection("data")
              .where(
                "timestamp",
                isGreaterThanOrEqualTo: datetime.subtract(
                  const Duration(minutes: 15),
                ),
              )
              .aggregate(average("stress"))
              .get();

      double? averageStress = averageScore.getAverage(
        "stress",
      );

      if (dataPoints.isEmpty) {
        setState(() {
          _data = DayProgressData(
            data: dataPoints,
            averageScore: null,
          );
        });
      } else {
        setState(() {
          _data = DayProgressData(
            data: dataPoints,
            averageScore: averageStress,
          );
        });

        if (averageStress != null && averageStress >= 8) {
          triggerNotification();
        }
      }
    };
  }

  void startProgressListener(DateTime datetime) async {
    final snapshots =
        db
            .collection("data")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: datetime.subtract(
                const Duration(hours: 1),
              ),
            )
            .orderBy("timestamp")
            .snapshots();

    _listener = snapshots.listen(
      createDataListener(datetime),
    );
  }

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now().toUtc();

    startProgressListener(now);
  }

  @override
  void dispose() {
    super.dispose();

    if (_listener != null) {
      _listener!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome, Harry",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(
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
                    ).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                    ),
                  ),
                ],
              ),
              CircularScaleIndicator(
                maxStressLevel: 10,
                stressLevel: _data?.averageScore,
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Sheet(
              fit: SheetFit.expand,
              initialExtent: 310,
              minExtent: 310,
              maxExtent: 310,
              child: AnalysisSheetContent(
                data: _data?.data,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
