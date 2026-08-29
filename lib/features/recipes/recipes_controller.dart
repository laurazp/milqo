import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/favorite.dart';
import '../favorites/favorites_refresh_trigger.dart';

/// Catálogo de recetas con buscador y filtro por ingrediente — apartado 4.6.
class RecipesState {
  final String query;
  final String? ingredientFilter;
  final Set<String> favoriteRecipeIds;

  const RecipesState({
    this.query = '',
    this.ingredientFilter,
    required this.favoriteRecipeIds,
  });

  RecipesState copyWith({
    String? query,
    String? ingredientFilter,
    bool clearIngredientFilter = false,
    Set<String>? favoriteRecipeIds,
  }) {
    return RecipesState(
      query: query ?? this.query,
      ingredientFilter: clearIngredientFilter ? null : (ingredientFilter ?? this.ingredientFilter),
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
    );
  }
}

class RecipesController extends AsyncNotifier<RecipesState> {
  @override
  Future<RecipesState> build() async {
    final favorites = await ref.read(manageFavoritesUseCaseProvider).getFavorites();
    final ids = favorites
        .where((f) => f.tipo == FavoriteType.receta)
        .map((f) => f.referenciaId)
        .toSet();
    return RecipesState(favoriteRecipeIds: ids);
  }

  void setQuery(String query) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(query: query));
  }

  void setIngredientFilter(String? ingredientId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      ingredientFilter: ingredientId,
      clearIngredientFilter: ingredientId == null,
    ));
  }

  Future<void> toggleFavorite(String recipeId) async {
    final current = state.value;
    if (current == null) return;
    await ref.read(manageFavoritesUseCaseProvider).toggleRecipe(recipeId);
    final ids = Set<String>.from(current.favoriteRecipeIds);
    if (!ids.remove(recipeId)) ids.add(recipeId);
    state = AsyncData(current.copyWith(favoriteRecipeIds: ids));
    ref.read(favoritesRefreshTriggerProvider.notifier).bump();
  }
}

final recipesControllerProvider =
    AsyncNotifierProvider<RecipesController, RecipesState>(RecipesController.new);
