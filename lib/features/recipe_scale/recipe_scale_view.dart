import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/app_colors.dart';
import '../../core/design/dimens.dart';
import '../../core/navigation/app_router.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/providers.dart';
import '../../domain/usecases/scale_recipe_usecase.dart';
import '../favorites/favorites_refresh_trigger.dart';

const _quickLiters = [0.5, 1.0, 2.5, 5.0];

/// Escalado de receta — apartado 4.8. La v1 permite escalar de 0,25 L a 5 L.
class RecipeScaleView extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeScaleView({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeScaleView> createState() => _RecipeScaleViewState();
}

class _RecipeScaleViewState extends ConsumerState<RecipeScaleView> {
  late double _litros;

  @override
  void initState() {
    super.initState();
    final recipe = ref.read(recipesRepositoryProvider).getById(widget.recipeId);
    _litros = recipe.rindeLitros;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = ref.watch(recipesRepositoryProvider).getById(widget.recipeId);
    final scaled = ref.watch(scaleRecipeUseCaseProvider).scale(recipe, _litros);

    return Scaffold(
      appBar: AppBar(title: const Text('Escalar receta')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Dimens.largeMargin,
          Dimens.smallMargin,
          Dimens.largeMargin,
          Dimens.hugeMargin,
        ),
        children: [
          Text(recipe.nombre, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Dimens.largeMargin),
          Center(
            child: Text(
              '${_litros.toStringAsFixed(2).replaceAll('.', ',')} L',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
          ),
          Slider(
            value: _litros,
            min: ScaleRecipeUseCase.minLitros,
            max: ScaleRecipeUseCase.maxLitros,
            divisions: 19,
            activeColor: AppColors.sageGreen,
            onChanged: (value) => setState(() => _litros = value),
          ),
          Wrap(
            spacing: Dimens.smallMargin,
            alignment: WrapAlignment.center,
            children: _quickLiters
                .map((l) => ChoiceChip(
                      label: Text('${l.toStringAsFixed(l == l.roundToDouble() ? 0 : 1).replaceAll('.', ',')} L'),
                      selected: _litros == l,
                      onSelected: (_) => setState(() => _litros = l),
                    ))
                .toList(),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumMargin),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Ingrediente', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Expanded(
                        child: Text('Base', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Escalada', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const Divider(),
                  for (final item in scaled)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: Text(item.original.nombre)),
                          Expanded(
                            child: Text(
                              item.original.cantidadBase != null
                                  ? item.original.textoOriginal.split(' de ').first
                                  : '—',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.cantidadEscaladaTexto,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimens.largeMargin),
          ElevatedButton(
            onPressed: () async {
              await ref.read(manageFavoritesUseCaseProvider).ensureRecipeFavorite(widget.recipeId);
              ref.read(favoritesRefreshTriggerProvider.notifier).bump();
              if (!context.mounted) return;
              final messengerKey = ref.read(scaffoldMessengerKeyProvider);
              // `go` (not `push`) both discards this screen and Detalle de
              // receta beneath it, and switches the bottom bar to
              // Favoritos — apartado 4.8: "Guardar receta escalada" ->
              // "Favoritos (confirmación)".
              context.go(AppRoutes.favoritesTab);
              messengerKey.currentState?.showSnackBar(
                const SnackBar(content: Text('Receta escalada guardada en Favoritos')),
              );
            },
            child: const Text('Guardar receta escalada'),
          ),
        ],
      ),
    );
  }
}
