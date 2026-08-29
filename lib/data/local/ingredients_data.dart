import '../models/ingredient.dart';
import 'app_data_store.dart';

/// Catálogo de los 5 ingredientes del MVP — apartado 6 de la especificación,
/// cargado desde `assets/data/ingredients.json` (ver [AppDataStore]).
List<Ingredient> get kIngredients => AppDataStore.instance.ingredients;

Ingredient ingredientById(String id) =>
    kIngredients.firstWhere((i) => i.id == id);
