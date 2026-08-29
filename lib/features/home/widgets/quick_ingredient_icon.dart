import 'package:flutter/material.dart';

import '../../../core/design/dimens.dart';
import '../../../data/models/ingredient.dart';
import '../../../widgets/ingredient_badge.dart';

/// Acceso rápido a un ingrediente desde Home — salta directo al cálculo con
/// ese ingrediente ya elegido, saltándose Selección de bebida (apartado 4.1).
class QuickIngredientIcon extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const QuickIngredientIcon({super.key, required this.ingredient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.smallMargin),
        child: Column(
          children: [
            IngredientBadge(ingredient: ingredient),
            const SizedBox(height: Dimens.extraSmallMargin),
            Text(ingredient.nombre, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
