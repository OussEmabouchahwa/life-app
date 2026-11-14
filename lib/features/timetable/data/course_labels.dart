/// Readable names for the course codes of the timetable.
///
/// The official titles are long ("Analyse et conception des interfaces
/// utilisateurs (UX/UI & IHM)"). Lists use [name], timetable cells use [short].
/// A code missing here falls back to the official title and its initials.
typedef CourseLabel = ({String short, String name});

abstract final class CourseLabels {
  static const _labels = <String, CourseLabel>{
    'GINF.31-1': (short: 'Prog', name: 'Programmation avancée'),
    'GINF.31-2': (short: 'IoT', name: 'Développement système IoT'),
    'GINF.31-3': (short: 'TP Prog', name: 'TP Programmation avancée'),
    'GINF.32-1': (short: 'GL', name: 'Génie logiciel'),
    'GINF.32-2': (short: 'BPM', name: 'Processus & BPM'),
    'GINF.32-3': (short: 'Design', name: 'Patrons de conception'),
    'GINF.33-1': (short: 'UX/UI', name: 'UX/UI & IHM'),
    'GINF.33-2': (short: 'Flutter', name: 'Mobile Android & Flutter'),
    'GINF.33-3': (short: 'Angular', name: 'Web avec Angular'),
    'GINF.34-1': (short: 'Linux', name: 'Administration Linux'),
    'GINF.34-2': (short: 'Projet', name: 'TP Mini projet 1'),
    'GINF.35-1': (short: 'Anglais', name: 'Anglais 1'),
    'GINF.35-2': (short: 'Français', name: 'Français'),
    'GINF.35-3': (short: 'Droit', name: 'Droit'),
  };

  static CourseLabel of(String code, String title) => _labels[code] ?? (short: _initials(title), name: title);

  static String _initials(String title) =>
      title.split(RegExp(r'\s+')).where((w) => w.length > 3).take(3).map((w) => w[0].toUpperCase()).join();
}
