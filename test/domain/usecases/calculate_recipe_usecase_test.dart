import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';
import 'package:milqo_flutter/data/local/ingredients_data.dart';
import 'package:milqo_flutter/data/models/calculator_mode.dart';
import 'package:milqo_flutter/data/models/creaminess.dart';
import 'package:milqo_flutter/data/repositories/ingredients_repository.dart';
import 'package:milqo_flutter/domain/usecases/calculate_recipe_usecase.dart';

/// Motor de cálculo — apartado 9 del checklist de lanzamiento: "Motor de
/// cálculo probado para los 5 ingredientes, en los dos modos (directo e
/// inverso)".
void main() {
  late CalculateRecipeUseCase useCase;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppDataStore.instance.load();
    useCase = CalculateRecipeUseCase(ingredientsRepository: IngredientsRepository());
  });

  test('worked example from apartado 7: 200 g almendra, normal -> ~1335 ml de agua', () {
    // 200 × (1000 / 150) / 1,0 = 1333,33 ml ≈ 1335 ml (apartado 7).
    final result = useCase.calculate(
      ingredientId: 'almendra',
      modo: CalculatorMode.haveGrams,
      valorInput: 200,
      cremosidad: Creaminess.normal,
    );

    expect(result.resultadoGramos, 200);
    expect(result.resultadoMlAgua, 1335);
  });

  test('wantMl mode: 1000 ml de avena, normal -> 150 g, con pérdida por colado', () {
    final result = useCase.calculate(
      ingredientId: 'avena',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.normal,
    );

    expect(result.resultadoGramos, 150);
    expect(result.resultadoMlAgua, 1000);
    // La avena requiere colado: se resta la pérdida por pulpa (~7,5 %).
    expect(result.resultadoMlTotal, 925);
  });

  test('anacardo no requiere colado: el total no resta pérdida por pulpa', () {
    final result = useCase.calculate(
      ingredientId: 'anacardo',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.normal,
    );

    expect(result.resultadoMlTotal, result.resultadoMlAgua);
  });

  test('la cremosidad escala el ingrediente sólido, nunca el agua', () {
    final ligera = useCase.calculate(
      ingredientId: 'pistacho',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.ligera,
    );
    final normal = useCase.calculate(
      ingredientId: 'pistacho',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.normal,
    );
    final cremosa = useCase.calculate(
      ingredientId: 'pistacho',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.cremosa,
    );

    expect(ligera.resultadoMlAgua, normal.resultadoMlAgua);
    expect(cremosa.resultadoMlAgua, normal.resultadoMlAgua);
    expect(ligera.resultadoGramos, lessThan(normal.resultadoGramos));
    expect(cremosa.resultadoGramos, greaterThan(normal.resultadoGramos));
  });

  test('modo "tengo gramos" es el inverso de "quiero ml" para el mismo ratio', () {
    for (final ingredient in kIngredients) {
      final wantMl = useCase.calculate(
        ingredientId: ingredient.id,
        modo: CalculatorMode.wantMl,
        valorInput: 1000,
        cremosidad: Creaminess.normal,
      );
      final haveGrams = useCase.calculate(
        ingredientId: ingredient.id,
        modo: CalculatorMode.haveGrams,
        valorInput: wantMl.resultadoGramos,
        cremosidad: Creaminess.normal,
      );

      // Redondeos aparte, pedir 1000 ml y luego invertir el resultado en
      // gramos debe devolver ~1000 ml de agua.
      expect(haveGrams.resultadoMlAgua, closeTo(1000, 5));
    }
  });

  test('calcula sin errores para los 5 ingredientes en los 2 modos', () {
    for (final ingredient in kIngredients) {
      for (final modo in CalculatorMode.values) {
        final result = useCase.calculate(
          ingredientId: ingredient.id,
          modo: modo,
          valorInput: modo == CalculatorMode.wantMl ? 1000 : 200,
          cremosidad: Creaminess.normal,
        );

        expect(result.resultadoGramos, greaterThan(0));
        expect(result.resultadoMlAgua, greaterThan(0));
        expect(result.resultadoMlTotal, greaterThan(0));
      }
    }
  });
}
