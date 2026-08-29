import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/providers.dart';
import '../../data/local/ingredients_data.dart';
import '../../data/models/recipe.dart';
import 'recipe_detail_controller.dart';

/// Detalle de receta — apartado 4.7. Milqo no presenta estas recetas como
/// una verdad absoluta: enlaza siempre a la fuente original.
class RecipeDetailView extends ConsumerWidget {
  final String recipeId;

  const RecipeDetailView({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipesRepositoryProvider).getById(recipeId);
    final ingredient = ingredientById(recipe.ingredientId);
    final isFavoriteAsync = ref.watch(recipeFavoriteControllerProvider(recipeId));
    final isFavorite = isFavoriteAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(AppConstants.shareIcon),
            tooltip: 'Compartir',
            onPressed: () => Share.share(_shareText(recipe)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Dimens.largeMargin,
          0,
          Dimens.largeMargin,
          Dimens.hugeMargin,
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Dimens.largeMargin),
            decoration: BoxDecoration(
              color: ingredient.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
            ),
            child: Icon(ingredient.icon, size: 56, color: ingredient.color),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text(recipe.nombre, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Dimens.smallMargin),
          Row(
            children: [
              _QuickFact(label: 'Remojo', value: recipe.tiempoRemojo),
              _QuickFact(label: 'Preparación', value: recipe.tiempoPreparacion),
              _QuickFact(label: 'Rinde', value: '${(recipe.rindeMl / 1000).toStringAsFixed(0)} L'),
            ],
          ),
          const SizedBox(height: Dimens.mediumMargin),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
              children: [
                TextSpan(
                  text: 'Inspirada en varias recetas de ${recipe.fuentesNombres.join(' y ')}. ',
                ),
                TextSpan(
                  text: 'Ver receta original',
                  style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w600),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(Uri.parse(recipe.fuenteUrl), mode: LaunchMode.externalApplication),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text('Ingredientes (para ${(recipe.rindeMl / 1000).toStringAsFixed(0)} L)',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Dimens.smallMargin),
          ...recipe.ingredientes.map((item) => _IngredientLine(item: item)),
          const SizedBox(height: Dimens.largeMargin),
          Text('Preparación', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Dimens.smallMargin),
          ...recipe.pasos.asMap().entries.map((e) => _StepLine(number: e.key + 1, text: e.value)),
          const SizedBox(height: Dimens.mediumMargin),
          Center(
            child: TextButton(
              onPressed: () => context.push(AppRoutes.calculatorFor(ingredient.id)),
              child: const Text('Usar en calculadora'),
            ),
          ),
          const SizedBox(height: Dimens.smallMargin),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.recipeScale(recipe.id)),
            child: const Text('Escalar receta'),
          ),
          const SizedBox(height: Dimens.smallMargin),
          ElevatedButton.icon(
            onPressed: () => ref.read(recipeFavoriteControllerProvider(recipeId).notifier).toggle(),
            icon: Icon(isFavorite ? AppConstants.favoritesIcon : AppConstants.favoritesOutlineIcon),
            label: Text(isFavorite ? 'Guardado' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  String _shareText(Recipe recipe) {
    final buffer = StringBuffer('${recipe.nombre} — receta de Milqo\n\n');
    for (final item in recipe.ingredientes) {
      buffer.writeln('• ${item.textoOriginal}');
    }
    buffer.writeln();
    for (var i = 0; i < recipe.pasos.length; i++) {
      buffer.writeln('${i + 1}. ${recipe.pasos[i]}');
    }
    return buffer.toString();
  }
}

class _QuickFact extends StatelessWidget {
  final String label;
  final String value;

  const _QuickFact({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _IngredientLine extends StatelessWidget {
  final RecipeIngredientItem item;

  const _IngredientLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 6, color: AppColors.sageGreen),
          ),
          Expanded(
            child: Text(
              item.esOpcional ? '${item.textoOriginal} (opcional)' : item.textoOriginal,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final int number;
  final String text;

  const _StepLine({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
