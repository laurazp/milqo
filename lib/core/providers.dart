import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/calculations_repository.dart';
import '../data/repositories/conversion_repository.dart';
import '../data/repositories/favorites_repository.dart';
import '../data/repositories/ingredients_repository.dart';
import '../data/repositories/recipes_repository.dart';
import '../domain/usecases/calculate_recipe_usecase.dart';
import '../domain/usecases/convert_units_usecase.dart';
import '../domain/usecases/manage_favorites_usecase.dart';
import '../domain/usecases/save_calculation_usecase.dart';
import '../domain/usecases/scale_recipe_usecase.dart';

/// Repository and use case providers — the Riverpod equivalent of what
/// `AppDependencies` used to wire up by hand. Everything here is a plain
/// [Provider]: no backend in v1 (apartado 1), so nothing needs to be async
/// or disposed.
final ingredientsRepositoryProvider = Provider((ref) => IngredientsRepository());
final recipesRepositoryProvider = Provider((ref) => RecipesRepository());
final conversionRepositoryProvider = Provider((ref) => ConversionRepository());
final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());
final calculationsRepositoryProvider = Provider((ref) => CalculationsRepository());

final calculateRecipeUseCaseProvider = Provider(
  (ref) => CalculateRecipeUseCase(
    ingredientsRepository: ref.watch(ingredientsRepositoryProvider),
  ),
);

final scaleRecipeUseCaseProvider = Provider((ref) => ScaleRecipeUseCase());

final convertUnitsUseCaseProvider = Provider(
  (ref) => ConvertUnitsUseCase(
    conversionRepository: ref.watch(conversionRepositoryProvider),
  ),
);

final manageFavoritesUseCaseProvider = Provider(
  (ref) => ManageFavoritesUseCase(
    favoritesRepository: ref.watch(favoritesRepositoryProvider),
  ),
);

final saveCalculationUseCaseProvider = Provider(
  (ref) => SaveCalculationUseCase(
    calculationsRepository: ref.watch(calculationsRepositoryProvider),
    favoritesRepository: ref.watch(favoritesRepositoryProvider),
  ),
);
