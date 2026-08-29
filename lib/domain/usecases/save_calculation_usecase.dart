import '../../data/models/calculation_result.dart';
import '../../data/models/saved_calculation.dart';
import '../../data/repositories/calculations_repository.dart';
import '../../data/repositories/favorites_repository.dart';

/// Guarda un cálculo de la Calculadora en Favoritos &gt; Cálculos guardados
/// — botón "Guardar en favoritos" del Resultado (apartado 4.5).
class SaveCalculationUseCase {
  final CalculationsRepository calculationsRepository;
  final FavoritesRepository favoritesRepository;

  SaveCalculationUseCase({
    required this.calculationsRepository,
    required this.favoritesRepository,
  });

  Future<SavedCalculation> call(CalculationResult result) async {
    final saved = SavedCalculation(
      id: 'calc_${DateTime.now().microsecondsSinceEpoch}',
      ingredientId: result.ingredientId,
      modo: result.modo,
      valorInput: result.valorInput,
      cremosidad: result.cremosidad,
      resultadoGramos: result.resultadoGramos,
      resultadoMlAgua: result.resultadoMlAgua,
      resultadoMlTotal: result.resultadoMlTotal,
      fecha: DateTime.now(),
    );
    await calculationsRepository.save(saved);
    await favoritesRepository.addCalculation(saved.id);
    return saved;
  }
}
