// Renders the logo files from the logo widgets.
//
//   flutter test tool/branding/generate_branding_test.dart
//
// Then refresh the launcher icons:
//
//   dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/core/widgets/brand/brand_logo.dart';
import 'package:nizam/core/widgets/brand/logo_mark.dart';

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

void main() {
  final key = GlobalKey();

  setUpAll(() async {
    await _loadFont('Fraunces', ['assets/fonts/Fraunces-SemiBold.ttf']);
    await _loadFont('Manrope', ['assets/fonts/Manrope-Medium.ttf', 'assets/fonts/Manrope-Bold.ttf']);
    Directory('assets/branding').createSync(recursive: true);
    Directory('docs/brand').createSync(recursive: true);
  });

  Future<void> render(WidgetTester tester, String path, Size size, Widget child) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: key,
            child: SizedBox.fromSize(size: size, child: child),
          ),
        ),
      ),
    );
    await tester.pump();
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage();
      return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    });
    File(path).writeAsBytesSync(bytes!);
  }

  testWidgets('app icon (iOS, web, legacy Android)', (t) async {
    await render(t, 'assets/branding/icon.png', const Size(1024, 1024), const LogoMark(size: 1024));
  });

  testWidgets('iOS app icon (square, iOS rounds it)', (t) async {
    await render(
      t,
      'assets/branding/icon_ios.png',
      const Size(1024, 1024),
      const LogoMark(size: 1024, rounded: false),
    );
  });

  testWidgets('Android adaptive icon foreground', (t) async {
    // flutter_launcher_icons insets the foreground by 16 %, and Android crops
    // it to a circle: at 1.2 the ring ends just inside the 66 % safe zone.
    await render(
      t,
      'assets/branding/icon_foreground.png',
      const Size(1024, 1024),
      const LogoMark(size: 1024, background: false, scale: 1.2),
    );
  });

  for (final dark in [false, true]) {
    testWidgets('full logo ${dark ? 'dark' : 'light'}', (t) async {
      await render(
        t,
        'docs/brand/logo_${dark ? 'dark' : 'light'}.png',
        const Size(1600, 480),
        ColoredBox(
          color: dark ? const Color(0xFF121714) : const Color(0xFFF2ECE0),
          child: const Center(child: BrandLogo(markSize: 220)),
        ),
      );
    });
  }

  testWidgets('icon at launcher sizes (legibility check)', (t) async {
    await render(
      t,
      'docs/brand/icon_sizes.png',
      const Size(560, 200),
      ColoredBox(
        color: const Color(0xFFE8E0CF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final s in [144.0, 96.0, 72.0, 48.0]) LogoMark(size: s),
          ],
        ),
      ),
    );
  });
}
