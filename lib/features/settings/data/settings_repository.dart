import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(localStoreProvider)),
);

/// Saves [AppSettings] on the device as one JSON document.
class SettingsRepository {
  SettingsRepository(this._store);

  final LocalStore _store;
  static const _key = 'settings_v2';

  AppSettings load() {
    final json = _store.readMap(_key);
    return json == null ? const AppSettings() : AppSettings.fromJson(json);
  }

  Future<void> save(AppSettings s) => _store.writeMap(_key, s.toJson());
}
