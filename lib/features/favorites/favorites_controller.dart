import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/favorite.dart';
import '../../data/models/recipe.dart';
import '../../data/models/saved_calculation.dart';
import 'favorites_refresh_trigger.dart';

/// Recetas guardadas y cálculos guardados — apartado 4.10. Almacenamiento
/// local en la v1, sin cuenta de usuario.
class FavoritesState {
  final List<Recipe> savedRecipes;
  final List<SavedCalculation> savedCalculations;

  const FavoritesState({required this.savedRecipes, required this.savedCalculations});
}

class FavoritesController extends AsyncNotifier<FavoritesState> {
  @override
  Future<FavoritesState> build() {
    // Rebuilds whenever another screen bumps this, since Favoritos' branch
    // Navigator stays mounted in the background and won't otherwise notice.
    ref.watch(favoritesRefreshTriggerProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<FavoritesState> _load() async {
    final favorites = await ref.read(manageFavoritesUseCaseProvider).getFavorites();
    final recipeIds =
        favorites.where((f) => f.tipo == FavoriteType.receta).map((f) => f.referenciaId);
    final recipesRepository = ref.read(recipesRepositoryProvider);
    final savedRecipes = recipeIds.map(recipesRepository.getById).toList();
    final savedCalculations = await ref.read(calculationsRepositoryProvider).getAll();
    return FavoritesState(savedRecipes: savedRecipes, savedCalculations: savedCalculations);
  }

  Future<void> removeRecipe(String recipeId) async {
    await ref.read(manageFavoritesUseCaseProvider).toggleRecipe(recipeId);
    await refresh();
  }

  Future<void> removeCalculation(String calculationId) async {
    await ref.read(calculationsRepositoryProvider).remove(calculationId);
    await ref.read(manageFavoritesUseCaseProvider).removeCalculationFavorite(calculationId);
    await refresh();
  }
}

final favoritesControllerProvider =
    AsyncNotifierProvider<FavoritesController, FavoritesState>(FavoritesController.new);
