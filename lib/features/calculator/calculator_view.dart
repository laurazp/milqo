import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../data/local/ingredients_data.dart';
import '../../data/models/calculator_mode.dart';
import '../../data/models/ingredient.dart';
import '../../widgets/ingredient_badge.dart';
import '../../widgets/transparency_note.dart';
import '../result/result_view.dart';
import 'calculator_controller.dart';
import 'widgets/creaminess_selector.dart';
import 'widgets/quantity_stepper.dart';

/// Calculadora — apartados 4.3 y 4.4: dos modos de entrada ("Quiero ___ ml"
/// / "Tengo ___ g") en la misma pantalla, con un control segmentado.
///
/// Se usa tanto como raíz de la pestaña "Calculadora" de la barra inferior
/// (sin [ingredientId], usa el primer ingrediente del catálogo) como
/// apilada desde Selección de bebida, un acceso rápido de Home o el enlace
/// "Usar en calculadora" de una receta.
class CalculatorView extends ConsumerWidget {
  final String? ingredientId;

  const CalculatorView({super.key, this.ingredientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ingredientId ?? kIngredients.first.id;
    final state = ref.watch(calculatorControllerProvider(id));
    final controller = ref.read(calculatorControllerProvider(id).notifier);
    final ingredient = ingredientById(state.ingredientId);
    final isWantMl = state.modo == CalculatorMode.wantMl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        actions: [
          IconButton(
            icon: const Icon(AppConstants.converterIcon),
            tooltip: 'Conversor de unidades',
            onPressed: () => context.push(AppRoutes.converterFor(ingredient.id)),
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
          _IngredientChip(
            ingredient: ingredient,
            onTap: () => _showIngredientPicker(context, controller),
          ),
          const SizedBox(height: Dimens.largeMargin),
          SegmentedButton<CalculatorMode>(
            segments: const [
              ButtonSegment(value: CalculatorMode.wantMl, label: Text('Quiero ___ ml')),
              ButtonSegment(value: CalculatorMode.haveGrams, label: Text('Tengo ___ g')),
            ],
            selected: {state.modo},
            onSelectionChanged: (s) => controller.setMode(s.first),
          ),
          const SizedBox(height: Dimens.largeMargin),
          QuantityStepper(
            value: state.currentValue,
            unitLabel: isWantMl ? 'ml' : 'g',
            quickValues: isWantMl
                ? const [
                    QuickQuantity('250 ml', 250),
                    QuickQuantity('500 ml', 500),
                    QuickQuantity('1 L', 1000),
                    QuickQuantity('1,5 L', 1500),
                  ]
                : const [
                    QuickQuantity('100 g', 100),
                    QuickQuantity('150 g', 150),
                    QuickQuantity('200 g', 200),
                    QuickQuantity('300 g', 300),
                  ],
            onIncrement: controller.increment,
            onDecrement: controller.decrement,
            onQuickValueSelected: controller.setValue,
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text('Cremosidad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Dimens.smallMargin),
          CreaminessSelector(value: state.cremosidad, onChanged: controller.setCreaminess),
          const SizedBox(height: Dimens.largeMargin),
          if (!isWantMl) ...[
            _YieldMessage(ml: controller.preview.resultadoMlTotal),
            const SizedBox(height: Dimens.mediumMargin),
          ],
          TransparencyNote(text: isWantMl ? AppConstants.transparencyNote : AppConstants.transparencyNoteShort),
          const SizedBox(height: Dimens.largeMargin),
          ElevatedButton(
            onPressed: () => context.push(
              AppRoutes.result,
              extra: ResultRouteArgs(result: controller.preview),
            ),
            child: const Text('Calcular receta'),
          ),
        ],
      ),
    );
  }

  void _showIngredientPicker(BuildContext context, CalculatorController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cardCornerRadius)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.largeMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cambiar ingrediente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Dimens.mediumMargin),
              for (final ingredient in kIngredients)
                ListTile(
                  leading: IngredientBadge(ingredient: ingredient, size: 36),
                  title: Text(ingredient.nombre),
                  onTap: () {
                    controller.setIngredient(ingredient.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const _IngredientChip({required this.ingredient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.mediumMargin, vertical: Dimens.smallMargin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IngredientBadge(ingredient: ingredient, size: 28),
            const SizedBox(width: Dimens.smallMargin),
            Text(ingredient.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _YieldMessage extends StatelessWidget {
  final double ml;

  const _YieldMessage({required this.ml});

  @override
  Widget build(BuildContext context) {
    final liters = ml / 1000;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.mediumMargin),
      decoration: BoxDecoration(
        color: AppColors.sageGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
      ),
      child: Text(
        'Obtendrás aprox. ${liters.toStringAsFixed(liters < 1 ? 2 : 1).replaceAll('.', ',')} L',
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGreen),
      ),
    );
  }
}
