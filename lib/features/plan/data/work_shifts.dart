import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class WorkShift {
  const WorkShift(this.day, this.hours);

  final String day;
  final String hours;
}

/// Demo shifts until the user enters their own.
final workShiftsProvider = Provider<List<WorkShift>>(
  (ref) => const [WorkShift('Thu', '17:00 – 21:00'), WorkShift('Sat', '09:00 – 15:00')],
);
