import '../../core/utils/rounding.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/calculator_mode.dart';
import '../../data/models/creaminess.dart';
import '../../data/models/ingredient.dart';
import '../../data/models/ratio.dart';
import '../../data/repositories/ingredients_repository.dart';

/// Motor de cálculo de la Calculadora — fórmulas del apartado 7.
///
/// El rendimiento final resta aproximadamente un 5–10 % por la pulpa
/// retenida al colar (apartado 4.5), excepto en el anacardo, que no
/// necesita colado. Se usa aquí el punto medio de ese rango (7,5 %) como
/// pérdida por colado; ningún resultado de volumen se presenta como exacto,
/// siempre precedido de "≈" en la interfaz.
class CalculateRecipeUseCase {
  static const _strainingLoss = 0.075;

  final IngredientsRepository ingredientsRepository;

  CalculateRecipeUseCase({required this.ingredientsRepository});

  CalculationResult calculate({
    required String ingredientId,
    required CalculatorMode modo,
    required double valorInput,
    required Creaminess cremosidad,
  }) {
    final Ratio ratio = ingredientsRepository.getRatio(ingredientId);
    final Ingredient ingredient = ingredientsRepository.getIngredient(ingredientId);

    late double gramos;
    late double mlAgua;

    switch (modo) {
      case CalculatorMode.wantMl:
        mlAgua = valorInput;
        gramos = mlAgua * (ratio.gramosBase / 1000) * cremosidad.factor;
      case CalculatorMode.haveGrams:
        gramos = valorInput;
        mlAgua = gramos * (1000 / ratio.gramosBase) / cremosidad.factor;
    }

    gramos = Rounding.toNearestGram(gramos);
    mlAgua = Rounding.toNearestWater(mlAgua);

    final mlTotal = ingredient.requiereColado
        ? Rounding.toNearestWater(mlAgua * (1 - _strainingLoss))
        : mlAgua;

    return CalculationResult(
      ingredientId: ingredientId,
      modo: modo,
      valorInput: valorInput,
      cremosidad: cremosidad,
      resultadoGramos: gramos,
      resultadoMlAgua: mlAgua,
      resultadoMlTotal: mlTotal,
    );
  }
}
