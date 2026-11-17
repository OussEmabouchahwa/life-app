/// Formatting helpers for times and durations shown across the app.
abstract final class TimeFormat {
  static String _two(int n) => n.toString().padLeft(2, '0');

  /// 07:10
  static String hm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

  /// 07:10 from minutes after midnight.
  static String minutes(int m) => '${_two(m ~/ 60 % 24)}:${_two(m % 60)}';

  /// 01:24 (minutes:seconds)
  static String ms(Duration d) => '${_two(d.inMinutes.remainder(60))}:${_two(d.inSeconds.remainder(60))}';

  /// "1h 32m", "45m", "2h"
  static String compact(Duration d) {
    final h = d.inHours, m = d.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  /// "1 h 30", "55 min"
  static String length(Duration d) {
    final h = d.inHours, m = d.inMinutes.remainder(60);
    if (h == 0) return '$m min';
    return m == 0 ? '$h h' : '$h h ${_two(m)}';
  }
}

extension DateOnly on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime at(int hour, [int minute = 0]) => DateTime(year, month, day, hour, minute);

  bool isSameDay(DateTime o) => year == o.year && month == o.month && day == o.day;
}
