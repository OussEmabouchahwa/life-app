import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/app/app.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:nizam/features/settings/application/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('a fresh install goes through the 3 steps and lands on Today', (tester) async {
    tester.view.physicalSize = const Size(390, 844) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const NizamApp()));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Welcome to Nizam'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('About you'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Oussema');

    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Your semester'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("Today's plan"), findsOneWidget);

    final settings = container.read(settingsProvider);
    expect(settings.onboarded, isTrue);
    expect(settings.userName, 'Oussema');
    expect(prefs.getString('settings_v2'), contains('"onboarded":true'), reason: 'saved on the phone');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
