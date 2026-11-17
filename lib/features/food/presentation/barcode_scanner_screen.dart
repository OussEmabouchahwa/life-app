import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/food_diary_controller.dart';
import '../data/open_food_facts.dart';
import '../domain/food_models.dart';
import 'widgets/scanned_product_card.dart';

enum _Lookup { idle, loading, found, notFound, offline }

/// Figma 20 · Barcode scanner. Reads EAN codes with the camera (or typed by
/// hand) and looks the product up in Open Food Facts.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final _camera = MobileScannerController(
    formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA],
  );
  _Lookup _state = _Lookup.idle;
  String? _code;
  Food? _food;

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  Future<void> _lookup(String code) async {
    if (code == _code && _state != _Lookup.idle) return;
    setState(() {
      _code = code;
      _state = _Lookup.loading;
    });
    // A food scanned before is already saved: no network needed.
    final known = ref.read(customFoodsProvider).where((f) => f.barcode == code).firstOrNull;
    try {
      final food = known ?? await ref.read(openFoodFactsProvider).lookup(code);
      if (!mounted) return;
      setState(() {
        _food = food;
        _state = food == null ? _Lookup.notFound : _Lookup.found;
      });
    } on Exception {
      if (mounted) setState(() => _state = _Lookup.offline);
    }
  }

  void _addToMeal() {
    final food = _food!;
    final foods = ref.read(customFoodsProvider.notifier);
    if (foods.byId(food.id) == null) foods.save(food);
    context.pushReplacement(Routes.withFood(food.id));
  }

  Future<void> _typeCode() async {
    final code = await showTextInputSheet(context: context, title: 'Barcode number', hint: '6191234567890');
    final digits = code?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length >= 8) await _lookup(digits);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final status = switch (_state) {
      _Lookup.idle => 'Point the camera at a barcode',
      _Lookup.loading => 'Looking up $_code…',
      _Lookup.found => 'Found $_code',
      _Lookup.notFound => 'Unknown product $_code. Create it by hand.',
      _Lookup.offline => 'No connection. Try again or create the food by hand.',
    };

    return AppPage(
      children: [
        const ScreenHeader(eyebrow: 'Food', title: 'Scan barcode', showBack: true),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.dp(AppRadius.lg)),
          child: SizedBox(
            height: context.hp(0.32),
            child: MobileScanner(
              controller: _camera,
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null) _lookup(code);
              },
              errorBuilder: (context, error) => ColoredBox(
                color: c.bgSunken,
                child: Center(
                  child: Padding(
                    padding: context.padAll(16),
                    child: Text(
                      'Camera unavailable. Type the barcode instead.',
                      textAlign: TextAlign.center,
                      style: context.text.body.tint(c.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            if (_state == _Lookup.loading)
              SizedBox.square(
                dimension: context.dp(16),
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            if (_state == _Lookup.loading) const HGap(8),
            Expanded(child: Text(status, style: context.text.body.tint(c.textSecondary))),
          ],
        ),
        if (_state == _Lookup.found && _food != null) ScannedProductCard(food: _food!),
        if (_state == _Lookup.found)
          AppButton(label: 'Add to a meal', icon: AppIcons.plus, onPressed: _addToMeal),
        FormRow(
          children: [
            AppButton(
              label: 'Type the code',
              icon: Icons.keyboard_rounded,
              height: 44,
              variant: AppButtonVariant.outlined,
              onPressed: _typeCode,
            ),
            AppButton(
              label: 'New food',
              icon: AppIcons.plus,
              height: 44,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.push(Routes.foodForm),
            ),
          ],
        ),
        Text(
          'Product data from Open Food Facts (needs internet). Scanned foods are saved for next time.',
          style: context.text.caption.tint(c.textSecondary),
        ),
      ],
    );
  }
}
