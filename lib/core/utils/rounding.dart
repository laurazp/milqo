/// Reglas de redondeo del apartado 7 — para no transmitir una falsa
/// precisión, Milqo nunca muestra decimales largos en cantidades.
abstract class Rounding {
  /// El agua se redondea al múltiplo de 5 ml más cercano.
  static double toNearestWater(double ml) => (ml / 5).round() * 5;

  /// El ingrediente sólido se redondea al gramo más cercano.
  static double toNearestGram(double g) => g.roundToDouble();

  /// Cucharaditas/cucharadas escaladas se redondean a fracciones simples
  /// (¼, ½, ¾), nunca a más de un decimal "raro".
  static double toSimpleFraction(double value) => (value * 4).round() / 4;

  /// Texto de una fracción simple ("¼", "1 ½", "2"...), usado al mostrar
  /// cucharaditas/cucharadas escaladas.
  static String fractionLabel(double value) {
    final rounded = toSimpleFraction(value);
    final whole = rounded.truncate();
    final fraction = rounded - whole;

    String fractionText;
    if (fraction == 0) {
      fractionText = '';
    } else if ((fraction - 0.25).abs() < 0.01) {
      fractionText = '¼';
    } else if ((fraction - 0.5).abs() < 0.01) {
      fractionText = '½';
    } else {
      fractionText = '¾';
    }

    if (whole == 0 && fractionText.isNotEmpty) return fractionText;
    if (fractionText.isEmpty) return whole.toString();
    return '$whole $fractionText';
  }
}
