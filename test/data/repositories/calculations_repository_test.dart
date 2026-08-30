import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/models/calculator_mode.dart';
import 'package:milqo_flutter/data/models/creaminess.dart';
import 'package:milqo_flutter/data/models/saved_calculation.dart';
import 'package:milqo_flutter/data/repositories/calculations_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedCalculation _fixture({required String id, DateTime? fecha}) => SavedCalculation(
      id: id,
      ingredientId: 'almendra',
      modo: CalculatorMode.wantMl,
      valorInput: 1000,
      cremosidad: Creaminess.normal,
      resultadoGramos: 150,
      resultadoMlAgua: 1000,
      resultadoMlTotal: 925,
      fecha: fecha ?? DateTime(2026, 1, 1),
    );

void main() {
  late CalculationsRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = CalculationsRepository();
  });

  test('empieza vacío', () async {
    expect(await repository.getAll(), isEmpty);
  });

  test('save guarda un cálculo y getAll lo devuelve con los mismos datos', () async {
    await repository.save(_fixture(id: 'calc_1'));

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.id, 'calc_1');
    expect(all.first.ingredientId, 'almendra');
    expect(all.first.resultadoGramos, 150);
    expect(all.first.resultadoMlTotal, 925);
  });

  test('remove quita solo el cálculo indicado', () async {
    await repository.save(_fixture(id: 'calc_1', fecha: DateTime(2026, 1, 1)));
    await repository.save(_fixture(id: 'calc_2', fecha: DateTime(2026, 1, 2)));

    await repository.remove('calc_1');

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.id, 'calc_2');
  });

  test('getAll ordena por fecha, más reciente primero', () async {
    await repository.save(_fixture(id: 'calc_old', fecha: DateTime(2026, 1, 1)));
    await repository.save(_fixture(id: 'calc_new', fecha: DateTime(2026, 6, 1)));

    final all = await repository.getAll();
    expect(all.first.id, 'calc_new');
    expect(all.last.id, 'calc_old');
  });
}
