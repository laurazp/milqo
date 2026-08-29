import '../../data/local/conversion_data.dart';
import '../../data/models/conversion_entry.dart';
import '../../data/repositories/conversion_repository.dart';

/// Unidades soportadas por el Conversor — en la v1 basta con g ⇄ ml ⇄ tazas
/// (apartado 4.9, notas). Las cucharadas quedan solo en la tabla de
/// referencia, sin ser una unidad seleccionable.
enum ConvertibleUnit { gramos, mililitros, tazas }

/// Conversor de unidades g ⇄ ml ⇄ tazas, específico de cada ingrediente
/// porque el peso por taza varía según el producto (apartado 4.9).
class ConvertUnitsUseCase {
  final ConversionRepository conversionRepository;

  ConvertUnitsUseCase({required this.conversionRepository});

  /// Convierte [value] desde [from] hasta [to] para el ingrediente
  /// [ingredientId]. El agua siempre usa 1 ml = 1 g.
  double convert({
    required String ingredientId,
    required double value,
    required ConvertibleUnit from,
    required ConvertibleUnit to,
  }) {
    final grams = _toGrams(ingredientId, value, from);
    return _fromGrams(ingredientId, grams, to);
  }

  double _toGrams(String ingredientId, double value, ConvertibleUnit unit) {
    if (ingredientId == 'agua') {
      return unit == ConvertibleUnit.tazas ? value * kCupMl : value;
    }
    final entry = conversionRepository.getEntry(ingredientId);
    switch (unit) {
      case ConvertibleUnit.gramos:
        return value;
      case ConvertibleUnit.mililitros:
        // Sin una densidad húmeda propia en la v1, se aproxima 1 ml = 1 g
        // para líquidos y se usa la densidad seca para sólidos vía tazas.
        return value;
      case ConvertibleUnit.tazas:
        return value * entry.gramosPorTaza;
    }
  }

  double _fromGrams(String ingredientId, double grams, ConvertibleUnit unit) {
    if (ingredientId == 'agua') {
      return unit == ConvertibleUnit.tazas ? grams / kCupMl : grams;
    }
    final ConversionEntry entry = conversionRepository.getEntry(ingredientId);
    switch (unit) {
      case ConvertibleUnit.gramos:
        return grams;
      case ConvertibleUnit.mililitros:
        return grams;
      case ConvertibleUnit.tazas:
        return grams / entry.gramosPorTaza;
    }
  }
}
