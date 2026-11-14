import 'package:flutter/foundation.dart';

/// Type of session, derived from the course code and title.
enum SessionKind {
  /// Regular course (Cours).
  lecture('Cours'),

  /// Practical work: "TP …", "Mini projet".
  practical('TP'),

  /// Transversal module GINF.35-x: languages, law.
  transversal('Langues & droit');

  const SessionKind(this.label);
  final String label;
}

/// One class from the faculty timetable.
@immutable
class ClassSession {
  const ClassSession({
    required this.code,
    required this.title,
    required this.shortName,
    required this.professor,
    required this.start,
    required this.end,
    required this.kind,
    this.room,
  });

  /// "GINF.33-2"
  final String code;

  /// "Développement mobile Android et Flutter"
  final String title;

  /// Fits in a timetable cell: "Flutter".
  final String shortName;
  final String professor;
  final DateTime start;
  final DateTime end;
  final SessionKind kind;

  /// "Salle TP 7-3", or null when the faculty has not set one yet.
  final String? room;

  Duration get duration => end.difference(start);

  /// "TP 7-3" (drops the "Salle" prefix to fit small cells).
  String? get roomShort => room?.replaceFirst(RegExp(r'^Salle\s+'), '');

  String get id => 'class-${start.toIso8601String()}-$code';
}
