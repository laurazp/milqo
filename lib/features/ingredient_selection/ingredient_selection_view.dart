import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../../data/models/ingredient.dart';
import '../../widgets/ingredient_badge.dart';

/// Elegir el ingrediente principal con el que se va a calcular la receta —
/// apartado 4.2. Selección única en la v1: no se pueden mezclar dos
/// ingredientes en la misma receta.
class IngredientSelectionView extends ConsumerStatefulWidget {
  const IngredientSelectionView({super.key});

  @override
  ConsumerState<IngredientSelectionView> createState() => _IngredientSelectionViewState();
}

class _IngredientSelectionViewState extends ConsumerState<IngredientSelectionView> {
  Ingredient? _selected;

  @override
  Widget build(BuildContext context) {
    final ratiosRepository = ref.watch(ingredientsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Selección de bebida')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.largeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimens.smallMargin),
            const Text(
              'Elige con qué ingrediente quieres preparar tu bebida vegetal.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: Dimens.largeMargin),
            Expanded(
              child: GridView.builder(
                itemCount: kIngredients.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Dimens.mediumMargin,
                  crossAxisSpacing: Dimens.mediumMargin,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  if (index == kIngredients.length) {
                    return const _ComingSoonCard();
                  }
                  final ingredient = kIngredients[index];
                  final ratio = ratiosRepository.getRatio(ingredient.id);
                  final ratioLabel = '≈1:${(1000 / ratio.gramosBase).round()}';
                  final isSelected = _selected?.id == ingredient.id;

                  return _IngredientCard(
                    ingredient: ingredient,
                    ratioLabel: ratioLabel,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selected = ingredient),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.mediumMargin),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        // A regular push (not a replace): the spec's back
                        // arrow for Calculadora returns here (apartado 4.3).
                        : () => context.push(AppRoutes.calculatorFor(_selected!.id)),
                    child: Text(
                      _selected == null ? 'Continuar' : 'Continuar con ${_selected!.nombre}',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final String ratioLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _IngredientCard({
    required this.ingredient,
    required this.ratioLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
        side: BorderSide(
          color: isSelected ? AppColors.sageGreen : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.mediumMargin),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IngredientBadge(ingredient: ingredient),
                  const Spacer(),
                  Text(ingredient.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    'ratio base $ratioLabel',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                  ),
                ],
              ),
              if (isSelected)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.check_circle_rounded, color: AppColors.sageGreen),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.border.withValues(alpha: 0.35),
      child: const Padding(
        padding: EdgeInsets.all(Dimens.mediumMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.hourglass_bottom_rounded, color: AppColors.textSecondary),
            Spacer(),
            Text(
              'Próximamente: coco, avellana y soja',
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
