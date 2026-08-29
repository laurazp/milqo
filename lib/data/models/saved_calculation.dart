import 'calculator_mode.dart';
import 'creaminess.dart';

/// Cálculo guardado en Favoritos &gt; Cálculos guardados (apartado 5, entidad
/// "Cálculo").
class SavedCalculation {
  final String id;
  final String ingredientId;
  final CalculatorMode modo;
  final double valorInput;
  final Creaminess cremosidad;
  final double resultadoGramos;
  final double resultadoMlAgua;
  final double resultadoMlTotal;
  final DateTime fecha;

  const SavedCalculation({
    required this.id,
    required this.ingredientId,
    required this.modo,
    required this.valorInput,
    required this.cremosidad,
    required this.resultadoGramos,
    required this.resultadoMlAgua,
    required this.resultadoMlTotal,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ingredientId': ingredientId,
        'modo': modo.storageValue,
        'valorInput': valorInput,
        'cremosidad': cremosidad.name,
        'resultadoGramos': resultadoGramos,
        'resultadoMlAgua': resultadoMlAgua,
        'resultadoMlTotal': resultadoMlTotal,
        'fecha': fecha.toIso8601String(),
      };

  factory SavedCalculation.fromJson(Map<String, dynamic> json) {
    return SavedCalculation(
      id: json['id'] as String,
      ingredientId: json['ingredientId'] as String,
      modo: CalculatorMode.values
          .firstWhere((m) => m.storageValue == json['modo']),
      valorInput: (json['valorInput'] as num).toDouble(),
      cremosidad:
          Creaminess.values.firstWhere((c) => c.name == json['cremosidad']),
      resultadoGramos: (json['resultadoGramos'] as num).toDouble(),
      resultadoMlAgua: (json['resultadoMlAgua'] as num).toDouble(),
      resultadoMlTotal: (json['resultadoMlTotal'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }
}
