import 'package:flutter/foundation.dart';

import 'event_category.dart';

/// One block of the day: a class, a gym session, a commute…
@immutable
class PlanItem {
  const PlanItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.start,
    required this.duration,
    required this.category,
    this.done = false,
  });

  final String id;
  final String title;

  /// Free text after the category: "Prof. Ben Salah · Room B12".
  final String detail;
  final DateTime start;
  final Duration duration;
  final EventCategory category;
  final bool done;

  DateTime get end => start.add(duration);

  /// "Class · Prof. Ben Salah · Room B12"
  String get subtitle => '${category.label} · $detail';

  bool isNow(DateTime now) => !now.isBefore(start) && now.isBefore(end);

  bool overlaps(DateTime from, DateTime to) => start.isBefore(to) && end.isAfter(from);

  PlanItem copyWith({bool? done, DateTime? start}) => PlanItem(
    id: id,
    title: title,
    detail: detail,
    start: start ?? this.start,
    duration: duration,
    category: category,
    done: done ?? this.done,
  );
}
