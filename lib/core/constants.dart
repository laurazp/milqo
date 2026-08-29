import 'package:flutter/material.dart';

/// Configuración estática no visual: textos fijos e iconografía.
abstract class AppConstants {
  // MARK: - Textos de transparencia (apartado 7 — evitar falsa precisión)
  //
  // Texto fijo, no editable por el usuario, mostrado en la Calculadora, en
  // "Tengo X gramos" y en el Resultado.
  static const String transparencyNote =
      'Ratio orientativo basado en varias recetas. El volumen final puede '
      'variar al colar.';

  static const String transparencyNoteShort =
      'Ratio orientativo basado en varias recetas publicadas, no una medida '
      'exacta.';

  static const String transparencyExplanation =
      'Los ratios de Milqo son una media orientativa calculada a partir de '
      'varias recetas publicadas con buena valoración, no un estándar '
      'oficial ni una medida científica garantizada. El resultado real '
      'depende de la potencia de la batidora, del tiempo de remojo y del '
      'colado.';

  // MARK: - Iconos
  static const IconData homeIcon = Icons.home_rounded;
  static const IconData calculatorIcon = Icons.calculate_rounded;
  static const IconData recipesIcon = Icons.menu_book_rounded;
  static const IconData favoritesIcon = Icons.favorite_rounded;
  static const IconData favoritesOutlineIcon = Icons.favorite_border_rounded;
  static const IconData searchIcon = Icons.search_rounded;
  static const IconData converterIcon = Icons.swap_horiz_rounded;
  static const IconData shareIcon = Icons.share_rounded;
  static const IconData backIcon = Icons.arrow_back_rounded;
  static const IconData infoIcon = Icons.info_outline_rounded;
  static const IconData checkIcon = Icons.check_circle_rounded;
  static const IconData addIcon = Icons.add_rounded;
  static const IconData removeIcon = Icons.remove_rounded;
  static const IconData scaleIcon = Icons.straighten_rounded;
  static const IconData linkIcon = Icons.open_in_new_rounded;
}
