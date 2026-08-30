import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/local/app_data_store.dart';
import 'package:milqo_flutter/data/repositories/conversion_repository.dart';
import 'package:milqo_flutter/domain/usecases/convert_units_usecase.dart';

/// Conversor de unidades — apartado 4.9: g ⇄ ml ⇄ tazas, específico de cada
/// ingrediente porque el peso por taza varía según el producto.
void main() {
  late ConvertUnitsUseCase useCase;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppDataStore.instance.load();
    useCase = ConvertUnitsUseCase(conversionRepository: ConversionRepository());
  });

  test('gramos -> tazas usa la densidad del ingrediente (avena: 90 g/taza)', () {
    final tazas = useCase.convert(
      ingredientId: 'avena',
      value: 90,
      from: ConvertibleUnit.gramos,
      to: ConvertibleUnit.tazas,
    );

    expect(tazas, 1.0);
  });

  test('tazas -> gramos es el inverso exacto', () {
    final gramos = useCase.convert(
      ingredientId: 'avena',
      value: 1,
      from: ConvertibleUnit.tazas,
      to: ConvertibleUnit.gramos,
    );

    expect(gramos, 90);
  });

  test('el agua usa la conversión fija 1 ml = 1 g y 1 taza = 240 ml', () {
    final ml = useCase.convert(
      ingredientId: 'agua',
      value: 1,
      from: ConvertibleUnit.tazas,
      to: ConvertibleUnit.mililitros,
    );
    expect(ml, 240);

    final gramos = useCase.convert(
      ingredientId: 'agua',
      value: 500,
      from: ConvertibleUnit.mililitros,
      to: ConvertibleUnit.gramos,
    );
    expect(gramos, 500);
  });

  test('ida y vuelta g -> tazas -> g devuelve el valor original', () {
    for (final ingredientId in ['avena', 'almendra', 'pistacho', 'anacardo', 'arroz']) {
      final tazas = useCase.convert(
        ingredientId: ingredientId,
        value: 200,
        from: ConvertibleUnit.gramos,
        to: ConvertibleUnit.tazas,
      );
      final backToGrams = useCase.convert(
        ingredientId: ingredientId,
        value: tazas,
        from: ConvertibleUnit.tazas,
        to: ConvertibleUnit.gramos,
      );

      expect(backToGrams, closeTo(200, 0.001));
    }
  });
}
