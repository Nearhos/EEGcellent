import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eegcellent/firebase.dart';
import 'package:eegcellent/models/data_point.dart';
import 'package:eegcellent/models/date.dart';
import 'package:eegcellent/models/day_progress_data.dart';
import 'package:eegcellent/widgets/analysis_sheet_content.dart';
import 'package:eegcellent/widgets/circular_scale_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheet/sheet.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required});

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  SplayTreeSet<Date>? _dates;
  int? _dateIndex;
  DayProgressData? _data;

  Future<DayProgressData?> fetchProgressData(
    Date date,
  ) async {
    DateTime datetime = date.toDateTime();
    final snapshot =
        await db
            .collection("data")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: datetime,
              isLessThan: datetime.add(
                const Duration(days: 1),
              ),
            )
            .get();

    final dataPoints =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return DataPoint(
            timestamp: data["timestamp"],
            stress: data["stress"],
          );
        }).toList();

    final averageScore =
        await db
            .collection("data")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: datetime,
              isLessThan: datetime.add(
                const Duration(days: 1),
              ),
            )
            .aggregate(average("stress"))
            .get();
    return DayProgressData(
      data: dataPoints,
      averageScore: averageScore.getAverage("stress")!,
    );
  }

  Future<SplayTreeSet<Date>> fetchDatesData() async {
    final snapshot = await db.collection("data").get();
    List<DateTime> datetimes =
        snapshot.docs.map((doc) {
          Timestamp timestamp = doc.data()["timestamp"];
          return DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
          );
        }).toList();

    SplayTreeSet<Date> dates = SplayTreeSet.from(
      datetimes
          .map(
            (datetime) => Date(
              year: datetime.year,
              month: datetime.month,
              day: datetime.day,
            ),
          )
          .toList(),
    );

    return dates;
  }

  void setProgressData(Date date) async {
    final data = await fetchProgressData(date);

    setState(() {
      _data = data;
    });
  }

  void setData() async {
    final dates = await fetchDatesData();
    final data = await fetchProgressData(dates.last);

    setState(() {
      _dates = dates;
      _dateIndex = dates.length - 1;
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();

    setData();
  }

  @override
  Widget build(BuildContext context) {
    final date =
        _dates == null || _dateIndex == null
            ? null
            : _dates!.elementAt(_dateIndex!);
    final formatter = DateFormat.yMd();
    final formattedDate =
        date == null
            ? null
            : formatter.format(date.toDateTime());

    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_dates == null) {
                          return;
                        }
                        final dateIndex = max(
                          0,
                          _dateIndex! - 1,
                        );
                        final data =
                            await fetchProgressData(
                              _dates!.elementAt(dateIndex),
                            );

                        setState(() {
                          _dateIndex = dateIndex;
                          _data = data;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        size:
                            Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                      ),
                    ),
                    Text(
                      formattedDate ?? '-',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_dates == null) {
                          return;
                        }
                        final dateIndex = min(
                          _dates!.length - 1,
                          _dateIndex! + 1,
                        );

                        final data =
                            await fetchProgressData(
                              _dates!.elementAt(dateIndex),
                            );

                        setState(() {
                          _dateIndex = dateIndex;
                          _data = data;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        size:
                            Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              CircularScaleIndicator(
                maxStressLevel: 10,
                stressLevel: _data?.averageScore,
                label: "DAY SCORE",
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Sheet(
              fit: SheetFit.expand,
              initialExtent: 320,
              minExtent: 320,
              child: AnalysisSheetContent(data: _data?.data),
            ),
          ),
        ],
      ),
    );
  }
}
