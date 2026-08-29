import '../local/ingredients_data.dart';
import '../local/ratios_data.dart';
import '../models/ingredient.dart';
import '../models/ratio.dart';

/// Catálogo de ingredientes y sus ratios — empaquetado en la app, sin
/// backend, tal y como especifica el apartado 1 (alcance del MVP).
class IngredientsRepository {
  List<Ingredient> getIngredients() => kIngredients;

  Ingredient getIngredient(String id) => ingredientById(id);

  Ratio getRatio(String ingredientId) => ratioForIngredient(ingredientId);
}
