import '../../core/utils/rounding.dart';
import '../../data/models/recipe.dart';

/// Cantidad de un ingrediente ya escalada, lista para mostrar en la tabla
/// comparativa de la pantalla Escalado de receta (apartado 4.8).
class ScaledIngredient {
  final RecipeIngredientItem original;
  final String cantidadEscaladaTexto;

  const ScaledIngredient({
    required this.original,
    required this.cantidadEscaladaTexto,
  });
}

/// Escalado de recetas — apartado 4.8/7: cantidad_nueva = cantidad_original
/// × (litros_objetivo / litros_base). La v1 permite escalar de 0,25 L a 5 L.
class ScaleRecipeUseCase {
  static const double minLitros = 0.25;
  static const double maxLitros = 5.0;

  List<ScaledIngredient> scale(Recipe recipe, double litrosObjetivo) {
    final factor = litrosObjetivo / recipe.rindeLitros;

    return recipe.ingredientes.map((item) {
      if (item.cantidadBase == null) {
        return ScaledIngredient(
          original: item,
          cantidadEscaladaTexto: item.textoOriginal,
        );
      }

      final nuevaCantidad = item.cantidadBase! * factor;

      switch (item.unidad) {
        case RecipeUnit.gramos:
          final rounded = Rounding.toNearestGram(nuevaCantidad);
          return ScaledIngredient(
            original: item,
            cantidadEscaladaTexto: '${rounded.toInt()} g de ${item.nombre}',
          );
        case RecipeUnit.mililitros:
          final rounded = Rounding.toNearestWater(nuevaCantidad);
          return ScaledIngredient(
            original: item,
            cantidadEscaladaTexto: '${rounded.toInt()} ml de ${item.nombre}',
          );
        case RecipeUnit.cucharadita:
          final label = Rounding.fractionLabel(nuevaCantidad);
          return ScaledIngredient(
            original: item,
            cantidadEscaladaTexto: '$label cdta de ${item.nombre}',
          );
        case RecipeUnit.cucharada:
          final label = Rounding.fractionLabel(nuevaCantidad);
          return ScaledIngredient(
            original: item,
            cantidadEscaladaTexto: '$label cda de ${item.nombre}',
          );
        case RecipeUnit.otro:
          return ScaledIngredient(
            original: item,
            cantidadEscaladaTexto: item.textoOriginal,
          );
      }
    }).toList();
  }
}
