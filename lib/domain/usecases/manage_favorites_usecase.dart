import '../../data/models/favorite.dart';
import '../../data/repositories/favorites_repository.dart';

/// Alta/baja y consulta de Favoritos (recetas y cálculos) — apartado 4.10.
class ManageFavoritesUseCase {
  final FavoritesRepository favoritesRepository;

  ManageFavoritesUseCase({required this.favoritesRepository});

  Future<List<Favorite>> getFavorites() => favoritesRepository.getAll();

  Future<bool> isRecipeFavorite(String recipeId) =>
      favoritesRepository.isFavoriteRecipe(recipeId);

  Future<void> toggleRecipe(String recipeId) =>
      favoritesRepository.toggleRecipe(recipeId);

  /// Guarda la receta en Favoritos si aún no lo estaba, sin quitarla si ya
  /// lo estaba — usado por "Guardar receta escalada" (apartado 4.8).
  Future<void> ensureRecipeFavorite(String recipeId) async {
    final alreadySaved = await favoritesRepository.isFavoriteRecipe(recipeId);
    if (!alreadySaved) {
      await favoritesRepository.toggleRecipe(recipeId);
    }
  }

  Future<void> removeFavorite(String favoriteId) =>
      favoritesRepository.remove(favoriteId);

  Future<void> removeCalculationFavorite(String calculationId) =>
      favoritesRepository.removeCalculationFavorite(calculationId);
}
