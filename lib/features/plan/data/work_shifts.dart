import 'package:flutter/foundation.dart';

import '../../../core/storage/stored_list_controller.dart';
import '../../../core/utils/time_format.dart';

/// A weekly work shift (repeats every week on [weekday]).
@immutable
class WorkShift implements Stored {
  const WorkShift({
    required this.id,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.place = '',
  });

  static const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  final String id;

  /// DateTime.monday … DateTime.sunday
  final int weekday;
  final int startMinutes;

  /// May be smaller than [startMinutes] for a shift past midnight.
  final int endMinutes;
  final String place;

  int get lengthMinutes => (endMinutes - startMinutes) % (24 * 60);
  String get dayName => dayNames[weekday - 1];
  String get hours => '${TimeFormat.minutes(startMinutes)} – ${TimeFormat.minutes(endMinutes)}';

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'weekday': weekday,
    'start': startMinutes,
    'end': endMinutes,
    'place': place,
  };

  factory WorkShift.fromJson(Map<String, dynamic> j) => WorkShift(
    id: j['id'] as String,
    weekday: j['weekday'] as int,
    startMinutes: j['start'] as int,
    endMinutes: j['end'] as int,
    place: j['place'] as String? ?? '',
  );
}

class WorkShiftsController extends StoredListController<WorkShift> {
  @override
  String get storageKey => 'work_shifts_v1';

  @override
  WorkShift fromJson(Map<String, dynamic> json) => WorkShift.fromJson(json);
}
