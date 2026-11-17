import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/food_models.dart';

final openFoodFactsProvider = Provider<OpenFoodFacts>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return OpenFoodFacts(client);
});

/// Product lookup in the free Open Food Facts database (needs internet).
class OpenFoodFacts {
  OpenFoodFacts(this._client);

  final http.Client _client;

  /// Null when the product is unknown or has no calorie value.
  /// Throws on network errors so the screen can say "you are offline".
  Future<Food?> lookup(String barcode) async {
    final uri = Uri.https('world.openfoodfacts.org', '/api/v2/product/$barcode.json', {
      'fields': 'product_name,brands,nutriments,serving_quantity,serving_size',
    });
    final res = await _client
        .get(uri, headers: const {'User-Agent': 'Nizam-Flutter/1.0'})
        .timeout(const Duration(seconds: 10));
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) throw http.ClientException('HTTP ${res.statusCode}', uri);
    return parse(barcode, jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Visible for tests.
  static Food? parse(String barcode, Map<String, dynamic> json) {
    if (json['status'] != 1) return null;
    final p = json['product'] as Map<String, dynamic>? ?? const {};
    final n = p['nutriments'] as Map<String, dynamic>? ?? const {};
    double? value(String k) => (n[k] as num?)?.toDouble();

    final kcal =
        value('energy-kcal_100g') ?? (value('energy_100g') == null ? null : value('energy_100g')! / 4.184);
    if (kcal == null) return null;
    final name = (p['product_name'] as String?)?.trim();
    final brand = (p['brands'] as String?)?.split(',').first.trim();
    final serving = (p['serving_quantity'] as num?)?.toDouble();

    return Food(
      id: 'scan-$barcode',
      name: [if (name != null && name.isNotEmpty) name else 'Product $barcode', ?brand].join(' · '),
      per100g: Macros(
        kcal: kcal,
        protein: value('proteins_100g') ?? 0,
        carbs: value('carbohydrates_100g') ?? 0,
        fat: value('fat_100g') ?? 0,
      ),
      portionLabel: serving == null ? null : (p['serving_size'] as String? ?? '1 serving'),
      portionGrams: serving,
      barcode: barcode,
      custom: true,
    );
  }
}
