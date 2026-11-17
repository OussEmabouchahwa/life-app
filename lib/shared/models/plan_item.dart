import 'package:flutter/foundation.dart';

import '../../core/storage/stored_list_controller.dart';
import 'event_category.dart';

/// One block of the day: a class, a gym session, a commute…
///
/// Items the user adds are saved; generated ones (classes, exams, gym days,
/// work shifts, commutes) are rebuilt from their source each time.
@immutable
class PlanItem implements Stored {
  const PlanItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.start,
    required this.duration,
    required this.category,
    this.done = false,
    this.courseCode,
    this.editable = false,
    this.route,
  });

  @override
  final String id;
  final String title;

  /// Free text after the category: "Prof. Ben Salah · Room B12".
  final String detail;
  final DateTime start;
  final Duration duration;
  final EventCategory category;
  final bool done;

  /// Course this item is about (revision sessions count towards its goal).
  final String? courseCode;

  /// True for events the user created (they can edit or delete them).
  final bool editable;

  /// Screen that opens when the item is tapped (not saved).
  final String? route;

  DateTime get end => start.add(duration);

  /// "Class · Prof. Ben Salah · Room B12"
  String get subtitle => detail.isEmpty ? category.label : '${category.label} · $detail';

  bool isNow(DateTime now) => !now.isBefore(start) && now.isBefore(end);

  bool overlaps(DateTime from, DateTime to) => start.isBefore(to) && end.isAfter(from);

  PlanItem copyWith({bool? done, DateTime? start, bool? editable, String? route}) => PlanItem(
    id: id,
    title: title,
    detail: detail,
    start: start ?? this.start,
    duration: duration,
    category: category,
    done: done ?? this.done,
    courseCode: courseCode,
    editable: editable ?? this.editable,
    route: route ?? this.route,
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'detail': detail,
    'start': Json.date(start),
    'minutes': duration.inMinutes,
    'category': category.name,
    'courseCode': courseCode,
  };

  factory PlanItem.fromJson(Map<String, dynamic> j) => PlanItem(
    id: j['id'] as String,
    title: j['title'] as String,
    detail: j['detail'] as String? ?? '',
    start: Json.toDate(j['start']),
    duration: Duration(minutes: j['minutes'] as int),
    category: EventCategory.values.byName(j['category'] as String),
    courseCode: j['courseCode'] as String?,
    editable: true,
  );
}
