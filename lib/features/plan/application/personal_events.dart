import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/stored_list_controller.dart';
import '../../../shared/models/plan_item.dart';

/// Events the user added (revision sessions, appointments…). Saved on the device.
final personalEventsProvider = NotifierProvider<PersonalEventsController, List<PlanItem>>(
  PersonalEventsController.new,
);

class PersonalEventsController extends StoredListController<PlanItem> {
  @override
  String get storageKey => 'events_v1';

  @override
  PlanItem fromJson(Map<String, dynamic> json) => PlanItem.fromJson(json);
}

/// Ids the user ticked as done, for any kind of item (classes included).
final completedItemsProvider = NotifierProvider<CompletedItems, Set<String>>(CompletedItems.new);

class CompletedItems extends Notifier<Set<String>> {
  static const _key = 'completed_v1';

  @override
  Set<String> build() => {...?ref.read(sharedPreferencesProvider).getStringList(_key)};

  void toggle(String id) {
    state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
    ref.read(sharedPreferencesProvider).setStringList(_key, state.toList());
  }
}
