import 'package:flutter_test/flutter_test.dart';
import 'package:milqo_flutter/data/models/recipe.dart';
import 'package:milqo_flutter/domain/usecases/scale_recipe_usecase.dart';

/// Escalado de recetas — apartado 9 del checklist: "Pruebas automáticas de
/// los cálculos y del escalado".
void main() {
  final useCase = ScaleRecipeUseCase();

  final recipe = const Recipe(
    id: 'test_recipe',
    ingredientId: 'almendra',
    nombre: 'Receta de prueba',
    tiempoRemojo: '8-12 h',
    tiempoPreparacion: '10 min',
    rindeMl: 1000,
    ingredientes: [
      RecipeIngredientItem(
        textoOriginal: '150 g de almendra',
        nombre: 'almendra',
        cantidadBase: 150,
        unidad: RecipeUnit.gramos,
      ),
      RecipeIngredientItem(
        textoOriginal: '1000 ml de agua',
        nombre: 'agua',
        cantidadBase: 1000,
        unidad: RecipeUnit.mililitros,
      ),
      RecipeIngredientItem(
        textoOriginal: '½ cdta de canela',
        nombre: 'canela',
        cantidadBase: 0.5,
        unidad: RecipeUnit.cucharadita,
      ),
      RecipeIngredientItem(
        textoOriginal: '1 cda de sirope de arce',
        nombre: 'sirope de arce',
        cantidadBase: 1,
        unidad: RecipeUnit.cucharada,
      ),
      RecipeIngredientItem(textoOriginal: 'Pizca de sal', nombre: 'sal'),
    ],
    pasos: ['Paso único'],
    fuentesNombres: ['Fuente de prueba'],
    fuenteUrl: 'https://example.com',
  );

  test('a litros base (1 L) las cantidades no cambian', () {
    final scaled = useCase.scale(recipe, 1);

    expect(scaled[0].cantidadEscaladaTexto, '150 g de almendra');
    expect(scaled[1].cantidadEscaladaTexto, '1000 ml de agua');
  });

  test('escala gramos y mililitros proporcionalmente, redondeando', () {
    final scaled = useCase.scale(recipe, 2.5);

    expect(scaled[0].cantidadEscaladaTexto, '375 g de almendra');
    expect(scaled[1].cantidadEscaladaTexto, '2500 ml de agua');
  });

  test('escala cucharaditas/cucharadas a fracciones simples', () {
    // 0,5 cdta × (0,5/1) = 0,25 cdta
    final scaledDown = useCase.scale(recipe, 0.5);
    expect(scaledDown[2].cantidadEscaladaTexto, '¼ cdta de canela');

    // 1 cda × (5/1) = 5 cda
    final scaledUp = useCase.scale(recipe, 5);
    expect(scaledUp[3].cantidadEscaladaTexto, '5 cda de sirope de arce');
  });

  test('los ingredientes no escalables (pizca, al gusto...) no cambian de texto', () {
    final scaled = useCase.scale(recipe, 5);

    expect(scaled[4].cantidadEscaladaTexto, 'Pizca de sal');
  });

  test('rango permitido de escalado es 0,25 L a 5 L', () {
    expect(ScaleRecipeUseCase.minLitros, 0.25);
    expect(ScaleRecipeUseCase.maxLitros, 5.0);
  });
}
