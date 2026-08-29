/// Densidad aproximada de un ingrediente para el Conversor de unidades
/// (apartado 4.9 / 5, tabla de conversión estática).
class ConversionEntry {
  final String ingredientId;
  final double gramosPorTaza;
  final double gramosPorCucharada;

  const ConversionEntry({
    required this.ingredientId,
    required this.gramosPorTaza,
    required this.gramosPorCucharada,
  });

  factory ConversionEntry.fromJson(Map<String, dynamic> json) => ConversionEntry(
        ingredientId: json['ingredientId'] as String,
        gramosPorTaza: (json['gramosPorTaza'] as num).toDouble(),
        gramosPorCucharada: (json['gramosPorCucharada'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'ingredientId': ingredientId,
        'gramosPorTaza': gramosPorTaza,
        'gramosPorCucharada': gramosPorCucharada,
      };
}
