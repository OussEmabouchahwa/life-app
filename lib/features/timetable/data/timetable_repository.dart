import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/class_session.dart';
import 'timetable_parser.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) => const AssetTimetableRepository());

/// Where the class timetable comes from. Today: the JSON bundled with the
/// app. Later: an import from the faculty website, behind the same interface.
abstract interface class TimetableRepository {
  Future<List<ClassSession>> sessions();
}

class AssetTimetableRepository implements TimetableRepository {
  const AssetTimetableRepository({this.path = 'assets/data/timetable.json'});

  final String path;

  @override
  Future<List<ClassSession>> sessions() async => TimetableParser.parse(await rootBundle.loadString(path));
}
