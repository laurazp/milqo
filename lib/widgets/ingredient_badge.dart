import 'package:flutter/material.dart';

import '../data/models/ingredient.dart';

/// Círculo de color/icono de un ingrediente, reutilizado en Home, Selección
/// de bebida, Recetas, Detalle de receta y Favoritos para reconocerlo de un
/// vistazo (apartado 2, Principios de UI).
class IngredientBadge extends StatelessWidget {
  final Ingredient ingredient;
  final double size;

  const IngredientBadge({super.key, required this.ingredient, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ingredient.color.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: Icon(ingredient.icon, color: ingredient.color, size: size * 0.5),
    );
  }
}
