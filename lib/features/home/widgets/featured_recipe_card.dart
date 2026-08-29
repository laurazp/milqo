import 'package:flutter/material.dart';

import '../../../core/design/dimens.dart';
import '../../../data/local/ingredients_data.dart';
import '../../../data/models/recipe.dart';
import '../../../widgets/ingredient_badge.dart';

/// Tarjeta de receta destacada en Home — apartado 4.1.
class FeaturedRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const FeaturedRecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ingredient = ingredientById(recipe.ingredientId);

    return SizedBox(
      width: 180,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.mediumMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IngredientBadge(ingredient: ingredient, size: 40),
                const SizedBox(height: Dimens.smallMargin),
                Text(
                  recipe.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  ingredient.nombre,
                  style: TextStyle(fontSize: 12, color: ingredient.color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
