import 'package:flutter/material.dart';

import '../../../core/design/app_colors.dart';
import '../../../core/design/dimens.dart';
import '../../../core/utils/date_format.dart';
import '../../../data/local/ingredients_data.dart';
import '../../../data/models/calculator_mode.dart';
import '../../../data/models/saved_calculation.dart';
import '../../../widgets/ingredient_badge.dart';

/// Tarjeta de cálculo guardado: ingrediente + parámetros + fecha —
/// apartado 4.10.
class CalculationCard extends StatelessWidget {
  final SavedCalculation calculation;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const CalculationCard({
    super.key,
    required this.calculation,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final ingredient = ingredientById(calculation.ingredientId);
    final modeLabel = calculation.modo == CalculatorMode.wantMl
        ? '${calculation.valorInput.toInt()} ml deseados'
        : '${calculation.valorInput.toInt()} g disponibles';

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
                    Text('${ingredient.nombre} · ${calculation.cremosidad.label}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      '$modeLabel · ${formatShortDate(calculation.fecha)}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_rounded, color: AppColors.favoriteCoral),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
