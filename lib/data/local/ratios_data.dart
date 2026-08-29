import '../models/ratio.dart';
import 'app_data_store.dart';

/// Base de datos de ratios por ingrediente — apartado 6 de la
/// especificación, cargada desde `assets/data/ratios.json` (ver
/// [AppDataStore]). Expresados como gramos de ingrediente por litro de
/// agua, contrastados entre varias fuentes de recetas caseras con buena
/// valoración. Son una referencia orientativa, no un estándar oficial.
List<Ratio> get kRatios => AppDataStore.instance.ratios;

Ratio ratioForIngredient(String ingredientId) =>
    kRatios.firstWhere((r) => r.ingredientId == ingredientId);
