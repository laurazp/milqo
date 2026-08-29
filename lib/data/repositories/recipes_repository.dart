import '../local/recipes_data.dart';
import '../models/recipe.dart';

/// Catálogo de recetas — apartado 4.6. El buscador es una coincidencia de
/// texto simple, sin backend ni IA (apartado 4.6, notas).
class RecipesRepository {
  List<Recipe> getAll() => kRecipes;

  Recipe getById(String id) => recipeById(id);

  Recipe classicFor(String ingredientId) =>
      classicRecipeForIngredient(ingredientId);

  List<Recipe> search({String? query, String? ingredientId}) {
    var results = kRecipes.toList();
    if (ingredientId != null) {
      results = results.where((r) => r.ingredientId == ingredientId).toList();
    }
    final needle = query?.trim().toLowerCase();
    if (needle != null && needle.isNotEmpty) {
      results = results
          .where((r) =>
              r.nombre.toLowerCase().contains(needle) ||
              r.ingredientId.toLowerCase().contains(needle))
          .toList();
    }
    return results;
  }
}
