import 'dart:convert';

import '../domain/class_session.dart';
import 'course_labels.dart';

/// Turns the faculty export ("Tous les mois" JSON) into [ClassSession]s.
///
/// Expected entry:
/// ```json
/// {"jour": "Lundi", "date": "14/09/2026", "creneau": "S1 : 8:30 à 11:45",
///  "ecue": "GINF.31-1 Introduction à …", "professeur": "…", "salle": "-"}
/// ```
/// Entries that cannot be read are skipped instead of breaking the whole file.
abstract final class TimetableParser {
  static final _slot = RegExp(r'(\d{1,2}):(\d{2})\s*à\s*(\d{1,2}):(\d{2})');
  static final _date = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');
  static final _ecue = RegExp(r'^(\S+)\s*:?\s*(.+)$');

  static List<ClassSession> parse(String source) {
    final raw = jsonDecode(source) as List<dynamic>;
    return raw.whereType<Map<String, dynamic>>().map(_session).nonNulls.toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  static ClassSession? _session(Map<String, dynamic> e) {
    final date = _date.firstMatch('${e['date'] ?? ''}'.trim());
    final slot = _slot.firstMatch('${e['creneau'] ?? ''}');
    final ecue = _ecue.firstMatch('${e['ecue'] ?? ''}'.trim());
    if (date == null || slot == null || ecue == null) return null;

    int g(RegExpMatch m, int i) => int.parse(m.group(i)!);
    DateTime at(int h, int min) => DateTime(g(date, 3), g(date, 2), g(date, 1), h, min);

    final code = ecue.group(1)!;
    final title = _capitalize(ecue.group(2)!.trim());
    final label = CourseLabels.of(code, title);
    final room = '${e['salle'] ?? ''}'.trim();

    return ClassSession(
      code: code,
      title: label.name,
      shortName: label.short,
      professor: '${e['professeur'] ?? ''}'.trim(),
      start: at(g(slot, 1), g(slot, 2)),
      end: at(g(slot, 3), g(slot, 4)),
      kind: _kind(code, title),
      room: room.isEmpty || room == '-' ? null : room,
    );
  }

  static SessionKind _kind(String code, String title) {
    if (code.contains('.35-')) return SessionKind.transversal;
    final t = title.toLowerCase();
    if (t.startsWith('tp') || t.contains('mini projet')) return SessionKind.practical;
    return SessionKind.lecture;
  }

  static String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
