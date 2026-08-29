import '../local/conversion_data.dart';
import '../models/conversion_entry.dart';

/// Tabla de conversión estática g ⇄ ml ⇄ tazas — apartado 4.9.
class ConversionRepository {
  List<ConversionEntry> getEntries() => kConversionEntries;

  ConversionEntry getEntry(String ingredientId) =>
      conversionForIngredient(ingredientId);
}
