import 'package:gauge/models/data_point.dart';

class DayProgressData {
  final List<DataPoint> data;
  final double? averageScore;

  const DayProgressData({
    required this.data,
    required this.averageScore,
  });
}
