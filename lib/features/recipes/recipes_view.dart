import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design/dimens.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../../data/models/recipe.dart';
import '../../widgets/empty_state.dart';
import 'recipes_controller.dart';
import 'recipes_search_focus_provider.dart';
import 'widgets/recipe_card.dart';

/// Explorar el catálogo completo de recetas (20 en la v1) con filtro por
/// ingrediente y buscador — apartado 4.6.
class RecipesView extends ConsumerStatefulWidget {
  const RecipesView({super.key});

  @override
  ConsumerState<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends ConsumerState<RecipesView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Home's search icon bumps this counter and navigates here — react by
    // focusing the search field, even if Recetas is already the active tab.
    ref.listen(recipesSearchFocusRequestProvider, (previous, next) {
      if (previous != null && next != previous) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _searchFocusNode.requestFocus();
        });
      }
    });

    final recipesState = ref.watch(recipesControllerProvider);
    final controller = ref.read(recipesControllerProvider.notifier);
    final state = recipesState.value;
    final List<Recipe> recipes = state == null
        ? const []
        : ref
            .watch(recipesRepositoryProvider)
            .search(query: state.query, ingredientId: state.ingredientFilter);

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.largeMargin,
              Dimens.smallMargin,
              Dimens.largeMargin,
              Dimens.smallMargin,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: controller.setQuery,
              decoration: const InputDecoration(
                hintText: 'Buscar receta o ingrediente',
                prefixIcon: Icon(AppConstants.searchIcon),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.largeMargin),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimens.smallMargin),
                  child: ChoiceChip(
                    label: const Text('Todas'),
                    selected: state?.ingredientFilter == null,
                    onSelected: (_) => controller.setIngredientFilter(null),
                  ),
                ),
                for (final ingredient in kIngredients)
                  Padding(
                    padding: const EdgeInsets.only(right: Dimens.smallMargin),
                    child: ChoiceChip(
                      label: Text(ingredient.nombre),
                      selected: state?.ingredientFilter == ingredient.id,
                      onSelected: (_) => controller.setIngredientFilter(ingredient.id),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Dimens.smallMargin),
          Expanded(
            child: recipes.isEmpty
                ? const EmptyState(
                    icon: AppConstants.searchIcon,
                    message: 'No hay recetas que coincidan con tu búsqueda.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      Dimens.largeMargin,
                      0,
                      Dimens.largeMargin,
                      Dimens.hugeMargin,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, i) {
                      final recipe = recipes[i];
                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: state!.favoriteRecipeIds.contains(recipe.id),
                        onToggleFavorite: () => controller.toggleFavorite(recipe.id),
                        onTap: () => context.push('/recipes/${recipe.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
