import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../../domain/usecases/convert_units_usecase.dart';
import 'converter_controller.dart';

const _unitLabels = {
  ConvertibleUnit.gramos: 'g',
  ConvertibleUnit.mililitros: 'ml',
  ConvertibleUnit.tazas: 'tazas',
};

/// Conversor de unidades — utilidad transversal accesible desde Home, la
/// Calculadora y el Resultado (apartado 3), sin interrumpir el flujo
/// principal. En la v1 basta con soportar g ⇄ ml ⇄ tazas.
class ConverterView extends ConsumerStatefulWidget {
  final String? ingredientId;

  const ConverterView({super.key, this.ingredientId});

  @override
  ConsumerState<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends ConsumerState<ConverterView> {
  late final String _id = widget.ingredientId ?? kIngredients.first.id;
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(converterControllerProvider(_id)).inputValue;
    _inputController = TextEditingController(text: initial.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(converterControllerProvider(_id));
    final controller = ref.read(converterControllerProvider(_id).notifier);
    final ingredient = ingredientById(state.ingredientId);
    final entry = ref.watch(conversionRepositoryProvider).getEntry(ingredient.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de unidades')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Dimens.largeMargin,
          Dimens.smallMargin,
          Dimens.largeMargin,
          Dimens.hugeMargin,
        ),
        children: [
          Wrap(
            spacing: Dimens.smallMargin,
            children: kIngredients
                .map((i) => ChoiceChip(
                      label: Text(i.nombre),
                      selected: state.ingredientId == i.id,
                      onSelected: (_) => controller.setIngredient(i.id),
                    ))
                .toList(),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _UnitField(
                  controller: _inputController,
                  unit: state.fromUnit,
                  editable: true,
                  onValueChanged: controller.setInputValue,
                  onUnitChanged: controller.setFromUnit,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.swap_horiz_rounded),
                color: AppColors.sageGreen,
                onPressed: () {
                  controller.swap();
                  _inputController.text =
                      ref.read(converterControllerProvider(_id)).inputValue.toStringAsFixed(1).replaceAll('.', ',');
                },
              ),
              Expanded(
                child: _OutputUnitField(
                  value: controller.outputValue,
                  unit: state.toUnit,
                  onUnitChanged: controller.setToUnit,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.largeMargin),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tabla de referencia — ${ingredient.nombre}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const Divider(),
                  _ReferenceRow(label: '1 taza (240 ml)', value: '${entry.gramosPorTaza.toInt()} g'),
                  _ReferenceRow(label: '½ taza', value: '${(entry.gramosPorTaza / 2).toInt()} g'),
                  _ReferenceRow(label: '1 cucharada', value: '${entry.gramosPorCucharada.toInt()} g'),
                  const _ReferenceRow(label: '1 litro de agua', value: '1000 g'),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimens.mediumMargin),
          const Text(
            'El peso por taza cambia según el ingrediente porque cada uno tiene una '
            'densidad distinta: una taza de avena pesa mucho menos que una taza de '
            'almendra, por ejemplo. El agua se trata aparte con la conversión fija '
            '1 ml = 1 g.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _UnitField extends StatelessWidget {
  final TextEditingController controller;
  final ConvertibleUnit unit;
  final bool editable;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<ConvertibleUnit> onUnitChanged;

  const _UnitField({
    required this.controller,
    required this.unit,
    required this.editable,
    required this.onValueChanged,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          enabled: editable,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          onChanged: (text) => onValueChanged(double.tryParse(text.replaceAll(',', '.')) ?? 0),
        ),
        const SizedBox(height: 4),
        _UnitDropdown(unit: unit, onChanged: onUnitChanged),
      ],
    );
  }
}

/// Campo de salida de solo lectura: evita crear un [TextEditingController]
/// nuevo en cada build (necesario para recalcular al vuelo) sin arrastrar su
/// ciclo de vida.
class _OutputUnitField extends StatelessWidget {
  final double value;
  final ConvertibleUnit unit;
  final ValueChanged<ConvertibleUnit> onUnitChanged;

  const _OutputUnitField({required this.value, required this.unit, required this.onUnitChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.mediumMargin),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            value.toStringAsFixed(1).replaceAll('.', ','),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 4),
        _UnitDropdown(unit: unit, onChanged: onUnitChanged),
      ],
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final ConvertibleUnit unit;
  final ValueChanged<ConvertibleUnit> onChanged;

  const _UnitDropdown({required this.unit, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ConvertibleUnit>(
      value: unit,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      items: ConvertibleUnit.values
          .map((u) => DropdownMenuItem(value: u, child: Center(child: Text(_unitLabels[u]!))))
          .toList(),
      onChanged: (u) {
        if (u != null) onChanged(u);
      },
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReferenceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
