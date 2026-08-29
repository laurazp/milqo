import 'calculator_mode.dart';
import 'creaminess.dart';

/// Resultado de un cálculo de la Calculadora — pantalla Resultado
/// (apartado 4.5). No es necesariamente persistido: [SavedCalculation] es la
/// versión que sí se guarda en Favoritos.
class CalculationResult {
  final String ingredientId;
  final CalculatorMode modo;
  final double valorInput;
  final Creaminess cremosidad;
  final double resultadoGramos;
  final double resultadoMlAgua;
  final double resultadoMlTotal;

  const CalculationResult({
    required this.ingredientId,
    required this.modo,
    required this.valorInput,
    required this.cremosidad,
    required this.resultadoGramos,
    required this.resultadoMlAgua,
    required this.resultadoMlTotal,
  });

  /// Equivalencia en vasos de 250 ml, mostrada en la tarjeta de resultado.
  double get vasos => resultadoMlTotal / 250;
}
