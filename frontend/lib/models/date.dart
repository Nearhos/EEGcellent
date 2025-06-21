class Date implements Comparable<Date> {
  final int year;
  final int month;
  final int day;

  const Date({
    required this.year,
    required this.month,
    required this.day,
  });

  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  @override
  int compareTo(Date other) {
    return toDateTime().compareTo(other.toDateTime());
  }
}
