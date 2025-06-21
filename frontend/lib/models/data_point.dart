import 'package:cloud_firestore/cloud_firestore.dart';

class DataPoint {
  final Timestamp timestamp;
  final double stress;

  const DataPoint({
    required this.timestamp,
    required this.stress,
  });
}
