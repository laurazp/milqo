import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../favorites/favorites_refresh_trigger.dart';

/// Si la receta con la que se creó esta instancia está guardada en
/// Favoritos — apartado 4.7, botón "Guardar" (corazón). El id se recibe por
/// el constructor: en Riverpod 3.x el argumento de una familia se pasa a
/// `create`, no a `build()`.
class RecipeFavoriteController extends AsyncNotifier<bool> {
  final String recipeId;

  RecipeFavoriteController(this.recipeId);

  @override
  Future<bool> build() {
    return ref.read(manageFavoritesUseCaseProvider).isRecipeFavorite(recipeId);
  }

  Future<void> toggle() async {
    await ref.read(manageFavoritesUseCaseProvider).toggleRecipe(recipeId);
    state = AsyncData(!(state.value ?? false));
    ref.read(favoritesRefreshTriggerProvider.notifier).bump();
  }
}

final recipeFavoriteControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RecipeFavoriteController, bool, String>(RecipeFavoriteController.new);
