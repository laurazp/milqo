import '../models/recipe.dart';
import 'app_data_store.dart';

/// Base de datos de recetas (4 por ingrediente, 20 en total) — apartado 8 de
/// la especificación, cargada desde `assets/data/recipes.json` (ver
/// [AppDataStore]). Normalizadas a gramos y mililitros a partir de recetas
/// publicadas con buena valoración (ver fuentes en el apartado 6).
List<Recipe> get kRecipes => AppDataStore.instance.recipes;

Recipe recipeById(String id) => kRecipes.firstWhere((r) => r.id == id);

List<Recipe> recipesForIngredient(String ingredientId) =>
    kRecipes.where((r) => r.ingredientId == ingredientId).toList();

/// Receta "clásica" de un ingrediente — la que abre "Ver receta relacionada"
/// desde el Resultado (apartado 4.5).
Recipe classicRecipeForIngredient(String ingredientId) =>
    recipesForIngredient(ingredientId).first;
