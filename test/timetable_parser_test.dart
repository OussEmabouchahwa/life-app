import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/features/timetable/data/timetable_parser.dart';
import 'package:nizam/features/timetable/domain/class_session.dart';

void main() {
  final sessions = TimetableParser.parse(File('assets/data/timetable.json').readAsStringSync());

  test('reads every entry of the faculty export', () {
    expect(sessions, hasLength(110));
    expect(sessions.map((s) => s.code).toSet(), hasLength(14));
  });

  test('parses date, slot, labels and room', () {
    final first = sessions.first;
    expect(first.start, DateTime(2026, 9, 14, 8, 30));
    expect(first.end, DateTime(2026, 9, 14, 11, 45));
    expect(first.code, 'GINF.31-1');
    expect(first.title, 'Programmation avancée');
    expect(first.professor, 'Thameur Dhieb');
    expect(first.room, isNull, reason: '"-" means no room yet');

    final angular = sessions.firstWhere((s) => s.room != null);
    expect(angular.room, 'Salle TP 8-3');
    expect(angular.roomShort, 'TP 8-3');
  });

  test('classifies sessions', () {
    SessionKind kindOf(String code) => sessions.firstWhere((s) => s.code == code).kind;
    expect(kindOf('GINF.34-2'), SessionKind.practical);
    expect(kindOf('GINF.31-3'), SessionKind.practical);
    expect(kindOf('GINF.35-3'), SessionKind.transversal);
    expect(kindOf('GINF.33-2'), SessionKind.lecture);
  });

  test('handles the ":Administration" typo and skips broken entries', () {
    expect(sessions.firstWhere((s) => s.code == 'GINF.34-1').title, 'Administration Linux');
    final parsed = TimetableParser.parse(
      '[{"date": "bad"}, {"date": "01/12/2026", "creneau": "S1 : 8:30 à 11:45", '
      '"ecue": "X.1 Nouveau cours", "professeur": "P", "salle": "-"}]',
    );
    expect(parsed.single.title, 'Nouveau cours');
    expect(parsed.single.shortName, 'NC');
  });
}
