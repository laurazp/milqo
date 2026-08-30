import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/models/favorite.dart';
import 'package:milqo_flutter/data/repositories/favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FavoritesRepository repository;

  setUp(() {
    // Local-only storage (apartado 4.10): a fresh in-memory prefs store per
    // test, so tests don't leak favorites into each other.
    SharedPreferences.setMockInitialValues({});
    repository = FavoritesRepository();
  });

  test('empieza vacío', () async {
    expect(await repository.getAll(), isEmpty);
    expect(await repository.isFavoriteRecipe('avena_clasica'), isFalse);
  });

  test('toggleRecipe guarda y luego quita una receta de favoritos', () async {
    await repository.toggleRecipe('avena_clasica');
    expect(await repository.isFavoriteRecipe('avena_clasica'), isTrue);

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.tipo, FavoriteType.receta);
    expect(all.first.referenciaId, 'avena_clasica');

    await repository.toggleRecipe('avena_clasica');
    expect(await repository.isFavoriteRecipe('avena_clasica'), isFalse);
    expect(await repository.getAll(), isEmpty);
  });

  test('toggleRecipe no afecta a otras recetas guardadas', () async {
    await repository.toggleRecipe('avena_clasica');
    await repository.toggleRecipe('almendra_clasica');

    expect(await repository.isFavoriteRecipe('avena_clasica'), isTrue);
    expect(await repository.isFavoriteRecipe('almendra_clasica'), isTrue);

    await repository.toggleRecipe('avena_clasica');

    expect(await repository.isFavoriteRecipe('avena_clasica'), isFalse);
    expect(await repository.isFavoriteRecipe('almendra_clasica'), isTrue);
  });

  test('addCalculation guarda un favorito de tipo calculo', () async {
    await repository.addCalculation('calc_123');

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.tipo, FavoriteType.calculo);
    expect(all.first.referenciaId, 'calc_123');
  });

  test('removeCalculationFavorite quita solo ese cálculo', () async {
    await repository.addCalculation('calc_123');
    await repository.addCalculation('calc_456');

    await repository.removeCalculationFavorite('calc_123');

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.referenciaId, 'calc_456');
  });

  test('getAll ordena por fecha de guardado, más reciente primero', () async {
    await repository.toggleRecipe('avena_clasica');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await repository.toggleRecipe('almendra_clasica');

    final all = await repository.getAll();
    expect(all.first.referenciaId, 'almendra_clasica');
    expect(all.last.referenciaId, 'avena_clasica');
  });
}
