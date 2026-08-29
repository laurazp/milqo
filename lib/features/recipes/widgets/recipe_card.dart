import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/dimens.dart';
import '../../../data/local/ingredients_data.dart';
import '../../../data/models/recipe.dart';
import '../../../widgets/ingredient_badge.dart';

/// Tarjeta de receta reutilizada en Recetas y Favoritos — apartados 4.6/4.10.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final ingredient = ingredientById(recipe.ingredientId);

    return Card(
      margin: const EdgeInsets.only(bottom: Dimens.smallMargin),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.mediumMargin),
          child: Row(
            children: [
              IngredientBadge(ingredient: ingredient),
              const SizedBox(width: Dimens.mediumMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      '${ingredient.nombre} · ${recipe.tiempoRemojo == '-' ? recipe.tiempoPreparacion : recipe.tiempoRemojo}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? AppConstants.favoritesIcon : AppConstants.favoritesOutlineIcon,
                  color: isFavorite ? AppColors.favoriteCoral : AppColors.textSecondary,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
