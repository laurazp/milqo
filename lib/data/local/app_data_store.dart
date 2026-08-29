import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/conversion_entry.dart';
import '../models/ingredient.dart';
import '../models/ratio.dart';
import '../models/recipe.dart';
import 'ingredient_icons.dart';

/// Carga una vez, al arrancar la app, el catálogo empaquetado en
/// `assets/data/*.json` (ingredientes, ratios, recetas, tabla de
/// conversión) — apartado 1: "todo puede funcionar con datos empaquetados
/// en la propia app". El resto de la app sigue leyendo estas listas de
/// forma síncrona a través de los repositorios, igual que cuando eran
/// constantes de Dart; solo cambia de dónde viene el contenido.
class AppDataStore {
  AppDataStore._();

  static final instance = AppDataStore._();

  late final List<Ingredient> ingredients;
  late final List<Ratio> ratios;
  late final List<Recipe> recipes;
  late final List<ConversionEntry> conversionEntries;

  Future<void> load() async {
    final ingredientsJson = await _loadJsonList('assets/data/ingredients.json');
    ingredients = ingredientsJson
        .map((json) => Ingredient.fromJson(json, icon: kIngredientIcons[json['id']]!))
        .toList();

    final ratiosJson = await _loadJsonList('assets/data/ratios.json');
    ratios = ratiosJson.map(Ratio.fromJson).toList();

    final recipesJson = await _loadJsonList('assets/data/recipes.json');
    recipes = recipesJson.map(Recipe.fromJson).toList();

    final conversionJson = await _loadJsonList('assets/data/conversion.json');
    conversionEntries = conversionJson.map(ConversionEntry.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> _loadJsonList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }
}
