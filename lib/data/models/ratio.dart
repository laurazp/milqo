import 'ratio_confidence.dart';
import 'recipe_source.dart';

/// Ratio de un ingrediente, separado de [Ingredient] (apartado 5, nuevo
/// respecto a la v0.1) para poder versionarlo y puntuarlo por confianza sin
/// tocar el catálogo de ingredientes.
class Ratio {
  final String ratioId;
  final String ingredientId;
  final double gramosBase;
  final double aguaMlBase;
  final RatioConfidence confianza;
  final List<RecipeSource> fuentes;
  final DateTime ultimaVerificacion;

  const Ratio({
    required this.ratioId,
    required this.ingredientId,
    required this.gramosBase,
    this.aguaMlBase = 1000,
    required this.confianza,
    required this.fuentes,
    required this.ultimaVerificacion,
  });

  factory Ratio.fromJson(Map<String, dynamic> json) => Ratio(
        ratioId: json['ratioId'] as String,
        ingredientId: json['ingredientId'] as String,
        gramosBase: (json['gramosBase'] as num).toDouble(),
        aguaMlBase: (json['aguaMlBase'] as num).toDouble(),
        confianza: RatioConfidence.values.firstWhere((c) => c.name == json['confianza']),
        fuentes: (json['fuentes'] as List)
            .map((f) => RecipeSource.fromJson(f as Map<String, dynamic>))
            .toList(),
        ultimaVerificacion: DateTime.parse(json['ultimaVerificacion'] as String),
      );

  Map<String, dynamic> toJson() => {
        'ratioId': ratioId,
        'ingredientId': ingredientId,
        'gramosBase': gramosBase,
        'aguaMlBase': aguaMlBase,
        'confianza': confianza.name,
        'fuentes': fuentes.map((f) => f.toJson()).toList(),
        'ultimaVerificacion': ultimaVerificacion.toIso8601String().split('T').first,
      };
}
