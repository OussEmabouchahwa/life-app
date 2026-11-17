import 'package:flutter/foundation.dart';

import '../../../core/storage/stored_list_controller.dart';

/// Something to hand in or do before a deadline (Figma 21 · Tasks).
@immutable
class Task implements Stored {
  const Task({
    required this.id,
    required this.title,
    required this.due,
    this.courseCode,
    this.notes = '',
    this.done = false,
  });

  @override
  final String id;
  final String title;
  final DateTime due;
  final String? courseCode;
  final String notes;
  final bool done;

  Task copyWith({bool? done}) =>
      Task(id: id, title: title, due: due, courseCode: courseCode, notes: notes, done: done ?? this.done);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'due': Json.date(due),
    'courseCode': courseCode,
    'notes': notes,
    'done': done,
  };

  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'] as String,
    title: j['title'] as String,
    due: Json.toDate(j['due']),
    courseCode: j['courseCode'] as String?,
    notes: j['notes'] as String? ?? '',
    done: j['done'] as bool? ?? false,
  );
}

class TasksController extends StoredListController<Task> {
  @override
  String get storageKey => 'tasks_v1';

  @override
  Task fromJson(Map<String, dynamic> json) => Task.fromJson(json);

  void toggle(String id) {
    final t = byId(id);
    if (t != null) save(t.copyWith(done: !t.done));
  }
}
