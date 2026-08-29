import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/recipe.dart';
import '../../data/models/saved_calculation.dart';
import '../../widgets/empty_state.dart';
import '../recipes/widgets/recipe_card.dart';
import '../result/result_view.dart';
import 'favorites_controller.dart';
import 'widgets/calculation_card.dart';

/// Centraliza recetas guardadas y cálculos guardados — apartado 4.10.
/// Almacenamiento local en la v1, sin cuenta de usuario ni sincronización.
class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Recetas guardadas'), Tab(text: 'Cálculos guardados')],
          ),
        ),
        body: switch (favoritesState) {
          AsyncData(:final value) => TabBarView(
              children: [
                _SavedRecipesTab(savedRecipes: value.savedRecipes),
                _SavedCalculationsTab(savedCalculations: value.savedCalculations),
              ],
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _SavedRecipesTab extends ConsumerWidget {
  final List<Recipe> savedRecipes;

  const _SavedRecipesTab({required this.savedRecipes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (savedRecipes.isEmpty) {
      return const EmptyState(
        icon: AppConstants.favoritesOutlineIcon,
        message: 'Aún no has guardado ninguna receta.\nGuarda una desde su detalle para verla aquí.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        Dimens.largeMargin,
        Dimens.smallMargin,
        Dimens.largeMargin,
        Dimens.hugeMargin,
      ),
      itemCount: savedRecipes.length,
      itemBuilder: (context, i) {
        final recipe = savedRecipes[i];
        return RecipeCard(
          recipe: recipe,
          isFavorite: true,
          onToggleFavorite: () => ref.read(favoritesControllerProvider.notifier).removeRecipe(recipe.id),
          onTap: () => context.push(AppRoutes.recipeDetail(recipe.id)),
        );
      },
    );
  }
}

class _SavedCalculationsTab extends ConsumerWidget {
  final List<SavedCalculation> savedCalculations;

  const _SavedCalculationsTab({required this.savedCalculations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (savedCalculations.isEmpty) {
      return const EmptyState(
        icon: AppConstants.calculatorIcon,
        message: 'Aún no has guardado ningún cálculo.\nGuarda uno desde el Resultado para verlo aquí.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        Dimens.largeMargin,
        Dimens.smallMargin,
        Dimens.largeMargin,
        Dimens.hugeMargin,
      ),
      itemCount: savedCalculations.length,
      itemBuilder: (context, i) {
        final calculation = savedCalculations[i];
        return CalculationCard(
          calculation: calculation,
          onRemove: () =>
              ref.read(favoritesControllerProvider.notifier).removeCalculation(calculation.id),
          onTap: () => context.push(
            AppRoutes.result,
            extra: ResultRouteArgs(
              initialSavedId: calculation.id,
              result: CalculationResult(
                ingredientId: calculation.ingredientId,
                modo: calculation.modo,
                valorInput: calculation.valorInput,
                cremosidad: calculation.cremosidad,
                resultadoGramos: calculation.resultadoGramos,
                resultadoMlAgua: calculation.resultadoMlAgua,
                resultadoMlTotal: calculation.resultadoMlTotal,
              ),
            ),
          ),
        );
      },
    );
  }
}
