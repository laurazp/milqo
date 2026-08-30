import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';

/// Sanidad del catálogo empaquetado en `assets/data/*.json` — no comprueba
/// contenido pantalla a pantalla, pero atrapa el tipo de error que rompería
/// la app entera al arrancar: un id mal escrito, una receta huérfana, un
/// ingrediente sin ratio o sin entrada en la tabla de conversión.
void main() {
  setUpAll(() async {
    // Needed by AppDataStore.load(), which reads assets via rootBundle —
    // that requires a Flutter binding, which plain test() (unlike
    // testWidgets()) doesn't set up automatically.
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppDataStore.instance.load();
  });

  test('hay exactamente 5 ingredientes, 5 ratios y 5 entradas de conversión', () {
    expect(AppDataStore.instance.ingredients.length, 5);
    expect(AppDataStore.instance.ratios.length, 5);
    expect(AppDataStore.instance.conversionEntries.length, 5);
  });

  test('hay exactamente 20 recetas, 4 por ingrediente', () {
    final recipes = AppDataStore.instance.recipes;
    expect(recipes.length, 20);

    final ingredientIds = AppDataStore.instance.ingredients.map((i) => i.id).toSet();
    for (final id in ingredientIds) {
      expect(
        recipes.where((r) => r.ingredientId == id).length,
        4,
        reason: 'el ingrediente "$id" debería tener 4 recetas',
      );
    }
  });

  test('cada ratio referencia un ingrediente real y tiene un gramosBase positivo', () {
    final ingredientIds = AppDataStore.instance.ingredients.map((i) => i.id).toSet();

    for (final ratio in AppDataStore.instance.ratios) {
      expect(ingredientIds.contains(ratio.ingredientId), isTrue,
          reason: 'ratio "${ratio.ratioId}" referencia un ingrediente inexistente');
      expect(ratio.gramosBase, greaterThan(0));
      expect(ratio.fuentes, isNotEmpty);
    }
  });

  test('cada entrada de conversión referencia un ingrediente real', () {
    final ingredientIds = AppDataStore.instance.ingredients.map((i) => i.id).toSet();

    for (final entry in AppDataStore.instance.conversionEntries) {
      expect(ingredientIds.contains(entry.ingredientId), isTrue);
      expect(entry.gramosPorTaza, greaterThan(0));
      expect(entry.gramosPorCucharada, greaterThan(0));
    }
  });

  test('cada receta referencia un ingrediente real y tiene contenido completo', () {
    final ingredientIds = AppDataStore.instance.ingredients.map((i) => i.id).toSet();

    for (final recipe in AppDataStore.instance.recipes) {
      expect(ingredientIds.contains(recipe.ingredientId), isTrue,
          reason: 'receta "${recipe.id}" referencia un ingrediente inexistente');
      expect(recipe.ingredientes, isNotEmpty);
      expect(recipe.pasos, isNotEmpty);
      expect(recipe.fuentesNombres, isNotEmpty);
    }
  });

  test('la fuente de cada receta es una URL http(s) bien formada', () {
    // Comprobación estructural, no de alcanzabilidad: el checklist de
    // lanzamiento (apartado 9) pide comprobar que los enlaces funcionan de
    // verdad, lo cual requiere red y es responsabilidad de una revisión
    // manual o un job de CI aparte.
    for (final recipe in AppDataStore.instance.recipes) {
      final uri = Uri.tryParse(recipe.fuenteUrl);
      expect(uri, isNotNull, reason: '"${recipe.fuenteUrl}" no es una URL válida');
      expect(uri!.scheme, startsWith('http'));
    }

    for (final ratio in AppDataStore.instance.ratios) {
      for (final fuente in ratio.fuentes) {
        final uri = Uri.tryParse(fuente.url);
        expect(uri, isNotNull, reason: '"${fuente.url}" no es una URL válida');
        expect(uri!.scheme, startsWith('http'));
      }
    }
  });

  test('los ids de ingrediente, ratio y receta son únicos', () {
    final ingredientIds = AppDataStore.instance.ingredients.map((i) => i.id).toList();
    final ratioIds = AppDataStore.instance.ratios.map((r) => r.ratioId).toList();
    final recipeIds = AppDataStore.instance.recipes.map((r) => r.id).toList();

    expect(ingredientIds.toSet().length, ingredientIds.length);
    expect(ratioIds.toSet().length, ratioIds.length);
    expect(recipeIds.toSet().length, recipeIds.length);
  });
}
