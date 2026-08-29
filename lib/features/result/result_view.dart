import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../../data/local/recipes_data.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/calculator_mode.dart';
import '../../data/models/ingredient.dart';
import '../../widgets/ingredient_badge.dart';
import '../../widgets/transparency_note.dart';
import '../favorites/favorites_refresh_trigger.dart';

/// Argumentos para la ruta `/result`, empaquetados en un solo `extra` de
/// go_router (apartado 4.5 / 4.10 — "Recrea ese cálculo y muestra su
/// resultado" desde Favoritos).
class ResultRouteArgs {
  final CalculationResult result;
  final String? initialSavedId;

  const ResultRouteArgs({required this.result, this.initialSavedId});
}

/// Resultado del cálculo, con pasos de preparación y aviso de transparencia
/// — apartado 4.5.
class ResultView extends ConsumerStatefulWidget {
  final CalculationResult result;

  /// Id del [SavedCalculation] del que proviene este resultado, cuando se
  /// reabre desde Favoritos &gt; Cálculos guardados — para que el botón
  /// "Guardar en favoritos" empiece ya en estado "Guardado".
  final String? initialSavedId;

  const ResultView({super.key, required this.result, this.initialSavedId});

  @override
  ConsumerState<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  late bool _isSaved;
  late String? _savedCalculationId;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialSavedId != null;
    _savedCalculationId = widget.initialSavedId;
  }

  Future<void> _toggleSaved() async {
    if (_isSaved && _savedCalculationId != null) {
      await ref.read(calculationsRepositoryProvider).remove(_savedCalculationId!);
      await ref.read(manageFavoritesUseCaseProvider).removeCalculationFavorite(_savedCalculationId!);
      setState(() {
        _isSaved = false;
        _savedCalculationId = null;
      });
    } else {
      final saved = await ref.read(saveCalculationUseCaseProvider)(widget.result);
      setState(() {
        _isSaved = true;
        _savedCalculationId = saved.id;
      });
    }
    ref.read(favoritesRefreshTriggerProvider.notifier).bump();
  }

  String _shareText() {
    final result = widget.result;
    final ingredient = ingredientById(result.ingredientId);
    return 'Receta de ${ingredient.nombre} con Milqo:\n'
        '${result.resultadoGramos.toInt()} g de ${ingredient.nombre} + '
        '${result.resultadoMlAgua.toInt()} ml de agua\n'
        '≈ ${result.resultadoMlTotal.toInt()} ml (${result.vasos.toStringAsFixed(1)} vasos de 250 ml)\n'
        '${AppConstants.transparencyNote}';
  }

  List<String> _steps(String ingredientId) {
    final ingredient = ingredientById(ingredientId);
    final steps = <String>[];
    if (!ingredient.remojoRecomendado.startsWith('No aplica')) {
      steps.add('Remojo: ${ingredient.remojoRecomendado}');
    }
    steps.add('Añade ${ingredient.articulo} ${ingredient.nombre.toLowerCase()} y el agua a la batidora.');
    steps.add('Bate a ${ingredient.tiempoBatido}.');
    steps.add(ingredient.requiereColado
        ? 'Cuela con una bolsa de tela o colador fino y refrigera.'
        : 'No hace falta colar: se disuelve casi por completo. Refrigera.');
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final ingredient = ingredientById(result.ingredientId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        actions: [
          IconButton(
            icon: const Icon(AppConstants.converterIcon),
            tooltip: 'Conversor de unidades',
            onPressed: () => context.push(AppRoutes.converterFor(ingredient.id)),
          ),
          IconButton(
            icon: const Icon(AppConstants.shareIcon),
            tooltip: 'Compartir',
            onPressed: () => Share.share(_shareText()),
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
          _ResultCard(result: result, ingredient: ingredient),
          const SizedBox(height: Dimens.mediumMargin),
          TransparencyNote(
            text: '${AppConstants.transparencyNoteShort} El volumen final puede variar al colar.',
            onInfoTap: () => showTransparencyExplanationSheet(context),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text('Pasos de preparación', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Dimens.smallMargin),
          ..._steps(ingredient.id).asMap().entries.map(
                (e) => _StepTile(number: e.key + 1, text: e.value),
              ),
          const SizedBox(height: Dimens.largeMargin),
          OutlinedButton(
            onPressed: () =>
                context.push(AppRoutes.recipeDetail(classicRecipeForIngredient(ingredient.id).id)),
            child: const Text('Ver receta relacionada'),
          ),
          const SizedBox(height: Dimens.smallMargin),
          ElevatedButton.icon(
            onPressed: _toggleSaved,
            icon: Icon(_isSaved ? AppConstants.favoritesIcon : AppConstants.favoritesOutlineIcon),
            label: Text(_isSaved ? 'Guardado' : 'Guardar en favoritos'),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CalculationResult result;
  final Ingredient ingredient;

  const _ResultCard({required this.result, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.largeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IngredientBadge(ingredient: ingredient),
                const SizedBox(width: Dimens.mediumMargin),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ingredient.nombre, style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        'Cremosidad ${result.cremosidad.label.toLowerCase()}'
                        ' · ${result.modo == CalculatorMode.wantMl ? 'Quiero ___ ml' : 'Tengo ___ g'}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: Dimens.largeMargin * 2),
            _ResultRow(label: 'Ingrediente', value: '${result.resultadoGramos.toInt()} g'),
            _ResultRow(label: 'Agua', value: '${result.resultadoMlAgua.toInt()} ml'),
            _ResultRow(label: 'Total estimado', value: '≈ ${result.resultadoMlTotal.toInt()} ml'),
            _ResultRow(
              label: 'Equivalencia',
              value: '≈ ${result.vasos.toStringAsFixed(1).replaceAll('.', ',')} vasos (250 ml)',
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int number;
  final String text;

  const _StepTile({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.extraSmallMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.sageGreen,
            child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: Dimens.smallMargin),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
