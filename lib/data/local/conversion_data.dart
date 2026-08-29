import '../models/conversion_entry.dart';
import 'app_data_store.dart';

/// Tabla de conversión estática (gramos por taza de 240 ml y por cucharada)
/// — apartado 4.9/5, cargada desde `assets/data/conversion.json` (ver
/// [AppDataStore]). Son densidades aproximadas en seco/crudo, ya que no
/// aparecen fijadas con un valor numérico en el documento de referencia; el
/// agua se trata aparte con la conversión fija 1 ml = 1 g.
List<ConversionEntry> get kConversionEntries => AppDataStore.instance.conversionEntries;

const kCupMl = 240.0;
const kWaterGramsPerMl = 1.0;

ConversionEntry conversionForIngredient(String ingredientId) =>
    kConversionEntries.firstWhere((c) => c.ingredientId == ingredientId);
