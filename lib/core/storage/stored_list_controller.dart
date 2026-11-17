import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_store.dart';

/// A record that can be saved in a [StoredListController].
abstract interface class Stored {
  String get id;
  Map<String, dynamic> toJson();
}

final _random = Random();

/// Short unique id for new records.
String newId() =>
    '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}${_random.nextInt(1 << 20).toRadixString(36)}';

/// Base controller for every user-editable list (exams, workouts, shifts…).
///
/// Subclasses only say where to save and how to read one record; adding,
/// editing, deleting and saving to the device are shared here.
abstract class StoredListController<T extends Stored> extends Notifier<List<T>> {
  /// Key in local storage. Bump the suffix when the JSON shape changes.
  String get storageKey;

  T fromJson(Map<String, dynamic> json);

  /// Content on first launch, before the user saved anything.
  List<T> get seed => const [];

  late LocalStore _store;

  @override
  List<T> build() {
    _store = ref.watch(localStoreProvider);
    final saved = _store.readList(storageKey);
    if (saved == null) return seed;
    final items = <T>[];
    for (final json in saved) {
      try {
        items.add(fromJson(json));
      } on Object {
        // Skip a record that no longer matches the model instead of losing everything.
      }
    }
    return items;
  }

  /// Adds [item], or replaces the record with the same id.
  void save(T item) {
    final i = state.indexWhere((e) => e.id == item.id);
    state = i < 0 ? [...state, item] : ([...state]..[i] = item);
    _persist();
  }

  void saveAll(Iterable<T> items) {
    for (final item in items) {
      final i = state.indexWhere((e) => e.id == item.id);
      state = i < 0 ? [...state, item] : ([...state]..[i] = item);
    }
    _persist();
  }

  void remove(String id) {
    state = [
      for (final e in state)
        if (e.id != id) e,
    ];
    _persist();
  }

  T? byId(String id) => state.where((e) => e.id == id).firstOrNull;

  void _persist() => _store.writeList(storageKey, [for (final e in state) e.toJson()]);
}

/// JSON helpers shared by the models.
abstract final class Json {
  static String date(DateTime d) => d.toIso8601String();
  static DateTime toDate(Object? v) => DateTime.parse(v! as String);
  static double toDouble(Object? v) => (v as num?)?.toDouble() ?? 0;
  static double? toDoubleOrNull(Object? v) => (v as num?)?.toDouble();
}
