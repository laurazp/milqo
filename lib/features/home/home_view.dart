import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../recipes/recipes_search_focus_provider.dart';
import 'widgets/featured_recipe_card.dart';
import 'widgets/quick_ingredient_icon.dart';

/// Punto de entrada a la app — apartado 4.1.
const _featuredRecipeIds = ['almendra_clasica', 'pistacho_cardamomo_azahar', 'anacardo_cremoso'];

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesRepository = ref.watch(recipesRepositoryProvider);
    final featured = _featuredRecipeIds.map(recipesRepository.getById).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist_rounded, color: AppColors.sageGreen),
            const SizedBox(width: Dimens.smallMargin),
            const Text('Milqo'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(AppConstants.converterIcon),
            tooltip: 'Conversor de unidades',
            onPressed: () => context.push(AppRoutes.converter),
          ),
          IconButton(
            icon: const Icon(AppConstants.searchIcon),
            tooltip: 'Buscar recetas',
            onPressed: () {
              ref.read(recipesSearchFocusRequestProvider.notifier).bump();
              context.go(AppRoutes.recipesTab);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Dimens.largeMargin,
          Dimens.smallMargin,
          Dimens.largeMargin,
          Dimens.hugeMargin,
        ),
        children: [
          Text('Hola de nuevo', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text(
            '¿Qué bebida vegetal preparamos hoy?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: Dimens.largeMargin),
          _PrepareDrinkCard(onTap: () => context.push(AppRoutes.selection)),
          const SizedBox(height: Dimens.largeMargin),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kIngredients.length,
              separatorBuilder: (_, __) => const SizedBox(width: Dimens.smallMargin),
              itemBuilder: (context, i) {
                final ingredient = kIngredients[i];
                return QuickIngredientIcon(
                  ingredient: ingredient,
                  onTap: () => context.push(AppRoutes.calculatorFor(ingredient.id)),
                );
              },
            ),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recetas destacadas', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => context.go(AppRoutes.recipesTab),
                child: const Text('Ver todas'),
              ),
            ],
          ),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: Dimens.smallMargin),
              itemBuilder: (context, i) {
                final recipe = featured[i];
                return FeaturedRecipeCard(
                  recipe: recipe,
                  onTap: () => context.push(AppRoutes.recipeDetail(recipe.id)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PrepareDrinkCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PrepareDrinkCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.sageGreen,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
        child: const Padding(
          padding: EdgeInsets.all(Dimens.largeMargin),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preparar una bebida',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Elige un ingrediente y calcula tu receta',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
