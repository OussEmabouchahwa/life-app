import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provided in `main.dart` once SharedPreferences is loaded.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

final localStoreProvider = Provider<LocalStore>((ref) => LocalStore(ref.watch(sharedPreferencesProvider)));

/// JSON documents saved on the device. Everything works offline.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  /// Null when nothing was ever saved under [key] (lets callers seed defaults).
  List<Map<String, dynamic>>? readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } on FormatException {
      return null;
    }
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> items) =>
      _prefs.setString(key, jsonEncode(items));

  Map<String, dynamic>? readMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) => _prefs.setString(key, jsonEncode(value));
}
