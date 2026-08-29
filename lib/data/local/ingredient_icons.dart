import 'package:flutter/material.dart';

/// El icono de cada ingrediente es una decisión de diseño que vive en
/// código, no contenido — a diferencia del resto de campos de
/// `assets/data/ingredients.json`, un `IconData` no tiene una
/// representación JSON razonable.
const kIngredientIcons = <String, IconData>{
  'avena': Icons.grain_rounded,
  'almendra': Icons.spa_rounded,
  'pistacho': Icons.eco_rounded,
  'anacardo': Icons.egg_alt_rounded,
  'arroz': Icons.rice_bowl_rounded,
};
